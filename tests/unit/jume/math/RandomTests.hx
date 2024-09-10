package jume.math;

import utest.Assert;
import utest.Test;

class RandomTests extends Test {
  function testSeed() {
    var rnd = new Random();
    final seed = rnd.currentSeed;

    final intValue = rnd.int();
    final floatValue = rnd.float();

    rnd = new Random();
    rnd.currentSeed = seed;

    final otherInt = rnd.int();
    final otherFloat = rnd.float();

    Assert.equals(intValue, otherInt);
    Assert.equals(floatValue, otherFloat);
  }
}
