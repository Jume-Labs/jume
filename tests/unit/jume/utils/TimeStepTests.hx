package jume.utils;

import utest.Assert;
import utest.Test;

class TimeStepTests extends Test {
  function testTimeScale() {
    final timeStep = new TimeStep();

    timeStep.update(0.016);
    Assert.equals(0.016, timeStep.dt);

    timeStep.timeScale = 2;
    timeStep.update(0.016);
    Assert.equals(0.032, timeStep.dt);

    timeStep.timeScale = 0.5;
    timeStep.update(0.016);
    Assert.equals(0.008, timeStep.dt);
  }

  function testUnscaledDt() {
    final timeStep = new TimeStep();

    timeStep.update(0.016);
    Assert.equals(0.016, timeStep.dt);

    timeStep.timeScale = 2;
    timeStep.update(0.016);
    Assert.equals(0.016, timeStep.unscaledDt);
  }

  function testTotalElapsed() {
    final timeStep = new TimeStep();

    timeStep.update(2);
    timeStep.update(3);
    timeStep.update(2);
    timeStep.update(3);
    timeStep.update(2);

    Assert.equals(12, timeStep.totalElapsed);
  }
}
