package jume.ecs;

import jume.graphics.Graphics;

interface Renderable {
  function cRender(graphics: Graphics): Void;
  function cDebugRender(graphics: Graphics): Void;
}
