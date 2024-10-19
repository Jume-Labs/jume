package jume.events;

import jume.ecs.Scene;

/**
 * Scene management events.
 */
class SceneEvent extends Event {
  /**
   * This event type to change to a new scene.
   */
  public static final CHANGE: EventType<SceneEvent> = 'jume_scene_event';

  /**
   * The scene type to change to.
   */
  var sceneType: Class<Scene>;
}
