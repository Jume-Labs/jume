package jume.ecs.systems;

import jume.ecs.components.CTransform;
import jume.graphics.Graphics;
import jume.view.Camera;
import jume.ecs.System.SystemParams;
import jume.view.View;

class SRender extends System {
  var entities: Array<Entity>;

  final layers: Map<Int, Array<Entity>>;

  final layerTracking: Map<Entity, Int>;

  @:inject
  var view: View;

  public function new(params: SystemParams) {
    super(params);

    layers = new Map<Int, Array<Entity>>();
    layerTracking = new Map<Entity, Int>();

    for (i in 0...32) {
      layers[i] = [];
    }

    registerList({
      entities: entities,
      renderables: true,
      addCallback: entityAdded,
      removeCallback: entityRemoved,
      components: [CTransform]
    });
  }

  public override function render(graphics: Graphics, cameras: Array<Camera>) {
    for (entity in entities) {
      if (entity.active) {
        updateLayer(entity);
      }
    }

    for (camera in cameras) {
      if (!camera.active) {
        continue;
      }

      graphics.pushTarget(camera.target);
      graphics.start(true, camera.bgColor);

      graphics.pushTransform();
      graphics.applyTransform(camera.transform);

      for (layerNr in layers.keys()) {
        final layerEntities = layers[layerNr];
        if (layerEntities.length > 0 && !camera.ignoredLayers.contains(layerNr)) {
          for (entity in layerEntities) {
            final transform = entity.getComponent(CTransform);
          }
        }
      }
    }
  }

  function entityAdded(entity: Entity) {
    final layer = entity.layer;
    layerTracking[entity] = layer;
    layers[layer].push(entity);
  }

  function entityRemoved(entity: Entity) {
    final layer = entity.layer;
    layers[layer].remove(entity);
    layerTracking.remove(entity);
  }

  function updateLayer(entity: Entity) {
    if (entity.layerChanged) {
      entity.layerChanged = false;
      final layer = entity.layer;
      final currentLayer = layerTracking[entity];

      if (currentLayer != null && currentLayer != layer) {
        layers[currentLayer].remove(entity);
        layerTracking[entity] = layer;
        layers[layer].push(entity);
      }
    }
  }
}
