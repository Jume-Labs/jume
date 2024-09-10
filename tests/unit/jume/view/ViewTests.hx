package jume.view;

import jume.view.ScaleModes.scaleModeStretch;

import utest.Assert;
import utest.Test;

class ViewTests extends Test {
  function testNewView() {
    final view = new View({
      width: 400,
      height: 300,
      pixelFilter: true,
      pixelRatio: 1,
      isFullScreen: true,
      canvasId: 'jume',
      targetFps: 60
    });

    Assert.equals(1, view.pixelRatio);
    Assert.isTrue(view.pixelFilter);
    Assert.isTrue(view.isFullScreen);

    Assert.equals(400, view.designWidth);
    Assert.equals(300, view.designHeight);

    Assert.equals(800, view.canvasWidth);
    Assert.equals(600, view.canvasHeight);
    Assert.equals(400, view.canvasCenterX);
    Assert.equals(300, view.canvasCenterY);

    Assert.equals(400, view.viewWidth);
    Assert.equals(300, view.viewHeight);
    Assert.equals(200, view.viewCenterX);
    Assert.equals(150, view.viewCenterY);

    Assert.equals(2, view.viewScaleX);
    Assert.equals(2, view.viewScaleY);
  }

  function testSetScaleMode() {
    final view = new View({
      width: 200,
      height: 300,
      pixelFilter: true,
      pixelRatio: 1,
      isFullScreen: true,
      canvasId: 'jume',
      targetFps: 60
    });
    view.setScaleMode(scaleModeStretch);

    Assert.equals(200, view.viewWidth);
    Assert.equals(300, view.viewHeight);

    Assert.equals(4, view.viewScaleX);
    Assert.equals(2, view.viewScaleY);
  }
}
