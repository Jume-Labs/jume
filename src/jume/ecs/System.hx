package jume.ecs;

import jume.view.Camera;
import jume.graphics.Graphics;

typedef SystemParams = {
  var ?_systems: Map<String, System>;
  var ?_order: Int;
}

typedef EntityList = {
  var entities: Array<Entity>;
  var ?components: Array<Class<Component>>;
  var ?updatables: Bool;
  var ?renderables: Bool;
  var ?addCallback: (entity: Entity)->Void;
  var ?removeCallback: (entity: Entity)->Void;
}

class System {
  public final order: Int;

  public var active: Bool;

  public var debug: Bool;

  final lists: Array<EntityList>;

  final systems: Map<String, System>;

  public function new(params: SystemParams) {
    order = params._order;
    systems = params._systems;
    lists = [];
    debug = true;
    active = true;
  }

  public function update(dt: Float) {}

  public function render(graphics: Graphics, cameras: Array<Camera>) {}

  public function debugRender(graphics: Graphics, cameras: Array<Camera>) {}

  public function updateEntityLists(entity: Entity, removed: Bool) {
    for (list in lists) {
      if (removed) {
        if (list.entities.contains(entity)) {
          if (list.entities.remove(entity)) {
            if (list.removeCallback != null) {
              list.removeCallback(entity);
            }
          }
        }
      } else {
        if (!list.entities.contains(entity) && hasAny(entity, list)) {
          list.entities.push(entity);
          if (list.addCallback != null) {
            list.addCallback(entity);
          }
        } else if (list.entities.contains(entity) && !hasAny(entity, list)) {
          if (list.entities.remove(entity)) {
            if (list.removeCallback != null) {
              list.removeCallback(entity);
            }
          }
        }
      }
    }
  }

  public function destroy() {}

  inline function getSystem<T: System>(systemType: Class<T>): T {
    final name = Type.getClassName(systemType);
    return cast systems[name];
  }

  inline function hasSystem(systemType: Class<System>): Bool {
    final name = Type.getClassName(systemType);
    return systems.exists(name);
  }

  function hasAny(entity: Entity, list: EntityList): Bool {
    if (list.components != null) {
      return entity.hasComponents(list.components);
    } else {
      return (list.renderables != null && entity.getRenderComponents().length > 0)
        || (list.updatables != null && entity.getUpdateComponents().length > 0);
    }
  }
}
