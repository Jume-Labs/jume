package jume.ecs;

import jume.di.Injectable;
import jume.di.Services;
import jume.graphics.Graphics;
import jume.tweens.Tweens;
import jume.view.Camera;

class Scene implements Injectable {
  final cameras: Array<Camera>;

  final entities: Entities;

  final systems: Systems;

  final tweens: Tweens;

  public function new() {
    cameras = [new Camera()];
    systems = new Systems(cameras);
    entities = new Entities(systems);
    tweens = new Tweens();

    Services.add(systems);
    Services.add(entities);
    Services.add(tweens);
  }

  public inline function addEntity<T: Entity>(entityType: Class<T>): T {
    return this.entities.add(entityType);
  }

  public inline function removeEntity(entity: Entity) {
    entities.remove(entity);
  }

  public inline function getEntityById(id: Int): Entity {
    return entities.getById(id);
  }

  public inline function removeEntityById(id: Int) {
    entities.removeById(id);
  }

  public inline function getEntityByTag(tag: String): Array<Entity> {
    return entities.getByTag(tag);
  }

  public inline function removeEntityByTag(tag: String) {
    entities.removeByTag(tag);
  }

  public inline function addSystem<T: System>(systemType: Class<T>, order = 0): T {
    return systems.add(systemType, order);
  }

  public inline function removeSystem(systemType: Class<System>): Bool {
    return systems.remove(systemType);
  }

  public inline function getSystem<T: System>(systemType: Class<T>): T {
    return systems.get(systemType);
  }

  public inline function has(systemType: Class<System>): Bool {
    return systems.has(systemType);
  }

  public function update(dt: Float) {
    tweens.update(dt);
    entities.update(dt);
    systems.update(dt);
  }

  public function render(graphics: Graphics) {
    systems.render(graphics);
  }

  public function resize(width: Int, height: Int) {
    for (camera in cameras) {
      camera.resize();
    }
  }

  public function hasFocus() {}

  public function lostFocus() {}

  public function destroy() {
    tweens.clearTweens();
    systems.destroy();
    entities.destroy();
  }
}
