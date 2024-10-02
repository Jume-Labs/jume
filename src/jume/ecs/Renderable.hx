package jume.ecs;

import jume.graphics.Graphics;

/**
 * Interface that components can implement if they want a function to render something to the screen.
 */
interface Renderable {
  /**
   * Render things to the screen use the graphics api.
   * @param graphics The graphics api.
   */
  function cRender(graphics: Graphics): Void;

  /**
   * Called when debug render is on.
   * @param graphics The graphics api.
   */
  function cDebugRender(graphics: Graphics): Void;
}
