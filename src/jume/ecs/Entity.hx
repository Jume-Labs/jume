package jume.ecs;

import haxe.Exception;

import jume.di.Injectable;

using jume.math.MathUtils;

class Entity implements Injectable {
  public final id: Int;

  public var active: Bool;

  public var tag: String;

  public var componentsUpdated: Bool;

  public var layer(default, set): Int;

  public var layerChanged: Bool;

  static var nextId = 0;

  static final freeIds: Array<Int> = [];

  final components: ComponentContainer;

  public function new() {
    id = getId();
    active = true;
    tag = '';
    componentsUpdated = false;
    layerChanged = false;
    layer = 0;
    components = new ComponentContainer(id);
  }

  public function destroy() {
    freeIds.push(id);
    components.destroy();
  }

  public inline function addComponent<T: Component>(componentType: Class<T>): T {
    componentsUpdated = true;
    return components.add(componentType);
  }

  public inline function removeComponent(componentType: Class<Component>): Bool {
    componentsUpdated = true;
    return components.remove(componentType);
  }

  public inline function getComponent<T: Component>(componentType: Class<T>): T {
    return components.get(componentType);
  }

  public inline function hasComponent(componentType: Class<Component>): Bool {
    return components.has(componentType);
  }

  public inline function hasComponents(componentTypes: Array<Class<Component>>): Bool {
    return components.hasAll(componentTypes);
  }

  public inline function getRenderComponents(): Array<Renderable> {
    return components.getRenderables();
  }

  public inline function getUpdateComponents(): Array<Updatable> {
    return components.getUpdatables();
  }

  function getId(): Int {
    var i: Int;
    if (nextId < MathUtils.MAX_VALUE_INT) {
      i = nextId;
      nextId++;
    } else if (freeIds.length > 0) {
      i = freeIds.pop();
    } else {
      throw new Exception('Cannot create entity maximum number of entities reached.');
    }

    return i;
  }

  inline function set_layer(value: Int): Int {
    layer = value;
    layerChanged = true;

    return layer;
  }
}
