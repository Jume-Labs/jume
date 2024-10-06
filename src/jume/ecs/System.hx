package jume.ecs;

import jume.di.Injectable;
import jume.graphics.Graphics;
import jume.view.Camera;

typedef EntityListener = {
  var entities: Array<Entity>;
  var ?components: Array<Class<Component>>;
  var ?updatables: Bool;
  var ?renderables: Bool;
  var ?addCallback: (entity: Entity) -> Void;
  var ?removeCallback: (entity: Entity) -> Void;
}

class System implements Injectable {
  public final order: Int;

  public var active: Bool;

  public var debug: Bool;

  final entityListeners: Array<EntityListener>;

  final systems: Map<String, System>;

  public function new(systems: Map<String, System>, order: Int) {
    this.systems = systems;
    this.order = order;
    entityListeners = [];
    debug = true;
    active = true;
  }

  public function update(dt: Float) {}

  public function render(graphics: Graphics, cameras: Array<Camera>) {}

  public function debugRender(graphics: Graphics, cameras: Array<Camera>) {}

  public function updateEntityLists(entity: Entity, removed: Bool) {
    for (listener in entityListeners) {
      if (removed) {
        if (listener.entities.contains(entity)) {
          if (listener.entities.remove(entity)) {
            if (listener.removeCallback != null) {
              listener.removeCallback(entity);
            }
          }
        }
      } else {
        if (!listener.entities.contains(entity) && hasAny(entity, listener)) {
          listener.entities.push(entity);
          if (listener.addCallback != null) {
            listener.addCallback(entity);
          }
        } else if (listener.entities.contains(entity) && !hasAny(entity, listener)) {
          if (listener.entities.remove(entity)) {
            if (listener.removeCallback != null) {
              listener.removeCallback(entity);
            }
          }
        }
      }
    }
  }

  public function destroy() {}

  function addEntityListener(listener: EntityListener) {
    entityListeners.push(listener);
  }

  function removeEntityListener(listener: EntityListener) {
    entityListeners.remove(listener);
  }

  inline function getSystem<T: System>(systemType: Class<T>): T {
    final name = Type.getClassName(systemType);
    return cast systems[name];
  }

  inline function hasSystem(systemType: Class<System>): Bool {
    final name = Type.getClassName(systemType);
    return systems.exists(name);
  }

  function hasAny(entity: Entity, listener: EntityListener): Bool {
    if (listener.components != null && !entity.hasComponents(listener.components)) {
      return false;
    }

    if (listener.renderables != null && listener.renderables && entity.getRenderComponents().length == 0) {
      return false;
    }

    if (listener.updatables != null && listener.updatables && entity.getUpdateComponents().length == 0) {
      return false;
    }

    return true;
  }
}
