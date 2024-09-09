package jume.events;

/**
 * EventType adds type checking when adding event listeners.
 */
abstract EventType<T>(String) from String to String {
  /**
   * Compare Event types with strings.
   * @param a
   * @param b
   * @return True if a and b match.
   */
  @:op(A == B)
  static inline function equals<T>(a: EventType<T>, b: String): Bool {
    return (a: String) == b;
  }

  /**
   * Compare Event types with strings.
   * @param a
   * @param b
   * @return True if a and b do not match.
   */
  @:op(A != B)
  static inline function nequals<T>(a: EventType<T>, b: String): Bool {
    return (a: String) != b;
  }
}
