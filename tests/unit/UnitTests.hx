package;

import jume.view.ViewTests;
import jume.view.ScaleModesTests;
import jume.utils.BitsetTests;
import jume.di.InjectableTests;
import jume.di.ServicesTests;
import jume.events.EventListenerTests;
import jume.events.EventTests;
import jume.events.EventsTests;
import jume.events.ResizeEventTests;
import jume.graphics.ColorTests;
import jume.math.Mat4Tests;
import jume.math.MathUtilsTests;
import jume.math.RandomTests;
import jume.math.RectangleTests;
import jume.math.SizeTests;
import jume.math.Vec2Tests;
import jume.math.Vec3Tests;
import jume.utils.TimeStepTests;

import utest.Runner;
import utest.ui.Report;

class UnitTests {
  static function main() {
    final runner = new Runner();
    runner.addCase(new InjectableTests());
    runner.addCase(new ServicesTests());

    runner.addCase(new EventTests());
    runner.addCase(new EventListenerTests());
    runner.addCase(new EventsTests());
    runner.addCase(new ResizeEventTests());

    runner.addCase(new ColorTests());

    runner.addCase(new Mat4Tests());
    runner.addCase(new MathUtilsTests());
    runner.addCase(new RandomTests());
    runner.addCase(new RectangleTests());
    runner.addCase(new SizeTests());
    runner.addCase(new Vec2Tests());
    runner.addCase(new Vec3Tests());

    runner.addCase(new BitsetTests());
    runner.addCase(new TimeStepTests());

    runner.addCase(new ScaleModesTests());
    runner.addCase(new ViewTests());

    Report.create(runner);

    runner.run();
  }
}
