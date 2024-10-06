package jume.ecs.systems;

class SUpdate extends System {
  var entities: Array<Entity>;

  public function init(): SUpdate {
    entities = [];

    addEntityListener({ entities: entities, updatables: true });

    return this;
  }

  public override function update(dt: Float) {
    if (!active) {
      return;
    }

    for (entity in entities) {
      for (comp in entity.getUpdateComponents()) {
        comp.cUpdate(dt);
      }
    }
  }
}
