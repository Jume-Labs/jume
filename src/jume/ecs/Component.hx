package jume.ecs;

import jume.di.Injectable;

class Component implements Injectable {
  public final entityId: Int;

  final components: ComponentContainer;

  public function new(entityId: Int, components: ComponentContainer) {
    this.entityId = entityId;
    this.components = components;
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
