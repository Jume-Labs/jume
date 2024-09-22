package jume.events;

import jume.di.Service;

/**
 * The parameter object passed into the addListener function in the Events class.
 */
typedef AddListenerParams<T> = {
  /**
   * The event type.
   */
  var type: EventType<T>;

  /**
   * The function to call when the event is triggered.
   */
  var callback: (T) -> Void;

  /**
   * If true the callback can cancel the event so it doesn't trigger handlers lower in the list.
   */
  var ?canCancel: Bool;

  /**
   * Higher priority listeners are called first.
   */
  var ?priority: Int;

  /**
   * Optional extra filter before the callback receives and event.
   */
  var ?filter: (T) -> Bool;

  /**
   * Is this a game wide event, not tied to a scene.
   */
  var ?global: Bool;
}

/**
 * The events class handles events in the engine.
 */
class Events implements Service {
  /**
   * All listeners added to the emitter.
   */
  final listeners = new Map<String, Array<EventListener>>();

  /**
   * Create a new Events manager.
   */
  public function new() {}

  /**
   * Add an event listener.
   */
  public function addListener<T: Event>(params: AddListenerParams<T>): EventListener {
    final listener = new EventListener({
      eventType: params.type,
      callback: params.callback,
      canCancel: params.canCancel ?? true,
      priority: params.priority ?? 0,
      filter: params.filter,
      global: params.global ?? false
    });

    if (listeners[params.type] == null) {
      listeners[params.type] = [listener];
    } else {
      listeners[params.type].unshift(listener);
    }

    // Sort the handlers by priority.
    listeners[params.type].sort((a, b) -> {
      if (a.priority < b.priority) {
        return 1;
      } else if (a.priority > b.priority) {
        return -1;
      }

      return 0;
    });

    return listener;
  }

  /**
   * Remove an event listener.
   * @param listener The event listener to remove.
   */
  public function removeListener(listener: EventListener) {
    if (listeners.exists(listener.eventType)) {
      listeners[listener.eventType].remove(listener);
    }
  }

  /**
   * Check if an event type or listener exists in the event emitter.
   * @param type The event type to check.
   * @param listener The optional listener to check.
   * @return True if the type or listener exists.
   */
  public function hasListener<T>(type: EventType<T>, ?listener: EventListener): Bool {
    if (listener != null) {
      final list = listeners[type];
      if (list == null) {
        return false;
      }

      return list.contains(listener);
    } else {
      return listeners.exists(type);
    }
  }

  /**
   * Send an event to all listeners it has. Events get put back into the pool automatically after the emit.
   * @param event The event to emit.
   */
  public function sendEvent(event: Event) {
    // Global listeners are always triggered first.
    var list = listeners[event.type];
    if (list != null) {
      processEvent(event, list);
    }

    event.put();
  }

  /**
   * Clear all events.
   * @param clearGlobal Also clear global events.
   */
  public function clearEvents(clearGlobal = false) {
    for (key in listeners.keys()) {
      final list = listeners[key];
      var index = list.length - 1;
      while (index >= 0) {
        final listener = list[index];
        if (!listener.global || clearGlobal) {
          list.remove(listener);
        }
      }
    }
  }

  /**
   * Process the event with all callbacks.
   * @param event The event to process.
   * @param listeners The callbacks to check.
   */
  function processEvent(event: Event, listeners: Array<EventListener>) {
    for (listener in listeners) {
      if (listener.active && listener.callback != null) {
        if (listener.filter == null || listener.filter(event)) {
          listener.callback(event);
        }
      }

      // Check if this handler can cancel an event. Stop the loop if it can.
      if (event.canceled) {
        if (listener.canCancel) {
          break;
        } else {
          event.canceled = false;
        }
      }
    }
  }
}
