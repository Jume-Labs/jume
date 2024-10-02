package jume.ecs;

import jume.di.Injectable;
import jume.di.Service;
import jume.graphics.Color;
import jume.graphics.Graphics;
import jume.math.Vec2;
import jume.view.Camera;
import jume.view.View;

class Systems implements Service implements Injectable {
  final systems: Map<String, System>;

  final systemList: Array<System>;

  final cameras: Array<Camera>;

  final tempPos: Vec2;

  @:inject
  var view: View;

  public function new(cameras: Array<Camera>) {
    this.cameras = cameras;
    systems = new Map<String, System>();
    systemList = [];
    tempPos = new Vec2();
  }

  public function add<T: System>(systemType: Class<T>, order: Int): T {
    final system = Type.createInstance(systemType, [systems, order]);
    final name = Type.getClassName(systemType);

    systems[name] = system;
    systemList.push(system);

    systemList.sort((a, b) -> {
      if (a.order > b.order) {
        return -1;
      } else if (a.order < b.order) {
        return 1;
      }

      return 0;
    });

    return system;
  }

  public function remove(systemType: Class<System>): Bool {
    var removed = false;
    final name = Type.getClassName(systemType);
    if (systems.exists(name)) {
      final system = systems[name];
      system.destroy();

      systems.remove(name);
      systemList.remove(system);
      removed = true;
    }

    return removed;
  }

  public inline function get<T: System>(systemType: Class<T>): T {
    final name = Type.getClassName(systemType);
    return cast systems[name];
  }

  public inline function has(systemType: Class<System>): Bool {
    final name = Type.getClassName(systemType);
    return systems.exists(name);
  }

  public function update(dt: Float) {
    for (system in systemList) {
      if (system.active) {
        system.update(dt);
      }
    }
  }

  public function render(graphics: Graphics) {
    for (system in systemList) {
      if (system.active) {
        system.render(graphics, cameras);
      }
    }

    if (view.debugRender) {
      for (system in systemList) {
        if (system.active) {
          system.debugRender(graphics, cameras);
        }
      }
    }

    graphics.transform.identity();
    graphics.color.copyFrom(Color.WHITE);

    graphics.start();
    for (camera in cameras) {
      tempPos.set(camera.screenBounds.x, camera.screenBounds.y);
      graphics.drawRenderTarget(tempPos, camera.target);
    }
    graphics.present();
  }

  public function updateSystemEntities(entity: Entity, removed = false) {
    for (system in systemList) {
      system.updateEntityLists(entity, removed);
    }
  }

  public function destroy() {
    for (system in systemList) {
      system.destroy();
    }
  }
}
