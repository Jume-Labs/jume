package jume.events;

import utest.Assert;
import utest.Test;

class EventTests extends Test {
  function testEventGetter() {
    final event = TestEvent.get(TestEvent.TEST, 'test name', 42);

    Assert.equals(TestEvent.TEST, event.type);
    Assert.equals('test name', event.name);
    Assert.equals(42, event.nr);
  }
}

private class TestEvent extends Event {
  public static final TEST: EventType<TestEvent> = 'test_test_event';

  var name: String;

  var nr: Int;
}
