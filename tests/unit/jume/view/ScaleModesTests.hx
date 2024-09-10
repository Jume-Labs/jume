package jume.view;

import jume.view.ScaleModes.scaleModeStretch;
import jume.view.ScaleModes.scaleModeNoScale;
import jume.view.ScaleModes.scaleModeFitHeight;
import jume.view.ScaleModes.scaleModeFitWidth;

import utest.Assert;

import jume.view.ScaleModes.scaleModeFitView;

import utest.Test;

class ScaleModesTests extends Test {
  function testScaleModeFitView() {
    var result = scaleModeFitView({
      designWidth: 200,
      designHeight: 400,
      canvasWidth: 600,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(300, result.viewWidth);
    Assert.equals(400, result.viewHeight);
    Assert.floatEquals(2, result.scaleFactorX);
    Assert.floatEquals(2, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeFitView({
      designWidth: 100,
      designHeight: 300,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(150, result.viewWidth);
    Assert.equals(300, result.viewHeight);
    Assert.floatEquals(2.66666, result.scaleFactorX);
    Assert.floatEquals(2.66666, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeFitView({
      designWidth: 400,
      designHeight: 200,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(400, result.viewWidth);
    Assert.equals(800, result.viewHeight);
    Assert.floatEquals(1, result.scaleFactorX);
    Assert.floatEquals(1, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);
  }

  function testScaleModeFitWidth() {
    var result = scaleModeFitWidth({
      designWidth: 200,
      designHeight: 400,
      canvasWidth: 600,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(200, result.viewWidth);
    Assert.equals(267, result.viewHeight);
    Assert.floatEquals(3, result.scaleFactorX);
    Assert.floatEquals(3, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeFitWidth({
      designWidth: 100,
      designHeight: 300,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(100, result.viewWidth);
    Assert.equals(200, result.viewHeight);
    Assert.floatEquals(4, result.scaleFactorX);
    Assert.floatEquals(4, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeFitWidth({
      designWidth: 400,
      designHeight: 200,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(400, result.viewWidth);
    Assert.equals(800, result.viewHeight);
    Assert.floatEquals(1, result.scaleFactorX);
    Assert.floatEquals(1, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);
  }

  function testScaleModeFitHeight() {
    var result = scaleModeFitHeight({
      designWidth: 200,
      designHeight: 400,
      canvasWidth: 600,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(300, result.viewWidth);
    Assert.equals(400, result.viewHeight);
    Assert.floatEquals(2, result.scaleFactorX);
    Assert.floatEquals(2, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeFitHeight({
      designWidth: 100,
      designHeight: 300,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(150, result.viewWidth);
    Assert.equals(300, result.viewHeight);
    Assert.floatEquals(2.66666, result.scaleFactorX);
    Assert.floatEquals(2.66666, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeFitHeight({
      designWidth: 400,
      designHeight: 200,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(100, result.viewWidth);
    Assert.equals(200, result.viewHeight);
    Assert.floatEquals(4, result.scaleFactorX);
    Assert.floatEquals(4, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);
  }

  function testScaleModeNoScale() {
    var result = scaleModeNoScale({
      designWidth: 200,
      designHeight: 400,
      canvasWidth: 600,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(200, result.viewWidth);
    Assert.equals(400, result.viewHeight);
    Assert.floatEquals(1, result.scaleFactorX);
    Assert.floatEquals(1, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeNoScale({
      designWidth: 100,
      designHeight: 300,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(100, result.viewWidth);
    Assert.equals(300, result.viewHeight);
    Assert.floatEquals(1, result.scaleFactorX);
    Assert.floatEquals(1, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeNoScale({
      designWidth: 400,
      designHeight: 200,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(400, result.viewWidth);
    Assert.equals(200, result.viewHeight);
    Assert.floatEquals(1, result.scaleFactorX);
    Assert.floatEquals(1, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);
  }

  function testScaleModeStretch() {
    var result = scaleModeStretch({
      designWidth: 200,
      designHeight: 400,
      canvasWidth: 600,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(200, result.viewWidth);
    Assert.equals(400, result.viewHeight);
    Assert.floatEquals(3, result.scaleFactorX);
    Assert.floatEquals(2, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeStretch({
      designWidth: 100,
      designHeight: 300,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(100, result.viewWidth);
    Assert.equals(300, result.viewHeight);
    Assert.floatEquals(4, result.scaleFactorX);
    Assert.floatEquals(2.66666, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);

    result = scaleModeStretch({
      designWidth: 400,
      designHeight: 200,
      canvasWidth: 400,
      canvasHeight: 800,
      anchorX: 0,
      anchorY: 0
    });

    Assert.equals(400, result.viewWidth);
    Assert.equals(200, result.viewHeight);
    Assert.floatEquals(1, result.scaleFactorX);
    Assert.floatEquals(4, result.scaleFactorY);
    Assert.floatEquals(0, result.offsetX);
    Assert.floatEquals(0, result.offsetY);
  }
}
