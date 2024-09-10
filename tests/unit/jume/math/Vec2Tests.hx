package jume.math;

import utest.Assert;
import utest.Test;

class Vec2Tests extends Test {
  function testPool() {
    final vec = Vec2.get(50, 30);
    vec.put();

    final next = Vec2.get();

    Assert.equals(vec, next);
    Assert.equals(0, next.x);
    Assert.equals(0, next.y);
  }

  function testAddVectors() {
    final first = new Vec2(20, 30);
    final second = new Vec2(30, 50);
    final result = first + second;

    Assert.equals(50, result.x);
    Assert.equals(80, result.y);
  }

  function testSubVectors() {
    final first = new Vec2(50, 100);
    final second = new Vec2(30, 50);
    final result = first - second;

    Assert.equals(20, result.x);
    Assert.equals(50, result.y);
  }

  function testMulVectors() {
    final first = new Vec2(10, 20);
    final second = new Vec2(3, 5);
    final result = first * second;

    Assert.equals(30, result.x);
    Assert.equals(100, result.y);
  }

  function testDivVectors() {
    final first = new Vec2(12, 35);
    final second = new Vec2(3, 5);
    final result = first / second;

    Assert.equals(4, result.x);
    Assert.equals(7, result.y);
  }

  function testDistance() {
    final first = new Vec2(1, 1);
    final second = new Vec2(12, 6);
    final distance = Vec2.distance(first, second);

    Assert.floatEquals(12.08304, distance);
  }

  function testNewEmpty() {
    final vec = new Vec2();

    Assert.equals(0, vec.x);
    Assert.equals(0, vec.y);
  }

  function testNewValues() {
    final vec = new Vec2(2.4, 5.7);

    Assert.equals(2.4, vec.x);
    Assert.equals(5.7, vec.y);
  }

  function testIntValues() {
    final vec = new Vec2(3.68, 13.56);

    Assert.equals(3, vec.xi);
    Assert.equals(13, vec.yi);
  }

  function testLength() {
    final vec = new Vec2(20, 10);

    Assert.floatEquals(22.36067, vec.length);

    vec.length = 10;

    Assert.floatEquals(8.94427, vec.x);
    Assert.floatEquals(4.47213, vec.y);
  }

  function testClone() {
    final vec = new Vec2(23.4, 56.7);
    final clone = vec.clone();

    Assert.notEquals(vec, clone);
    Assert.isTrue(vec == clone);
  }

  function testCopyFrom() {
    final other = new Vec2(2, 5);
    final vec = new Vec2();
    vec.copyFrom(other);

    Assert.isTrue(vec == other);
  }

  function testEquals() {
    final one = new Vec2(2, 5);
    final two = new Vec2(2, 5);
    final three = new Vec2(4, 9);

    Assert.isTrue(one == two);
    Assert.isFalse(one == three);

    Assert.isTrue(one != three);
    Assert.isFalse(one != two);
  }

  function testAdd() {
    final vec = new Vec2(4, 8);
    final other = new Vec2(2, 4);

    vec += other;

    Assert.equals(6, vec.x);
    Assert.equals(12, vec.y);

    Assert.equals(2, other.x);
    Assert.equals(4, other.y);
  }

  function testSub() {
    final vec = new Vec2(4, 8);
    final other = new Vec2(2, 4);

    vec -= other;

    Assert.equals(2, vec.x);
    Assert.equals(4, vec.y);

    Assert.equals(2, other.x);
    Assert.equals(4, other.y);
  }

  function testMul() {
    final vec = new Vec2(4, 8);
    final other = new Vec2(2, 4);

    vec *= other;

    Assert.equals(8, vec.x);
    Assert.equals(32, vec.y);

    Assert.equals(2, other.x);
    Assert.equals(4, other.y);
  }

  function testDiv() {
    final vec = new Vec2(4, 8);
    final other = new Vec2(2, 4);

    vec /= other;

    Assert.equals(2, vec.x);
    Assert.equals(2, vec.y);

    Assert.equals(2, other.x);
    Assert.equals(4, other.y);
  }

  function testDot() {
    final first = new Vec2(3, 6);
    final second = new Vec2(12, 24);

    final product = first.dot(second);

    Assert.equals(180, product);
  }

  function testNormalize() {
    final vec = new Vec2(20, 10);
    vec.normalize();

    Assert.floatEquals(10, vec.x);
    Assert.floatEquals(5, vec.y);
  }

  function testRotateAround() {
    final vec = new Vec2(0, 0);
    vec.rotateAround(0, 5, 45);

    Assert.floatEquals(-3.53553, vec.x);
    Assert.floatEquals(-3.53553, vec.y);
  }

  function testToString() {
    final vec = new Vec2(2.4, 6.7);
    final expected = '{ x: 2.4, y: 6.7 }';

    Assert.equals(expected, vec.toString());
  }
}
