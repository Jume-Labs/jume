package;

/**
 * This class is used to test if everything compiles.
 */
// assets.
import jume.assets.AssetLoader;
import jume.assets.Assets;
import jume.assets.AtlasLoader;
import jume.assets.BitmapFontLoader;
import jume.assets.ImageLoader;
import jume.assets.ShaderLoader;
import jume.assets.SoundLoader;
import jume.assets.TextLoader;
import jume.assets.TilesetLoader;
// audio.
import jume.audio.Audio;
import jume.audio.AudioChannel;
import jume.audio.Sound;
// di.
import jume.di.Injectable;
import jume.di.Service;
import jume.di.Services;
// ecs.
import jume.ecs.Component;
import jume.ecs.ComponentContainer;
import jume.ecs.Entities;
import jume.ecs.Entity;
import jume.ecs.Renderable;
import jume.ecs.Scene;
import jume.ecs.System;
import jume.ecs.Systems;
import jume.ecs.Updatable;
// ecs.components.
import jume.ecs.components.CAnimation;
import jume.ecs.components.CBoxShape;
import jume.ecs.components.CCircleShape;
import jume.ecs.components.CPolygonShape;
import jume.ecs.components.CSprite;
import jume.ecs.components.CText;
import jume.ecs.components.CTilemap;
import jume.ecs.components.CTransform;
// ecs.Systems
import jume.ecs.systems.SRender;
import jume.ecs.systems.SUpdate;
// events.
import jume.events.Event;
import jume.events.EventListener;
import jume.events.Events;
import jume.events.EventType;
import jume.events.FocusEvent;
import jume.events.ResizeEvent;
import jume.events.SceneEvent;
// events.input.
import jume.events.input.ActionEvent;
import jume.events.input.GamepadEvent;
import jume.events.input.KeyboardEvent;
import jume.events.input.MouseEvent;
import jume.events.input.TouchEvent;
// graphics.
import jume.graphics.Color;
import jume.graphics.DefaultShaders;
import jume.graphics.Graphics;
import jume.graphics.Image;
import jume.graphics.Pipeline;
import jume.graphics.RenderTarget;
import jume.graphics.Shader;
import jume.graphics.ShaderType;
// graphics.animation.
import jume.graphics.animation.Animation;
import jume.graphics.animation.AnimationMode;
// graphics.atlas.
import jume.graphics.atlas.Atlas;
import jume.graphics.atlas.AtlasFrame;
// graphics.bitmapFont.
import jume.graphics.bitmapFont.BitmapFont;
import jume.graphics.bitmapFont.FontData;
// graphics.gl.
import jume.graphics.gl.BlendMode;
import jume.graphics.gl.BlendOperation;
import jume.graphics.gl.Context;
import jume.graphics.gl.MipmapFilter;
import jume.graphics.gl.TextureFilter;
import jume.graphics.gl.TextureWrap;
// graphics.renderers.
import jume.graphics.renderers.BaseRenderer;
import jume.graphics.renderers.ImageRenderer;
import jume.graphics.renderers.ShapeRenderer;
// input.
import jume.input.Input;
import jume.input.InputActionBinding;
import jume.input.InputActionType;
import jume.input.KeyCode;
// math.
import jume.math.Mat4;
import jume.math.MathUtils;
import jume.math.Random;
import jume.math.Rectangle;
import jume.math.Size;
import jume.math.Vec2;
import jume.math.Vec3;
// tilemap.
import jume.tilemap.TilemapColliders;
import jume.tilemap.Tileset;
// tweens.
import jume.tweens.Easing;
import jume.tweens.Tween;
import jume.tweens.TweenProperty;
import jume.tweens.Tweens;
import jume.tweens.TweenSequence;
// utils.
import jume.utils.Bitset;
import jume.utils.BrowserInfo;
import jume.utils.Time;
// view.
import jume.view.ScaleModes;
import jume.view.View;
// Jume.
import jume.Jume;
import jume.JumeOptions;

class Build {
  static function main() {}
}
