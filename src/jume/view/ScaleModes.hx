package jume.view;

/**
 * The values returned from a scale mode function.
 */
typedef ScaleModeReturn = {
  /**
   * The scaled game view width in pixels.
   */
  var viewWidth: Int;

  /**
   * The scaled game view heigh in pixels.
   */
  var viewHeight: Int;

  /**
   * The amount scaled on the x axis.
   */
  var scaleFactorX: Float;

  /**
   * The amount scaled on the y axis.
   */
  var scaleFactorY: Float;

  /**
   * The horizontal view offset inside the canvas in pixels.
   */
  var offsetX: Float;

  /**
   * The vertical view offset inside the canvas in pixels.
   */
  var offsetY: Float;
}

/**
 * The parameters passed into a scale mode function.
 */
typedef ScaleModeParams = {
  /**
   * The width in pixels the game is designed for before scaling.
   */
  var designWidth: Int;

  /**
   * The height in pixels the game is designed for before scaling.
   */
  var designHeight: Int;

  /**
   * The html canvas width in pixels.
   */
  var canvasWidth: Int;

  /**
   * The html canvas width in pixels.
   */
  var canvasHeight: Int;

  /**
   * The horizontal anchor in the screen (0 - 1).
   */
  var anchorX: Float;

  /**
   * The vertical anchor in the screen (0 - 1).
   */
  var anchorY: Float;
}

/**
 * The scale mode function blueprint.
 */
typedef ScaleMode = (params: ScaleModeParams) -> ScaleModeReturn;

/**
 * Scale the view to fit the canvas. Will cut off parts of the view to make it fit. Keeps aspect ratio.
 * @param params The scale mode parameters.
 * @return The scaled values.
 */
function scaleModeFitView(params: ScaleModeParams): ScaleModeReturn {
  final designRatio = params.designWidth / params.designHeight;
  final canvasRatio = params.canvasWidth / params.canvasHeight;

  var viewWidth = 0;
  var viewHeight = 0;
  if (canvasRatio < designRatio) {
    viewWidth = params.designWidth;
    viewHeight = Math.ceil(viewWidth / canvasRatio);
  } else {
    viewHeight = params.designHeight;
    viewWidth = Math.ceil(viewHeight * canvasRatio);
  }

  final scaleFactor = params.canvasWidth / viewWidth;

  final offsetX = (params.canvasWidth - params.designWidth * scaleFactor) * params.anchorX;
  final offsetY = (params.canvasHeight - params.designHeight * scaleFactor) * params.anchorY;

  return {
    viewWidth: viewWidth,
    viewHeight: viewHeight,
    scaleFactorX: scaleFactor,
    scaleFactorY: scaleFactor,
    offsetX: offsetX,
    offsetY: offsetY
  };
}

/**
 * Scale the view to fit the design resolution.
 * @param params The scale mode parameters.
 * @return The scaled values.
 */
function scaleModeFitDesign(params: ScaleModeParams): ScaleModeReturn {
  final designRatio = params.designWidth / params.designHeight;
  final canvasRatio = params.canvasWidth / params.canvasHeight;

  var viewWidth = 0;
  var viewHeight = 0;
  if (canvasRatio > designRatio) {
    viewWidth = params.designWidth;
    viewHeight = Math.ceil(viewWidth / canvasRatio);
  } else {
    viewHeight = params.designHeight;
    viewWidth = Math.ceil(viewHeight * canvasRatio);
  }

  final scaleFactor = params.canvasWidth / viewWidth;

  final offsetX = (params.canvasWidth - params.designWidth * scaleFactor) * params.anchorX;
  final offsetY = (params.canvasHeight - params.designHeight * scaleFactor) * params.anchorY;

  return {
    viewWidth: viewWidth,
    viewHeight: viewHeight,
    scaleFactorX: scaleFactor,
    scaleFactorY: scaleFactor,
    offsetX: offsetX,
    offsetY: offsetY
  };
}

/**
 * Scale the view to fit the width of the canvas. Will cut off parts at the top and bottom to fit. Keeps aspect ratio.
 * @param params The scale mode parameters.
 * @return The scaled values.
 */
function scaleModeFitWidth(params: ScaleModeParams): ScaleModeReturn {
  final canvasRatio = params.canvasWidth / params.canvasHeight;
  final viewWidth = params.designWidth;
  final viewHeight = Math.ceil(viewWidth / canvasRatio);
  final scaleFactor = params.canvasWidth / viewWidth;
  final offsetX = (params.canvasWidth - params.designWidth * scaleFactor) * params.anchorX;
  final offsetY = (params.canvasHeight - params.designHeight * scaleFactor) * params.anchorY;

  return {
    viewWidth: viewWidth,
    viewHeight: viewHeight,
    scaleFactorX: scaleFactor,
    scaleFactorY: scaleFactor,
    offsetX: offsetX,
    offsetY: offsetY
  };
}

/**
 * Scale the view to fit the height of the canvas. Will cut off parts at the left and right to fit. Keeps aspect ratio.
 * @param params The scale mode parameters.
 * @return The scaled values.
 */
function scaleModeFitHeight(params: ScaleModeParams): ScaleModeReturn {
  final canvasRatio = params.canvasWidth / params.canvasHeight;
  final viewHeight = params.designHeight;
  final viewWidth = Math.ceil(viewHeight * canvasRatio);

  final scaleFactor = params.canvasHeight / viewHeight;

  final offsetX = (params.canvasWidth - params.designWidth * scaleFactor) * params.anchorX;
  final offsetY = (params.canvasHeight - params.designHeight * scaleFactor) * params.anchorY;

  return {
    viewWidth: viewWidth,
    viewHeight: viewHeight,
    scaleFactorX: scaleFactor,
    scaleFactorY: scaleFactor,
    offsetX: offsetX,
    offsetY: offsetY
  };
}

/**
 * Don't scale the view. Just offset it inside the canvas if needed.
 * @param params The scale mode parameters.
 * @return The scaled values.
 */
function scaleModeNoScale(params: ScaleModeParams): ScaleModeReturn {
  final offsetX = (params.canvasWidth - params.designWidth) * params.anchorX;
  final offsetY = (params.canvasHeight - params.designHeight) * params.anchorY;

  return {
    viewWidth: params.designWidth,
    viewHeight: params.designHeight,
    scaleFactorX: 1.0,
    scaleFactorY: 1.0,
    offsetX: offsetX,
    offsetY: offsetY
  };
}

/**
 * Stretch the view to fit the canvas. Does not keep the aspect ratio and can distort the view.
 * @param params The scale mode parameters.
 * @return The scaled values.
 */
function scaleModeStretch(params: ScaleModeParams): ScaleModeReturn {
  final viewWidth = params.designWidth;
  final viewHeight = params.designHeight;

  final scaleFactorX = params.canvasWidth / viewWidth;
  final scaleFactorY = params.canvasHeight / viewHeight;

  return {
    viewWidth: viewWidth,
    viewHeight: viewHeight,
    scaleFactorX: scaleFactorX,
    scaleFactorY: scaleFactorY,
    offsetX: 0,
    offsetY: 0
  };
}
