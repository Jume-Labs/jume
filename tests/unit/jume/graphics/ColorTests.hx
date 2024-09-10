package jume.graphics;

import utest.Assert;
import utest.Test;

class ColorTests extends Test {
  function testConstructor() {
    final color = new Color();

    Assert.equals(0, color.red);
    Assert.equals(0, color.green);
    Assert.equals(0, color.blue);
    Assert.equals(1, color.alpha);

    final color2 = new Color({
      red: 0.3,
      green: 0.4,
      blue: 0.5,
      alpha: 0.6
    });

    Assert.equals(0.3, color2.red);
    Assert.equals(0.4, color2.green);
    Assert.equals(0.5, color2.blue);
    Assert.equals(0.6, color2.alpha);
  }

  function testFromBytes() {
    final color = Color.fromBytes({ red: 100, green: 150, blue: 255 });

    Assert.floatEquals(0.39215, color.red);
    Assert.floatEquals(0.58823, color.green);
    Assert.floatEquals(1, color.blue);
    Assert.floatEquals(1, color.alpha);

    final color2 = new Color();
    final color3 = Color.fromBytes({
      red: 100,
      green: 150,
      blue: 255,
      alpha: 100
    }, color2);

    Assert.equals(color2, color3);
    Assert.floatEquals(0.39215, color2.red);
    Assert.floatEquals(0.58823, color2.green);
    Assert.floatEquals(1, color2.blue);
    Assert.floatEquals(0.39215, color2.alpha);
  }

  function testFromHex() {
    final out = new Color();
    final color = Color.fromHex(0xff11ffaa, out);

    Assert.equals(color, out);
    Assert.floatEquals(0.06666, color.red);
    Assert.floatEquals(1, color.green);
    Assert.floatEquals(0.66666, color.blue);
    Assert.floatEquals(1, color.alpha);
  }

  function testFromHexString() {
    final out = new Color();
    final color = Color.fromHexString('#ff11ffaa', out);

    Assert.equals(color, out);
    Assert.floatEquals(0.06666, color.red);
    Assert.floatEquals(1, color.green);
    Assert.floatEquals(0.66666, color.blue);
    Assert.floatEquals(1, color.alpha);
  }

  function testInterpolate() {
    final color1 = new Color({
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0
    });

    final color2 = new Color({
      red: 1,
      green: 1,
      blue: 1,
      alpha: 1
    });

    final result = Color.interpolate(color1, color2, 0);

    Assert.floatEquals(0, result.red);
    Assert.floatEquals(0, result.green);
    Assert.floatEquals(0, result.blue);
    Assert.floatEquals(0, result.alpha);

    Color.interpolate(color1, color2, 0.25, result);

    Assert.floatEquals(0.25, result.red);
    Assert.floatEquals(0.25, result.green);
    Assert.floatEquals(0.25, result.blue);
    Assert.floatEquals(0.25, result.alpha);

    Color.interpolate(color1, color2, 0.5, result);

    Assert.floatEquals(0.5, result.red);
    Assert.floatEquals(0.5, result.green);
    Assert.floatEquals(0.5, result.blue);
    Assert.floatEquals(0.5, result.alpha);

    Color.interpolate(color1, color2, 1, result);

    Assert.floatEquals(1, result.red);
    Assert.floatEquals(1, result.green);
    Assert.floatEquals(1, result.blue);
    Assert.floatEquals(1, result.alpha);
  }

  function testSet() {
    final color = new Color({
      red: 0.2,
      green: 0.3,
      blue: 0.4,
      alpha: 0.5
    });

    color.set({
      red: 0.5,
      green: 0.2,
      blue: 0.8,
      alpha: 0.9
    });

    Assert.floatEquals(0.5, color.red);
    Assert.floatEquals(0.2, color.green);
    Assert.floatEquals(0.8, color.blue);
    Assert.floatEquals(0.9, color.alpha);

    color.set({});

    Assert.floatEquals(0, color.red);
    Assert.floatEquals(0, color.green);
    Assert.floatEquals(0, color.blue);
    Assert.floatEquals(1, color.alpha);
  }

  function testClone() {
    final out = new Color();

    final source = new Color({
      red: 0.5,
      green: 0.2,
      blue: 0.8,
      alpha: 0.9
    });
    final color = source.clone(out);

    Assert.equals(out, color);
    Assert.floatEquals(0.5, color.red);
    Assert.floatEquals(0.2, color.green);
    Assert.floatEquals(0.8, color.blue);
    Assert.floatEquals(0.9, color.alpha);
  }

  function testCopyfrom() {
    final source = new Color({
      red: 0.5,
      green: 0.2,
      blue: 0.8,
      alpha: 0.9
    });
    final color = new Color();
    color.copyFrom(source);

    Assert.floatEquals(0.5, color.red);
    Assert.floatEquals(0.2, color.green);
    Assert.floatEquals(0.8, color.blue);
    Assert.floatEquals(0.9, color.alpha);
  }

  function testToString() {
    final color = new Color({
      red: 0.2,
      green: 0.5,
      blue: 0.55,
      alpha: 1
    });
    final stringColor = color.toString();

    Assert.equals('{ r: 0.2, g: 0.5, b: 0.55, a: 1 }', stringColor);
  }
}
