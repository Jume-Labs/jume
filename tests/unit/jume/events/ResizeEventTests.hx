package jume.events;

import utest.Assert;
import utest.Test;

class ResizeEventTests extends Test {
  function testEventGetter() {
    final event = ResizeEvent.get(ResizeEvent.RESIZE, 800, 600);

    Assert.equals(800, event.width);
    Assert.equals(600, event.height);
  }
}
