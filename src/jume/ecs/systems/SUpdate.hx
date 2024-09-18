package jume.ecs.systems;

import jume.ecs.System.SystemParams;

class SUpdate extends System {
  var entities: Array<Entity>;

  public function new(params: SystemParams) {
    super(params);
    entities = [];

    registerList({ entities: entities, updatables: true });
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
