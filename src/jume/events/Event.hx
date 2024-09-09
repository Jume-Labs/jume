package jume.events;

/**
 * Event base class. Each event derived from this class has an object pool and a `send` function to get
 * an event from the pool and send it. Those are automatically added with the build macro below.
 */
@:autoBuild(jume.utils.Macros.buildEvent())
class Event {
  /**
   * The type of event as a string.
   */
  public var type(default, null) = '';

  /**
   * True if the event has been canceled inside a handler.
   */
  public var canceled: Bool;

  /**
   * Private constructor. Events should be used with pooling.
   */
  function new() {
    canceled = false;
  }

  /**
   * Used to reset object pooled events.
   */
  public function put() {
    canceled = false;
  }
}
