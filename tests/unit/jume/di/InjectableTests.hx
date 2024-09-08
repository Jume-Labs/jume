package jume.di;

import utest.Assert;
import utest.Test;

class InjectableTests extends Test {
  function testInject() {
    Services.add(new MyService('this is an inject test'));

    final instance = new MyClass();
    Assert.equals('this is an inject test', instance.service.name);
  }
}

class MyService implements Service {
  public final name: String;

  public function new(name: String) {
    this.name = name;
  }
}

private class MyClass implements Injectable {
  @:inject
  public var service: MyService;

  public function new() {}
}
