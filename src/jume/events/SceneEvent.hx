package jume.events;

import jume.ecs.Scene;

class SceneEvent extends Event {
  public static final CHANGE: EventType<SceneEvent> = 'jume_scene_event';

  var sceneType: Class<Scene>;
}
