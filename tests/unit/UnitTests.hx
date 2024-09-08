package;

import jume.di.ServicesTests;
import jume.di.InjectableTests;

import utest.Runner;
import utest.ui.Report;

class UnitTests {
  static function main() {
    final runner = new Runner();
    runner.addCase(new InjectableTests());
    runner.addCase(new ServicesTests());

    Report.create(runner);

    runner.run();
  }
}
