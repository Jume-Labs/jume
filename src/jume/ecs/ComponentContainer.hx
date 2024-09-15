package jume.ecs;

import jume.ecs.Component.ComponentParams;

class ComponentContainer {
  final components: Map<String, Component>;

  final updatables: Array<Updatable>;

  final renderables: Array<Renderable>;

  public function new() {
    components = new Map<String, Component>();
    updatables = [];
    renderables = [];
  }

  public function add<T: Component>(componentType: Class<T>, params: ComponentParams): T {
    final name = Type.getClassName(componentType);
    final component = Type.createInstance(componentType, [params]);
    components[name] = component;

    if (Std.isOfType(component, Updatable)) {
      updatables.push(cast component);
    }

    if (Std.isOfType(component, Renderable)) {
      renderables.push(cast component);
    }

    return component;
  }

  public function remove(componentType: Class<Component>): Bool {
    var removed = false;
    final name = Type.getClassName(componentType);
    if (components.exists(name)) {
      final component = components[name];
      component.destroy();
      removed = true;

      components.remove(name);
      updatables.remove(cast component);
      renderables.remove(cast component);
    }

    return removed;
  }

  public inline function get<T: Component>(componentType: Class<T>): T {
    final name = Type.getClassName(componentType);
    return cast components[name];
  }

  public inline function has(componentType: Class<Component>): Bool {
    final name = Type.getClassName(componentType);
    return components.exists(name);
  }

  public function hasAll(componentTypes: Array<Class<Component>>): Bool {
    for (componentType in componentTypes) {
      if (!has(componentType)) {
        return false;
      }
    }

    return true;
  }

  public inline function getRenderables(): Array<Renderable> {
    return renderables;
  }

  public inline function getUpdatables(): Array<Updatable> {
    return updatables;
  }

  public function destroy() {
    for (component in components) {
      component.destroy();
    }
  }
}
