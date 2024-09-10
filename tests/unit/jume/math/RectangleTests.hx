package jume.math;

import utest.Assert;
import utest.Test;

class RectangleTests extends Test {
  function testNew() {
    var rect = new Rectangle();

    Assert.equals(0, rect.x);
    Assert.equals(0, rect.y);
    Assert.equals(0, rect.width);
    Assert.equals(0, rect.height);

    rect = new Rectangle(1.3, 3.4, 5.6, 8.7);

    Assert.equals(1.3, rect.x);
    Assert.equals(3.4, rect.y);
    Assert.equals(5.6, rect.width);
    Assert.equals(8.7, rect.height);
  }

  function testIntegerValues() {
    final rect = new Rectangle(1.3, 3.4, 5.6, 8.7);

    Assert.equals(1, rect.xi);
    Assert.equals(3, rect.yi);
    Assert.equals(5, rect.widthi);
    Assert.equals(8, rect.heighti);
  }

  function testHasPosition() {
    final rect = new Rectangle(10, 10, 100, 100);

    Assert.isTrue(rect.hasPosition(12, 12));
    Assert.isTrue(rect.hasPosition(109, 109));

    Assert.isFalse(rect.hasPosition(12, 9));
    Assert.isFalse(rect.hasPosition(9, 50));
    Assert.isFalse(rect.hasPosition(111, 50));
    Assert.isFalse(rect.hasPosition(12, 111));
  }

  function testIntersects() {
    final rect = new Rectangle(50, 80, 100, 100);
    final rect2 = new Rectangle(60, 100, 10, 10);

    Assert.isTrue(rect.intersects(rect2));

    rect2.set(10, 10, 20, 20);
    Assert.isFalse(rect.intersects(rect2));

    rect2.set(45, 75, 20, 20);
    Assert.isTrue(rect.intersects(rect2));
  }

  function testSet() {
    final rect = new Rectangle();
    Assert.equals(0, rect.x);
    Assert.equals(0, rect.y);
    Assert.equals(0, rect.width);
    Assert.equals(0, rect.height);
  }

  function testIntersectsLine() {
    final rect = new Rectangle(50, 50, 100, 100);
    final vec = new Vec2();

    final lineStart = new Vec2(100, 0);
    final lineEnd = new Vec2(100, 300);
    final result = rect.intersectsLine(lineStart, lineEnd, vec);

    Assert.isTrue(result);
    Assert.floatEquals(100, vec.x);
    Assert.floatEquals(50, vec.y);
  }

  function testToString() {
    final rect = new Rectangle(20, 45.6, 80, 53.1);
    final result = '{ x: 20, y: 45.6, w: 80, h: 53.1 }';

    Assert.equals(result, rect.toString());
  }
}
