package jume.math;

import utest.Assert;
import utest.Test;

class Vec3Tests extends Test {
  function testNewEmptyVec3() {
    final vec = new Vec3();

    Assert.equals(0.0, vec.x);
    Assert.equals(0.0, vec.y);
    Assert.equals(0.0, vec.x);
  }

  function testNewValues() {
    final vec = new Vec3(2.3, 3.5, 4.8);

    Assert.equals(2.3, vec.x);
    Assert.equals(3.5, vec.y);
    Assert.equals(4.8, vec.z);
  }

  function testGettersSetters() {
    final vec = new Vec3(1.2, 2.3, 3.4);

    Assert.equals(1.2, vec.x);
    Assert.equals(2.3, vec.y);
    Assert.equals(3.4, vec.z);

    vec.x = 2;
    vec.y = 3;
    vec.z = 4;

    Assert.equals(2, vec.x);
    Assert.equals(3, vec.y);
    Assert.equals(4, vec.z);
  }

  function testSet() {
    final vec = new Vec3();
    vec.set(3, 4, 5);

    Assert.equals(3, vec.x);
    Assert.equals(4, vec.y);
    Assert.equals(5, vec.z);
  }

  function testEquals() {
    final vec1 = new Vec3(2.4, 4.6, 2.8);
    final vec2 = new Vec3(2.4, 4.6, 2.8);

    Assert.notEquals(vec1, vec2);
    Assert.isTrue(vec1.equals(vec2));
  }

  function testNotEquals() {
    final vec1 = new Vec3(2.3, 5.6, 9.8);
    final vec2 = new Vec3(2.4, 4.6, 2.8);

    Assert.notEquals(vec1, vec2);
    Assert.isTrue(vec1 != vec2);
  }

  function testPool() {
    final vec = Vec3.get(2.3, 3.5, 5.6);

    vec.put();

    final next = Vec3.get();

    Assert.equals(vec, next);

    Assert.equals(0, vec.x);
    Assert.equals(0, vec.y);
    Assert.equals(0, vec.z);
  }

  function testTransformMat4() {
    final rotation = 90;
    final position = new Vec2(2, 4);
    final scale = new Vec2(1.5, 2);
    final mat = Mat4.from2dRotationTranslationScale(rotation, position, scale);
    final vec = new Vec3();

    vec.transformMat4(10, 20, 30, mat);

    Assert.floatEquals(vec.x, -40.48097);
    Assert.floatEquals(vec.y, -0.51299469);
    Assert.floatEquals(vec.z, 30);
  }

  function testToString() {
    final vec = new Vec3(2.4, 6.7, 10.4);
    final expected = '{ x: 2.4, y: 6.7, z: 10.4 }';

    Assert.equals(expected, vec.toString());
  }
}
