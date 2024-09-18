package jume.ecs;

import jume.di.Injectable;

typedef ComponentParams = {
  var ?_entityId: Int;
  var ?_components: ComponentContainer;
}

class Component implements Injectable {
  public final entityId: Int;

  final components: ComponentContainer;

  public function new(params: ComponentParams) {
    entityId = params._entityId;
    components = params._components;
  }

  inline function getComponent<T: Component>(componentType: Class<T>): T {
    return components.get(componentType);
  }

  inline function hasComponent(componentType: Class<Component>): Bool {
    return components.has(componentType);
  }

  inline function hasComponents(componentTypes: Array<Class<Component>>): Bool {
    return components.hasAll(componentTypes);
  }

  public function destroy() {}
}
