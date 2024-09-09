package jume.events;

import utest.Assert;
import utest.Test;

class EventListenerTests extends Test {
  function testConstructor() {
    final callback = (any: Dynamic) -> {};
    final filter = (any: Dynamic) -> return true;
    final listener = new EventListener({
      eventType: 'test_test_event',
      callback: callback,
      canCancel: true,
      priority: 2,
      filter: filter
    });

    Assert.isTrue(listener.active);
    Assert.equals('test_test_event', listener.eventType);
    Assert.equals(callback, listener.callback);
    Assert.isTrue(listener.canCancel);
    Assert.equals(2, listener.priority);
    Assert.equals(filter, listener.filter);
  }
}
