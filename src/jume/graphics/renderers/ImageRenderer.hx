package jume.graphics.renderers;

import js.html.webgl.GL;
import js.html.webgl.extension.EXTTextureFilterAnisotropic;
import js.lib.Float32Array;
import js.lib.Int32Array;

import jume.graphics.Graphics.TextureParams;
import jume.graphics.bitmapFont.BitmapFont;
import jume.graphics.gl.Context;
import jume.graphics.gl.MipmapFilter;
import jume.math.Rectangle;
import jume.math.Size;
import jume.math.Vec2;
import jume.math.Vec3;

typedef Flip = {
  var x: Bool;
  var y: Bool;
}

/**
 * Renders images and frame buffers.
 */
class ImageRenderer extends BaseRenderer {
  /**
   * Offset per quad.
   * x, y, z positions.
   * u, v texture coordinates.
   * r, g, b, a colors.
   * 4 vertices per quad.
   */
  static inline final OFFSET = 9 * 4;

  static inline final VERTICES_PER_QUAD = 4;

  static inline final INDICES_PER_QUAD = 6;

  /**
   * The current vertex index.
   */
  var index: Int;

  // Temp positions.
  var p1: Vec3;
  var p2: Vec3;
  var p3: Vec3;
  var p4: Vec3;

  var t1: Vec2;
  var t2: Vec2;
  var t3: Vec2;
  var t4: Vec2;

  /**
   * The current batch image.
   */
  var image: Image;

  /**
   * The current batch render target.
   */
  var target: RenderTarget;

  /**
   * Filter extension.
   */
  var anisotropicFilter: EXTTextureFilterAnisotropic;

  var tempPos: Vec2;

  var tempRect: Rectangle;

  var tempSize: Size;

  /**
   * Create a new ImageRenderer instance.
   * @param context The WebGL context.
   */
  public function new(context: Context) {
    super(context);
    index = 0;
    p1 = new Vec3();
    p2 = new Vec3();
    p3 = new Vec3();
    p4 = new Vec3();

    t1 = new Vec2();
    t2 = new Vec2();
    t3 = new Vec2();
    t4 = new Vec2();

    tempPos = new Vec2();
    tempRect = new Rectangle();
    tempSize = new Size();

    #if !headless
    anisotropicFilter = context.gl.getExtension('EXT_texture_filter_anisotropic');
    vertexBuffer = context.gl.createBuffer();
    #end

    vertexIndices = new Float32Array(BUFFER_SIZE * OFFSET);

    #if !headless
    indexBuffer = context.gl.createBuffer();
    #end

    indexIndices = new Int32Array(BUFFER_SIZE * INDICES_PER_QUAD);
    // Set all indices for the quads once, because they don't change.
    for (i in 0...indexIndices.length) {
      indexIndices[i * INDICES_PER_QUAD] = i * VERTICES_PER_QUAD;
      indexIndices[i * INDICES_PER_QUAD + 1] = i * VERTICES_PER_QUAD + 1;
      indexIndices[i * INDICES_PER_QUAD + 2] = i * VERTICES_PER_QUAD + 2;
      indexIndices[i * INDICES_PER_QUAD + 3] = i * VERTICES_PER_QUAD;
      indexIndices[i * INDICES_PER_QUAD + 4] = i * VERTICES_PER_QUAD + 2;
      indexIndices[i * INDICES_PER_QUAD + 5] = i * VERTICES_PER_QUAD + 3;
    }
    createDefaultPipeline();
  }

  /**
   * Send the vertices to the buffer to draw.
   */
  public function present() {
    if (this.index == 0 || (this.target == null && this.image == null)) {
      return;
    }

    pipeline.use();

    #if !headless
    final gl = context.gl;
    gl.uniformMatrix4fv(pipeline.projectionLocation, false, projection);
    gl.activeTexture(GL.TEXTURE0);
    if (this.target != null) {
      gl.bindTexture(GL.TEXTURE_2D, target.texture);
      setTextureParameters({
        texUnit: 0,
        uWrap: target.uWrap,
        vWrap: target.vWrap,
        minFilter: target.minFilter,
        magFilter: target.magFilter,
        mipmapFilter: MipmapFilter.NONE
      });
    } else if (image != null) {
      gl.bindTexture(GL.TEXTURE_2D, image.texture);
      setTextureParameters({
        texUnit: 0,
        uWrap: image.uWrap,
        vWrap: image.vWrap,
        minFilter: image.minFilter,
        magFilter: image.magFilter,
        mipmapFilter: MipmapFilter.NONE
      });
      if (pipeline.textureLocation != null) {
        gl.uniform1i(pipeline.textureLocation, 0);
      } else {
        return;
      }
    }

    gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(GL.ARRAY_BUFFER, vertexIndices, GL.DYNAMIC_DRAW);
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, indexIndices, GL.STATIC_DRAW);

    gl.vertexAttribPointer(pipeline.vertexPositionLocation, 3, GL.FLOAT, false, FLOAT_SIZE * 9, 0);
    gl.enableVertexAttribArray(pipeline.vertexPositionLocation);
    gl.vertexAttribPointer(pipeline.vertexColorLocation, 4, GL.FLOAT, false, FLOAT_SIZE * 9, FLOAT_SIZE * 3);
    gl.enableVertexAttribArray(pipeline.vertexColorLocation);
    gl.vertexAttribPointer(pipeline.vertexUVLocation, 2, GL.FLOAT, false, FLOAT_SIZE * 9, FLOAT_SIZE * 7);
    gl.enableVertexAttribArray(pipeline.vertexUVLocation);

    gl.drawElements(GL.TRIANGLES, index * INDICES_PER_QUAD, GL.UNSIGNED_INT, 0);

    gl.bindBuffer(GL.ARRAY_BUFFER, null);
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
    gl.disableVertexAttribArray(pipeline.vertexPositionLocation);
    gl.disableVertexAttribArray(pipeline.vertexColorLocation);
    gl.disableVertexAttribArray(pipeline.vertexUVLocation);
    #end

    index = 0;
    image = null;
    target = null;
  }

  /**
   * Draw an image into the buffer.
   * @param position The position in pixels.
   * @param image The image to draw.
   * @param flip Flip the image on the x or y axis.
   */
  public inline function drawImage(position: Vec2, image: Image, flip: Flip) {
    tempRect.set(0, 0, image.width, image.height);
    drawImageSection(position, tempRect, image, flip);
  }

  /**
   * Draw an image with a custom size into the buffer.
   * @param position The position in pixels.
   * @param size The custom image size in pixels.
   * @param image The image to draw.
   * @param flip Flip the image on the x or y axis.
   */
  public inline function drawScaledImage(position: Vec2, size: Size, image: Image, flip: Flip) {
    tempRect.set(0, 0, image.width, image.height);
    drawScaledImageSection(position, size, tempRect, image, flip);
  }

  /**
   * Draw a section of an image.
   * @param position The position in pixels.
   * @param rect The rect inside the source image in pixels.
   * @param image The source image.
   * @param flip Flip the image on the x or y axis.
   */
  public inline function drawImageSection(position: Vec2, rect: Rectangle, image: Image, flip: Flip) {
    tempSize.set(rect.width, rect.height);
    drawScaledImageSection(position, tempSize, rect, image, flip);
  }

  /**
   * Draw a section of an image and set a custom image size.
   * @param position The position in pixels.
   * @param size The custom image size in pixels.
   * @param rect The rect inside the source image in pixels.
   * @param image The source image.
   * @param flip Flip the image on the x or y axis.
   */
  public function drawScaledImageSection(position: Vec2, size: Size, rect: Rectangle, image: Image, flip: Flip) {
    if (index >= BUFFER_SIZE || target != null || (this.image != null && this.image != image)) {
      present();
    }
    this.image = image;
    p1.transformMat4(position.x, position.y, 0, currentTransform);
    p2.transformMat4(position.x + size.width, position.y, 0, currentTransform);
    p3.transformMat4(position.x + size.width, position.y + size.height, 0, currentTransform);
    p4.transformMat4(position.x, position.y + size.height, 0, currentTransform);
    final textureWidth = image.width;
    final textureHeight = image.height;
    setTransformVertices(p1, p2, p3, p4);
    setColorVertices();

    if (flip.x && flip.y) {
      t1.set((rect.x + rect.width) / textureWidth, (rect.y + rect.height) / textureHeight);
      t2.set(rect.x / textureWidth, (rect.y + rect.height) / textureHeight);
      t3.set(rect.x / textureWidth, rect.y / textureHeight);
      t4.set((rect.x + rect.width) / textureWidth, rect.y / textureHeight);
      setTextureCoords(t1, t2, t3, t4);
    } else if (flip.x) {
      t1.set(rect.x / textureWidth, (rect.y + rect.height) / textureHeight);
      t2.set((rect.x + rect.width) / textureWidth, (rect.y + rect.height) / textureHeight);
      t3.set((rect.x + rect.width) / textureWidth, rect.y / textureHeight);
      t4.set(rect.x / textureWidth, rect.y / textureHeight);
      setTextureCoords(t1, t2, t3, t4);
    } else if (flip.y) {
      t1.set((rect.x + rect.width) / textureWidth, rect.y / textureHeight);
      t2.set(rect.x / textureWidth, rect.y / textureHeight);
      t3.set(rect.x / textureWidth, (rect.y + rect.height) / textureHeight);
      t4.set((rect.x + rect.width) / textureWidth, (rect.y + rect.height) / textureHeight);
      setTextureCoords(t1, t2, t3, t4);
    } else {
      t1.set(rect.x / textureWidth, rect.y / textureHeight);
      t2.set((rect.x + rect.width) / textureWidth, rect.y / textureHeight);
      t3.set((rect.x + rect.width) / textureWidth, (rect.y + rect.height) / textureHeight);
      t4.set(rect.x / textureWidth, (rect.y + rect.height) / textureHeight);
      setTextureCoords(t1, t2, t3, t4);
    }
    index++;
  }

  /**
   * Draw an image that is not uniform by specifying each point.
   * @param tl The top left position in pixels.
   * @param tr The top right position in pixels.
   * @param br The bottom right position in pixels.
   * @param bl The bottom left position in pixels.
   * @param image The image to draw.
   */
  public function drawImagePoints(tl: Vec2, tr: Vec2, br: Vec2, bl: Vec2, image: Image) {
    tempRect.set(0, 0, image.width, image.height);
    drawImageSectionPoints(tl, tr, br, bl, tempRect, image);
  }

  /**
   * 
   * Draw an image part that is not uniform by specifying each point.
   * @param tl The top left position in pixels.
   * @param tr The top right position in pixels.
   * @param br The bottom right position in pixels.
   * @param bl The bottom left position in pixels.
   * @param rect The rectangle of the section inside the image in pixels.
   * @param image The image to draw.
   */
  @SuppressWarnings('checkstyle:ParameterNumber')
  public function drawImageSectionPoints(tl: Vec2, tr: Vec2, br: Vec2, bl: Vec2, rect: Rectangle, image: Image) {
    if (index >= BUFFER_SIZE || target != null || (this.image != null && this.image != image)) {
      present();
    }
    this.image = image;
    p1.transformMat4(tl.x, tl.y, 0, currentTransform);
    p2.transformMat4(tr.x, tr.y, 0, currentTransform);
    p3.transformMat4(br.x, br.y, 0, currentTransform);
    p4.transformMat4(bl.x, bl.y, 0, currentTransform);
    final textureWidth = image.width;
    final textureHeight = image.height;
    setTransformVertices(p1, p2, p3, p4);
    setColorVertices();

    t1.set(rect.x / textureWidth, rect.y / textureHeight);
    t2.set((rect.x + rect.width) / textureWidth, rect.y / textureHeight);
    t3.set((rect.x + rect.width) / textureWidth, (rect.y + rect.height) / textureHeight);
    t3.set(rect.x / textureWidth, (rect.y + rect.height) / textureHeight);
    setTextureCoords(t1, t2, t3, t4);
    index++;
  }

  /**
   * Draw a render target to the screen.
   * @param position The position in pixels.
   * @param target The target to render.
   */
  public function drawRenderTarget(position: Vec2, target: RenderTarget) {
    if (index >= BUFFER_SIZE || image != null || (this.target != null && this.target != target)) {
      present();
    }
    this.target = target;
    final width = target.width;
    final height = target.height;
    p1.transformMat4(position.x, position.y, 0, currentTransform);
    p2.transformMat4(position.x + width, position.y, 0, currentTransform);
    p3.transformMat4(position.x + width, position.y + height, 0, currentTransform);
    p4.transformMat4(position.x, position.y + height, 0, currentTransform);
    setTransformVertices(p1, p2, p3, p4);
    setColorVertices();

    t1.set(0.0, 1.0);
    t2.set(1.0, 1.0);
    t3.set(1.0, 0.0);
    t4.set(0.0, 0.0);
    setTextureCoords(t1, t2, t3, t4);
    index++;
  }

  /**
   * Draw a string using a bitmap font.
   * @param position The position in pixels.
   * @param text The text to draw.
   * @param font The bitmap font to use.
   */
  public function drawBitmapText(position: Vec2, font: BitmapFont, text: String) {
    if (text == '') {
      return;
    }
    if (index >= BUFFER_SIZE || (image != null && image != font.image)) {
      present();
    }
    image = font.image;
    var xOffset = 0;
    for (i in 0...text.length) {
      final char = text.charCodeAt(i);
      final charData = font.getCharData(char);
      if (charData == null) {
        continue;
      }
      if (index >= BUFFER_SIZE) {
        present();
      }
      var kerning = 0;
      if (i > 0) {
        final prevChar = text.charCodeAt(i - 1);
        kerning = font.getKerning(prevChar, char);
      }
      xOffset += kerning;
      // Apply the transformation matrix to the vertex positions.
      p1.transformMat4(position.x + xOffset + charData.xOffset, position.y + charData.yOffset, 0, currentTransform);
      p2.transformMat4(position.x + xOffset + charData.xOffset + charData.width, position.y + charData.yOffset, 0,
        currentTransform);
      p3.transformMat4(position.x + xOffset + charData.xOffset + charData.width,
        position.y + charData.yOffset + charData.height, 0, currentTransform);
      p4.transformMat4(position.x + xOffset + charData.xOffset, position.y + charData.yOffset + charData.height, 0,
        currentTransform);
      setTransformVertices(p1, p2, p3, p4);
      setColorVertices();

      t1.set(charData.x / font.image.width, charData.y / font.image.height);
      t2.set((charData.x + charData.width) / font.image.width, charData.y / font.image.height);
      t3.set((charData.x + charData.width) / font.image.width, (charData.y + charData.height) / font.image.height);
      t4.set(charData.x / font.image.width, (charData.y + charData.height) / font.image.height);
      setTextureCoords(t1, t2, t3, t4);
      xOffset += charData.xAdvance;
      index++;
    }
  }

  public function setTextureParameters(params: TextureParams) {
    final gl = context.gl;
    gl.activeTexture(GL.TEXTURE0 + params.texUnit);

    final tex2d = GL.TEXTURE_2D;
    gl.texParameteri(tex2d, GL.TEXTURE_WRAP_S, context.getTextureWrap(params.uWrap));
    gl.texParameteri(tex2d, GL.TEXTURE_WRAP_T, context.getTextureWrap(params.vWrap));
    gl.texParameteri(tex2d, GL.TEXTURE_MIN_FILTER, context.getTextureFilter(params.minFilter));
    gl.texParameteri(tex2d, GL.TEXTURE_MAG_FILTER, context.getTextureFilter(params.magFilter));

    if (params.minFilter == ANISOTROPIC && anisotropicFilter != null) {
      gl.texParameteri(tex2d, EXTTextureFilterAnisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT, 4);
    }
  }

  /**
   * Set the vertex positions for an image.
   * @param topLeft The top left point of the image.
   * @param topRight The top right point of the image.
   * @param bottomRight The bottom right point of the image.
   * @param bottomLeft The bottom left point of the image.
   */
  function setTransformVertices(topLeft: Vec3, topRight: Vec3, bottomRight: Vec3, bottomLeft: Vec3) {
    final i = index * OFFSET;
    vertexIndices[i] = topLeft.x;
    vertexIndices[i + 1] = topLeft.y;
    vertexIndices[i + 2] = 0;
    vertexIndices[i + 9] = topRight.x;
    vertexIndices[i + 10] = topRight.y;
    vertexIndices[i + 11] = 0;
    vertexIndices[i + 18] = bottomRight.x;
    vertexIndices[i + 19] = bottomRight.y;
    vertexIndices[i + 20] = 0;
    vertexIndices[i + 27] = bottomLeft.x;
    vertexIndices[i + 28] = bottomLeft.y;
    vertexIndices[i + 29] = 0;
  }

  /**
   * Set the tint color for an image.
   */
  function setColorVertices() {
    final i = index * OFFSET;

    final r = currentColor.red;
    final g = currentColor.green;
    final b = currentColor.blue;
    final a = currentColor.alpha;

    vertexIndices[i + 3] = r;
    vertexIndices[i + 4] = g;
    vertexIndices[i + 5] = b;
    vertexIndices[i + 6] = a;
    vertexIndices[i + 12] = r;
    vertexIndices[i + 13] = g;
    vertexIndices[i + 14] = b;
    vertexIndices[i + 15] = a;
    vertexIndices[i + 21] = r;
    vertexIndices[i + 22] = g;
    vertexIndices[i + 23] = b;
    vertexIndices[i + 24] = a;
    vertexIndices[i + 30] = r;
    vertexIndices[i + 31] = g;
    vertexIndices[i + 32] = b;
    vertexIndices[i + 33] = a;
  }

  /**
   * Set the uv coordinates for an image.
   */
  function setTextureCoords(tl: Vec2, tr: Vec2, br: Vec2, bl: Vec2) {
    final i = index * OFFSET;
    vertexIndices[i + 7] = tl.x;
    vertexIndices[i + 8] = tl.y;
    vertexIndices[i + 16] = tr.x;
    vertexIndices[i + 17] = tr.y;
    vertexIndices[i + 25] = br.x;
    vertexIndices[i + 26] = br.y;
    vertexIndices[i + 34] = bl.x;
    vertexIndices[i + 35] = bl.y;
  }

  /**
   * Create the default shader pipeline.
   */
  function createDefaultPipeline() {
    final vertexSource = DefaultShaders.imageVert(context.isGL1);
    final vertexShader = new Shader(vertexSource, VERTEX);

    final fragmentSource = DefaultShaders.imageFrag(context.isGL1);
    final fragmentShader = new Shader(fragmentSource, FRAGMENT);

    defaultPipeline = new Pipeline(vertexShader, fragmentShader, true);
    pipeline = defaultPipeline;
  }
}
