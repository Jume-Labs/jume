package;

import jume.di.ServicesTests;
import jume.di.InjectableTests;
import jume.events.EventTests;
import jume.events.EventListenerTests;
import jume.events.EventsTests;

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

    Report.create(runner);

    runner.run();
  }
}
