package jume.utils;

import utest.Assert;
import utest.Test;

class TimeTests extends Test {
  function testTimeScale() {
    final time = new Time();

    time.update(0.016);
    Assert.equals(0.016, time.dt);

    time.timeScale = 2;
    time.update(0.016);
    Assert.equals(0.032, time.dt);

    time.timeScale = 0.5;
    time.update(0.016);
    Assert.equals(0.008, time.dt);
  }

  function testUnscaledDt() {
    final time = new Time();

    time.update(0.016);
    Assert.equals(0.016, time.dt);

    time.timeScale = 2;
    time.update(0.016);
    Assert.equals(0.016, time.unscaledDt);
  }

  function testTotalElapsed() {
    final time = new Time();

    time.update(2);
    time.update(3);
    time.update(2);
    time.update(3);
    time.update(2);

    Assert.equals(12, time.totalElapsed);
  }
}
