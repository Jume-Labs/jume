package jume.math;

import utest.Assert;
import utest.Test;

using jume.math.MathUtils;

class MathUtilsTests extends Test {
  function testLerp() {
    var result = Math.lerp(0, 20, 0);

    Assert.equals(0, result);

    result = Math.lerp(0, 20, 0.5);

    Assert.equals(10, result);

    result = Math.lerp(0, 20, 1);

    Assert.equals(20, result);
  }

  function testClamp() {
    var result = Math.clamp(20.5, 10.3, 44.9);

    Assert.equals(20.5, result);

    result = Math.clamp(5.3, 10.3, 44.9);

    Assert.equals(10.3, result);

    result = Math.clamp(50.23, 10.3, 44.9);

    Assert.equals(44.9, result);
  }

  function testClampInt() {
    var result = Math.clampInt(20, 10, 40);

    Assert.equals(20, result);

    result = Math.clampInt(5, 10, 40);

    Assert.equals(10, result);

    result = Math.clampInt(50, 10, 40);

    Assert.equals(40, result);
  }

  function testMinInt() {
    var result = Math.minInt(5, 8);

    Assert.equals(5, result);

    result = Math.minInt(8, 5);

    Assert.equals(5, result);
  }

  function testMaxInt() {
    var result = Math.maxInt(5, 8);

    Assert.equals(8, result);

    result = Math.maxInt(8, 5);

    Assert.equals(8, result);
  }

  function testToDeg() {
    final deg = Math.toDeg(3.1417);

    Assert.floatEquals(180.00615, deg);
  }

  function testToRad() {
    final rad = Math.toRad(90);

    Assert.floatEquals(1.57079, rad);
  }

  function testDistance() {
    final start = new Vec2(2, 8);
    final end = new Vec2(12, 15);
    final distance = Math.distance(start, end);

    Assert.floatEquals(12.20655, distance);
  }

  function testFuzzyEqual() {
    Assert.isTrue(Math.fuzzyEqual(1.000004, 1.0000089));
    Assert.isFalse(Math.fuzzyEqual(1.004, 1.0089));
    Assert.isFalse(Math.fuzzyEqual(1.000004, 1.0000089, 0.000001));
  }

  function testRotateAround() {
    final pos = new Vec2(0, 100);
    final center = new Vec2(100, 100);

    var result = Math.rotateAround(pos, center, 90);

    Assert.floatEquals(100, result.x);
    Assert.floatEquals(0, result.y);

    result = Math.rotateAround(pos, center, 270);

    Assert.floatEquals(100, result.x);
    Assert.floatEquals(200, result.y);
  }

  function testLineIntersect() {
    final p1Start = new Vec2(1, 1);
    final p1End = new Vec2(5, 5);
    final p2Start = new Vec2(2, 5);
    final p2End = new Vec2(6, 1);
    Assert.isTrue(Math.linesIntersect(p1Start, p1End, p2Start, p2End));

    final result = new Vec2();

    p1Start.set(0, 5);
    p1End.set(10, 5);
    p2Start.set(5, 0);
    p2End.set(5, 10);

    Assert.isTrue(Math.linesIntersect(p1Start, p1End, p2Start, p2End, result));
    Assert.floatEquals(5, result.x);
    Assert.floatEquals(5, result.y);
  }
}
