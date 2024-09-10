package jume.math;

import utest.Assert;
import utest.Test;

class SizeTests extends Test {
  function testNew() {
    var size = new Size();

    Assert.equals(0, size.width);
    Assert.equals(0, size.height);

    size = new Size(23.4, 10.3);

    Assert.equals(23.4, size.width);
    Assert.equals(10.3, size.height);
  }

  function testIntegerValues() {
    final size = new Size(3.54, 5.89);

    Assert.equals(3, size.widthi);
    Assert.equals(5, size.heighti);
  }

  function testSet() {
    final size = new Size();

    Assert.equals(0, size.width);
    Assert.equals(0, size.height);

    size.set(23.4, 56.7);

    Assert.equals(23.4, size.width);
    Assert.equals(56.7, size.height);
  }

  function testClone() {
    final size = new Size(30, 56);
    final out = new Size();
    final clone = size.clone(out);

    Assert.equals(out, clone);
    Assert.notEquals(size, clone);
    Assert.equals(30, clone.width);
    Assert.equals(56, clone.height);
  }

  function testToString() {
    final size = new Size(23.45, 59.28);
    final expected = '{ w: 23.45, h: 59.28 }';

    Assert.equals(expected, size);
  }
}
