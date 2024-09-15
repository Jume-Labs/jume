package jume.events;

/**
 * The parameter object passed into the EventListener constructor.
 */
typedef EventListenerParams = {
  /**
   * The event type this listener is for.
   */
  var eventType: String;

  /**
   * The function to call when the event is triggered.
   */
  var callback: (Dynamic)->Void;

  /**
   * Can the callback cancel an event.
   */
  var canCancel: Bool;

  /**
   * The listener priority.
   */
  var priority: Int;

  /**
   * Extra filter before receiving an event.
   */
  var ?filter: (Dynamic)->Bool;

  /**
   * Is this a game wide event, not tied to a scene.
   */
  var global: Bool;
}

/**
 * An event listener is used to store callbacks to call when the event is triggered. 
 */
class EventListener {
  /**
   * Only active listeners get called.
   */
  public var active: Bool;

  /**
   * The event type this listener is for.
   */
  public final eventType: String;

  /**
   * The function to call when the event is triggered.
   */
  public final callback: (Dynamic)->Void;

  /**
   * If true this callback can cancel an event.
   */
  public final canCancel: Bool;

  /**
   * The priority of the callback. Higher is called first.
   */
  public final priority: Int;

  /**
   * Extra filter before receiving an event.
   */
  public final filter: (Dynamic)->Bool;

  /**
   * Is this a game wide event, not tied to a scene.
   */
  public final global: Bool;

  /**
   * Create a new EventListener instance.
   * @param params The listener input params.
   */
  public function new(params: EventListenerParams) {
    active = true;
    eventType = params.eventType;
    callback = params.callback;
    canCancel = params.canCancel;
    priority = params.priority;
    filter = params.filter;
    global = params.global;
  }
}
