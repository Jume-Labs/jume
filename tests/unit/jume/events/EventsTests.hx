package jume.events;

import utest.Assert;
import utest.Test;

class EventsTests extends Test {
  var events: Events;

  function setup() {
    events = new Events();
  }

  function testAddListener() {
    final cb = (event: TestEvent) -> {}
    var listener = events.addListener({ type: TestEvent.TEST, callback: cb });

    Assert.isTrue(events.hasListener(TestEvent.TEST, listener));
    Assert.equals(0, listener.priority);
    Assert.isTrue(listener.canCancel);
    Assert.isTrue(listener.active);
    Assert.equals(cb, listener.callback);

    listener = events.addListener({
      type: TestEvent.TEST,
      callback: cb,
      canCancel: false,
      priority: 2
    });

    Assert.equals(2, listener.priority);
    Assert.isFalse(listener.canCancel);
    Assert.equals(cb, listener.callback);
  }

  function testRemoveListener() {
    final cb = (event: TestEvent) -> {};
    var listener1 = events.addListener({ type: TestEvent.TEST, callback: cb });

    final cb2 = (event: TestEvent) -> {};
    final listener2 = events.addListener({ type: TestEvent.TEST2, callback: cb2 });

    Assert.isTrue(events.hasListener(TestEvent.TEST, listener1));
    Assert.isTrue(events.hasListener(TestEvent.TEST2, listener2));

    events.removeListener(listener1);

    Assert.isFalse(events.hasListener(TestEvent.TEST, listener1));
    Assert.isTrue(events.hasListener(TestEvent.TEST2, listener2));

    listener1 = events.addListener({ type: TestEvent.TEST2, callback: cb2 });

    Assert.isTrue(events.hasListener(TestEvent.TEST2, listener1));
  }

  function testHasListener() {
    final cb = (event: TestEvent) -> {};
    final cb2 = (event: TestEvent) -> {};

    final listener1 = events.addListener({ type: TestEvent.TEST, callback: cb });
    final listener2 = events.addListener({ type: TestEvent.TEST2, callback: cb2 });

    Assert.isTrue(events.hasListener(TestEvent.TEST));
    Assert.isTrue(events.hasListener(TestEvent.TEST, listener1));
    Assert.isFalse(events.hasListener(TestEvent.TEST, listener2));

    Assert.isTrue(events.hasListener(TestEvent.TEST2));
    Assert.isTrue(events.hasListener(TestEvent.TEST2, listener2));
    Assert.isFalse(events.hasListener(TestEvent.TEST2, listener1));
  }

  function testSendEvent() {
    var result1 = '';
    var result2 = '';

    var result3 = '';

    final cb = (event: TestEvent) -> {
      result1 = event.test;
      event.canceled = true;
    };

    final cb2 = (event: TestEvent) -> {
      result2 = event.test;
    };

    final cb3 = (event: TestEvent) -> {
      result3 = event.test;
    };

    events.addListener({ type: TestEvent.TEST2, callback: cb3 });
    events.addListener({ type: TestEvent.TEST, callback: cb2 });

    final listener3 = events.addListener({ type: TestEvent.TEST, callback: cb });
    events.sendEvent(TestEvent.get(TestEvent.TEST, 'cancel test'));

    Assert.equals('cancel test', result1);
    Assert.equals('', result2);
    Assert.equals('', result3);

    events.sendEvent(TestEvent.get(TestEvent.TEST2, 'test2'));

    Assert.equals('cancel test', result1);
    Assert.equals('', result2);
    Assert.equals('test2', result3);

    events.removeListener(listener3);
    events.addListener({ type: TestEvent.TEST, callback: cb3 });
    events.sendEvent(TestEvent.get(TestEvent.TEST, 'not canceled'));

    Assert.equals('not canceled', result2);
    Assert.equals('not canceled', result3);
  }

  function testActive() {
    var result1 = '';
    var result2 = '';

    final cb1 = (event: TestEvent) -> {
      result1 = event.test;
    }

    final cb2 = (event: TestEvent) -> {
      result2 = event.test;
    }

    final listener1 = events.addListener({ type: TestEvent.TEST, callback: cb1 });
    events.addListener({ type: TestEvent.TEST, callback: cb2 });

    events.sendEvent(TestEvent.get(TestEvent.TEST, 'test1'));

    Assert.equals('test1', result1);
    Assert.equals('test1', result2);

    listener1.active = false;

    events.sendEvent(TestEvent.get(TestEvent.TEST, 'test2'));

    Assert.equals('test1', result1);
    Assert.equals('test2', result2);
  }

  function testFilter() {
    var result1 = '';
    var result2 = '';

    final cb1 = (event: TestEvent) -> {
      result1 = event.test;
    };

    final cb2 = (event: TestEvent) -> {
      result2 = event.test;
    };

    final filter = (event: TestEvent) -> {
      return event.test == 'allowed_by_filter';
    };

    events.addListener({ type: TestEvent.TEST, callback: cb1, filter: filter });
    events.addListener({ type: TestEvent.TEST, callback: cb2 });

    events.sendEvent(TestEvent.get(TestEvent.TEST, 'normal event'));

    Assert.equals('', result1);
    Assert.equals('normal event', result2);

    events.sendEvent(TestEvent.get(TestEvent.TEST, 'allowed_by_filter'));

    Assert.equals('allowed_by_filter', result1);
    Assert.equals('allowed_by_filter', result2);
  }
}

private class TestEvent extends Event {
  public static final TEST: EventType<TestEvent> = 'test_event_test';

  public static final TEST2: EventType<TestEvent> = 'test_event_test2';

  var test: String;
}
