package jume.math;

import utest.Assert;
import utest.Test;

class Mat4Tests extends Test {
  function testPool() {
    final mat = Mat4.get([2, 3, 4, 5, 6, 7, 8, 9, 9, 10, 11, 23, 14, 14, 15, 60]);
    mat.put();

    final next = Mat4.get();
    final identity = new Mat4();

    Assert.equals(mat, next);
    Assert.isTrue(next == identity);
  }

  function testFromTranslation() {
    final mat = new Mat4();
    final result = Mat4.fromTranslation(4, 6, 8, mat);

    Assert.equals(mat, result);

    Assert.floatEquals(1, mat[0]);
    Assert.floatEquals(0, mat[1]);
    Assert.floatEquals(0, mat[2]);
    Assert.floatEquals(0, mat[3]);
    Assert.floatEquals(0, mat[4]);
    Assert.floatEquals(1, mat[5]);
    Assert.floatEquals(0, mat[6]);
    Assert.floatEquals(0, mat[7]);
    Assert.floatEquals(0, mat[8]);
    Assert.floatEquals(0, mat[9]);
    Assert.floatEquals(1, mat[10]);
    Assert.floatEquals(0, mat[11]);
    Assert.floatEquals(4, mat[12]);
    Assert.floatEquals(6, mat[13]);
    Assert.floatEquals(8, mat[14]);
    Assert.floatEquals(1, mat[15]);
  }

  function testFromZRotation() {
    final mat = new Mat4();
    final result = Mat4.fromZRotation(90, mat);

    Assert.equals(mat, result);

    Assert.floatEquals(-0.44807, mat[0]);
    Assert.floatEquals(0.89399, mat[1]);
    Assert.floatEquals(0, mat[2]);
    Assert.floatEquals(0, mat[3]);
    Assert.floatEquals(-0.89399, mat[4]);
    Assert.floatEquals(-0.44807, mat[5]);
    Assert.floatEquals(0, mat[6]);
    Assert.floatEquals(0, mat[7]);
    Assert.floatEquals(0, mat[8]);
    Assert.floatEquals(0, mat[9]);
    Assert.floatEquals(1, mat[10]);
    Assert.floatEquals(0, mat[11]);
    Assert.floatEquals(0, mat[12]);
    Assert.floatEquals(0, mat[13]);
    Assert.floatEquals(0, mat[14]);
    Assert.floatEquals(1, mat[15]);
  }

  function testFromScale() {
    final mat = new Mat4();
    final result = Mat4.fromScale(3, 5, 7, mat);

    Assert.equals(mat, result);

    Assert.floatEquals(3, mat[0]);
    Assert.floatEquals(0, mat[1]);
    Assert.floatEquals(0, mat[2]);
    Assert.floatEquals(0, mat[3]);
    Assert.floatEquals(0, mat[4]);
    Assert.floatEquals(5, mat[5]);
    Assert.floatEquals(0, mat[6]);
    Assert.floatEquals(0, mat[7]);
    Assert.floatEquals(0, mat[8]);
    Assert.floatEquals(0, mat[9]);
    Assert.floatEquals(7, mat[10]);
    Assert.floatEquals(0, mat[11]);
    Assert.floatEquals(0, mat[12]);
    Assert.floatEquals(0, mat[13]);
    Assert.floatEquals(0, mat[14]);
    Assert.floatEquals(1, mat[15]);
  }

  function testFrom2dRotationTranslationScale() {
    final mat = new Mat4();
    final rotation = 90;
    final position = new Vec2(20, 30);
    final scale = new Vec2(2, 3);
    final result = Mat4.from2dRotationTranslationScale(rotation, position, scale, mat);

    Assert.equals(mat, result);

    Assert.floatEquals(-0.89614, mat[0]);
    Assert.floatEquals(1.78799, mat[1]);
    Assert.floatEquals(0, mat[2]);
    Assert.floatEquals(0, mat[3]);
    Assert.floatEquals(-2.68198, mat[4]);
    Assert.floatEquals(-1.34422, mat[5]);
    Assert.floatEquals(0, mat[6]);
    Assert.floatEquals(0, mat[7]);
    Assert.floatEquals(0, mat[8]);
    Assert.floatEquals(0, mat[9]);
    Assert.floatEquals(1, mat[10]);
    Assert.floatEquals(0, mat[11]);
    Assert.floatEquals(20, mat[12]);
    Assert.floatEquals(30, mat[13]);
    Assert.floatEquals(0, mat[14]);
    Assert.floatEquals(1, mat[15]);
  }

  function testNew() {
    final mat = new Mat4();

    Assert.floatEquals(1, mat[0]);
    Assert.floatEquals(0, mat[1]);
    Assert.floatEquals(0, mat[2]);
    Assert.floatEquals(0, mat[3]);
    Assert.floatEquals(0, mat[4]);
    Assert.floatEquals(1, mat[5]);
    Assert.floatEquals(0, mat[6]);
    Assert.floatEquals(0, mat[7]);
    Assert.floatEquals(0, mat[8]);
    Assert.floatEquals(0, mat[9]);
    Assert.floatEquals(1, mat[10]);
    Assert.floatEquals(0, mat[11]);
    Assert.floatEquals(0, mat[12]);
    Assert.floatEquals(0, mat[13]);
    Assert.floatEquals(0, mat[14]);
    Assert.floatEquals(1, mat[15]);
  }

  function testNewCopy() {
    final mat = new Mat4();
    mat[0] = 0;
    mat[1] = 1;
    mat[2] = 2;
    mat[3] = 3;
    mat[4] = 4;
    mat[5] = 5;
    mat[6] = 6;
    mat[7] = 7;
    mat[8] = 8;
    mat[9] = 9;
    mat[10] = 10;
    mat[11] = 11;
    mat[12] = 12;
    mat[13] = 13;
    mat[14] = 14;
    mat[15] = 15;

    final result = new Mat4(mat);

    Assert.floatEquals(0, result[0]);
    Assert.floatEquals(1, result[1]);
    Assert.floatEquals(2, result[2]);
    Assert.floatEquals(3, result[3]);
    Assert.floatEquals(4, result[4]);
    Assert.floatEquals(5, result[5]);
    Assert.floatEquals(6, result[6]);
    Assert.floatEquals(7, result[7]);
    Assert.floatEquals(8, result[8]);
    Assert.floatEquals(9, result[9]);
    Assert.floatEquals(10, result[10]);
    Assert.floatEquals(11, result[11]);
    Assert.floatEquals(12, result[12]);
    Assert.floatEquals(13, result[13]);
    Assert.floatEquals(14, result[14]);
    Assert.floatEquals(15, result[15]);
  }

  function testEquals() {
    final mat1 = new Mat4();

    mat1[0] = 0;
    mat1[1] = 1;
    mat1[2] = 2;
    mat1[3] = 3;
    mat1[4] = 4;
    mat1[5] = 5;
    mat1[6] = 6;
    mat1[7] = 7;
    mat1[8] = 8;
    mat1[9] = 9;
    mat1[10] = 10;
    mat1[11] = 11;
    mat1[12] = 12;
    mat1[13] = 13;
    mat1[14] = 14;
    mat1[15] = 15;

    final mat2 = new Mat4(mat1);

    Assert.notEquals(mat1, mat2);
    Assert.isTrue(mat1 == mat2);
  }

  function testNotEquals() {
    final mat1 = new Mat4();

    mat1[0] = 0;
    mat1[1] = 1;
    mat1[2] = 2;
    mat1[3] = 3;
    mat1[4] = 4;
    mat1[5] = 5;
    mat1[6] = 6;
    mat1[7] = 7;
    mat1[8] = 8;
    mat1[9] = 9;
    mat1[10] = 10;
    mat1[11] = 11;
    mat1[12] = 12;
    mat1[13] = 13;
    mat1[14] = 14;
    mat1[15] = 15;

    final mat2 = new Mat4(mat1);
    mat2[6] = 18;

    Assert.notEquals(mat1, mat2);
    Assert.isTrue(mat1 != mat2);
  }

  function testGetIndex() {
    final mat = new Mat4();

    Assert.equals(1, mat[0]);

    Assert.raises(() -> {
      final t = mat[-1];
    }, 'Index -1 is out of range.');

    Assert.raises(() -> {
      final t = mat[16];
    }, 'Index 16 is out of range.');
  }

  function testSetIndex() {
    final mat = new Mat4();

    Assert.equals(1, mat[0]);

    mat[0] = 2;

    Assert.equals(2, mat[0]);

    Assert.raises(() -> {
      mat[-1] = 25;
    }, 'Index -1 is out of range.');

    Assert.raises(() -> {
      mat[16] = 25;
    }, 'Index 16 is out of range.');
  }

  function testIdentity() {
    final mat = new Mat4();

    mat[0] = 0;
    mat[1] = 1;
    mat[2] = 2;
    mat[3] = 3;
    mat[4] = 4;
    mat[5] = 5;
    mat[6] = 6;
    mat[7] = 7;
    mat[8] = 8;
    mat[9] = 9;
    mat[10] = 10;
    mat[11] = 11;
    mat[12] = 12;
    mat[13] = 13;
    mat[14] = 14;
    mat[15] = 15;

    final result = mat.identity();

    Assert.equals(mat, result);

    Assert.floatEquals(1, mat[0]);
    Assert.floatEquals(0, mat[1]);
    Assert.floatEquals(0, mat[2]);
    Assert.floatEquals(0, mat[3]);
    Assert.floatEquals(0, mat[4]);
    Assert.floatEquals(1, mat[5]);
    Assert.floatEquals(0, mat[6]);
    Assert.floatEquals(0, mat[7]);
    Assert.floatEquals(0, mat[8]);
    Assert.floatEquals(0, mat[9]);
    Assert.floatEquals(1, mat[10]);
    Assert.floatEquals(0, mat[11]);
    Assert.floatEquals(0, mat[12]);
    Assert.floatEquals(0, mat[13]);
    Assert.floatEquals(0, mat[14]);
    Assert.floatEquals(1, mat[15]);
  }

  function testCopyFrom() {
    final mat = new Mat4();
    mat[0] = 0;
    mat[1] = 1;
    mat[2] = 2;
    mat[3] = 3;
    mat[4] = 4;
    mat[5] = 5;
    mat[6] = 6;
    mat[7] = 7;
    mat[8] = 8;
    mat[9] = 9;
    mat[10] = 10;
    mat[11] = 11;
    mat[12] = 12;
    mat[13] = 13;
    mat[14] = 14;
    mat[15] = 15;

    final result = new Mat4();
    final ret = result.copyFrom(mat);

    Assert.equals(result, ret);

    Assert.floatEquals(0, result[0]);
    Assert.floatEquals(1, result[1]);
    Assert.floatEquals(2, result[2]);
    Assert.floatEquals(3, result[3]);
    Assert.floatEquals(4, result[4]);
    Assert.floatEquals(5, result[5]);
    Assert.floatEquals(6, result[6]);
    Assert.floatEquals(7, result[7]);
    Assert.floatEquals(8, result[8]);
    Assert.floatEquals(9, result[9]);
    Assert.floatEquals(10, result[10]);
    Assert.floatEquals(11, result[11]);
    Assert.floatEquals(12, result[12]);
    Assert.floatEquals(13, result[13]);
    Assert.floatEquals(14, result[14]);
    Assert.floatEquals(15, result[15]);
  }

  function testOrtho() {
    final mat = new Mat4();

    final result = mat.ortho({
      left: 0,
      right: 800,
      bottom: 600,
      top: 0,
      near: 0,
      far: 1000
    });

    Assert.equals(mat, result);

    Assert.floatEquals(0.0025, mat[0]);
    Assert.floatEquals(0, mat[1]);
    Assert.floatEquals(0, mat[2]);
    Assert.floatEquals(0, mat[3]);
    Assert.floatEquals(0, mat[4]);
    Assert.floatEquals(-0.00333, mat[5]);
    Assert.floatEquals(0, mat[6]);
    Assert.floatEquals(0, mat[7]);
    Assert.floatEquals(0, mat[8]);
    Assert.floatEquals(0, mat[9]);
    Assert.floatEquals(-0.002, mat[10]);
    Assert.floatEquals(0, mat[11]);
    Assert.floatEquals(-1, mat[12]);
    Assert.floatEquals(1, mat[13]);
    Assert.floatEquals(-1, mat[14]);
    Assert.floatEquals(1, mat[15]);
  }

  function testInvert() {
    final rotation = 90;
    final position = new Vec2(20, 40);
    final scale = new Vec2(1.5, 2.0);
    final mat = Mat4.from2dRotationTranslationScale(rotation, position, scale);

    final result = new Mat4();
    final ret = mat.invert(result);

    Assert.equals(result, ret);

    Assert.floatEquals(-0.298715, result[0]);
    Assert.floatEquals(-0.44699, result[1]);
    Assert.floatEquals(0, result[2]);
    Assert.floatEquals(0, result[3]);
    Assert.floatEquals(0.595997, result[4]);
    Assert.floatEquals(-0.224036, result[5]);
    Assert.floatEquals(0, result[6]);
    Assert.floatEquals(0, result[7]);
    Assert.floatEquals(0, result[8]);
    Assert.floatEquals(0, result[9]);
    Assert.floatEquals(1, result[10]);
    Assert.floatEquals(0, result[11]);
    Assert.floatEquals(-17.86559, result[12]);
    Assert.floatEquals(17.90143, result[13]);
    Assert.floatEquals(0, result[14]);
    Assert.floatEquals(1, result[15]);
  }

  function testToString() {
    final mat = new Mat4([2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32]);
    final expected = '[ 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32 ]';

    Assert.equals(expected, mat.toString());
  }
}
