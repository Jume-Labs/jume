package jume.di;

import utest.Assert;
import utest.Test;

class ServicesTests extends Test {
  function setup() {
    Services.clear();
  }

  function testAddService() {
    Assert.isNull(Services.get(MyService));

    final myService = new MyService();
    Services.add(myService);

    Assert.equals(myService, Services.get(MyService));
  }

  function testRemoveService() {
    final myService = new MyService();
    Services.add(myService);
    Assert.equals(myService, Services.get(MyService));

    Services.remove(MyService);
    Assert.isNull(Services.get(MyService));
  }

  function testClearServices() {
    final myService = new MyService();
    Services.add(myService);
    Assert.equals(myService, Services.get(MyService));

    final myService2 = new MyService2();
    Services.add(myService2);
    Assert.equals(myService2, Services.get(MyService2));

    Services.clear();
    Assert.isNull(Services.get(MyService));
    Assert.isNull(Services.get(MyService2));
  }
}

private class MyService implements Service {
  public function new() {}
}

private class MyService2 implements Service {
  public function new() {}
}
