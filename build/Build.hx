package;

/**
 * This class is used to test if everything compiles.
 */
// di.
import jume.di.Injectable;
import jume.di.Service;
import jume.di.Services;
// events.
import jume.events.Event;
import jume.events.EventListener;
import jume.events.Events;
import jume.events.EventType;
import jume.events.FocusEvent;
import jume.events.ResizeEvent;
// graphics
import jume.graphics.Color;
import jume.graphics.Pipeline;
import jume.graphics.Shader;
import jume.graphics.ShaderType;
// graphics.gl
import jume.graphics.gl.BlendMode;
import jume.graphics.gl.BlendOperation;
import jume.graphics.gl.Context;
import jume.graphics.gl.MipmapFilter;
import jume.graphics.gl.TextureFilter;
import jume.graphics.gl.TextureWrap;
// math
import jume.math.Mat4;
import jume.math.MathUtils;
import jume.math.Random;
import jume.math.Rectangle;
import jume.math.Size;
import jume.math.Vec2;
import jume.math.Vec3;
// utils
import jume.utils.Bitset;
import jume.utils.BrowserInfo;
import jume.utils.TimeStep;
// view
import jume.view.ScaleModes;
import jume.view.View;
// Jume
import jume.Jume;
import jume.JumeOptions;

class Build {
  static function main() {}
}
