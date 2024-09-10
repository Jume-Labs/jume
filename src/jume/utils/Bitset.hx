package jume.utils;

/**
 * Bit Sets are used to bit shift.
 */
class Bitset {
  /**
   * Add a bit to the mask.
   * @param bits The bits to add to.
   * @param mask The mask to add.
   */
  public static inline function add(bits: Int, mask: Int): Int {
    return bits | mask;
  }

  /**
   * Remove a bit from the mask.
   * @param bits The bits to remove from.
   * @param mask The mas to remove.
   */
  public static inline function remove(bits: Int, mask: Int): Int {
    return bits & ~mask;
  }

  /**
   * Check if a bit mask has a bit.
   * @param bits The bits to check.
   * @param mask The mask to check with.
   * @return True if the bits have the mask.
   */
  public static inline function has(bits: Int, mask: Int): Bool {
    return bits & mask == mask;
  }

  /**
   * Check if a bit mask has a bit.
   * @param bits The bits to check.
   * @param masks The masks to check with.
   * @return True if the bits have all the masks.
   */
  public static function hasAll(bits: Int, masks: Array<Int>): Bool {
    for (mask in masks) {
      if (!has(bits, mask)) {
        return false;
      }
    }

    return true;
  }
}
