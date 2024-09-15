package jume.ecs;

import jume.di.Service;

class Entities implements Service {
  final entities: Array<Entity>;

  final entitiesToRemove: Array<Entity>;

  final systems: Systems;

  public function new(systems: Systems) {
    this.systems = systems;
    entities = [];
    entitiesToRemove = [];
  }

  public function update(dt: Float) {
    while (entitiesToRemove.length > 0) {
      final entity = entitiesToRemove.pop();
      systems.updateSystemEntities(entity, true);

      entity.destroy();
      entities.remove(entity);
    }

    for (entity in entities) {
      if (entity.componentsUpdated) {
        systems.updateSystemEntities(entity);
        entity.componentsUpdated = false;
      }
    }
  }

  public function add<T: Entity>(entityType: Class<T>, params: Dynamic): T {
    final entity = Type.createInstance(entityType, [params]);
    entities.push(entity);
    systems.updateSystemEntities(entity);

    return entity;
  }

  public function remove(entity: Entity) {
    entitiesToRemove.push(entity);
  }

  public function getById(id: Int): Entity {
    for (entity in entities) {
      if (entity.id == id) {
        return entity;
      }
    }

    return null;
  }

  public function removeById(id: Int) {
    final entity = getById(id);
    if (entity != null) {
      entities.remove(entity);
    }
  }

  public function getByTag(tag: String): Array<Entity> {
    final taggedEntities: Array<Entity> = [];

    for (entity in entities) {
      if (entity.tag == tag) {
        taggedEntities.push(entity);
      }
    }

    return taggedEntities;
  }

  public function removeByTag(tag: String) {
    final taggedEntities = getByTag(tag);

    while (taggedEntities.length > 0) {
      entitiesToRemove.push(taggedEntities.pop());
    }
  }

  public function destroy() {
    for (entity in entities) {
      entity.destroy();
    }
  }
}
