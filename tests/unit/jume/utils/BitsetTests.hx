package jume.utils;

import utest.Assert;
import utest.Test;

class BitsetTests extends Test {
  function testAdd() {
    final bits = 0x000001;
    final mask = 0x000101;

    Assert.equals(0x000101, Bitset.add(bits, mask));
  }

  function testRemove() {
    final bits = 0x001111;
    final mask = 0x000101;

    Assert.equals(0x001010, Bitset.remove(bits, mask));
  }

  function testHas() {
    final bits = 0x00011010;
    var mask = 0x00010010;

    Assert.isTrue(Bitset.has(bits, mask));

    mask = 0x00100001;

    Assert.isFalse(Bitset.has(bits, mask));
  }

  function testHasAll() {
    final bits = 0x00011010;
    var list = [0x00010010, 0x00001010];

    Assert.isTrue(Bitset.hasAll(bits, list));

    list = [0x00010010, 0x00001011];

    Assert.isFalse(Bitset.hasAll(bits, list));
  }
}
