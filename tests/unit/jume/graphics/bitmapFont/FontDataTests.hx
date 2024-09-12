package jume.graphics.bitmapFont;

import utest.Assert;
import utest.Test;

class FontDataTests extends Test {
  final sourceString = [
    'info face="NechaoSharpRegular" size=20 bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=1 aa=1',
    'padding=1,1,1 1 spacing=1,1',
    'common lineHeight=20 base=15 scaleW=161 scaleH=161 pages=1 packed=0',
    'page id=0 file="testFont.png"',
    'chars count=8',
    'char id=32 x=0 y=0 width=0 height=0 xoffset=0 yoffset=0 xadvance=8 page=0 chnl=15',
    'char id=33 x=132 y=108 width=6 height=14 xoffset=0 yoffset=2 xadvance=7 page=0 chnl=15',
    'char id=34 x=101 y=150 width=13 height=6 xoffset=0 yoffset=2 xadvance=13 page=0 chnl=15',
    'char id=35 x=142 y=66 width=14 height=17 xoffset=-1 yoffset=-1 xadvance=12 page=0 chnl=15',
    'char id=36 x=0 y=115 width=19 height=20 xoffset=0 yoffset=-1 xadvance=19 page=0 chnl=15',
    'char id=37 x=0 y=97 width=20 height=17 xoffset=-1 yoffset=0 xadvance=18 page=0 chnl=15',
    'char id=38 x=122 y=45 width=19 height=14 xoffset=0 yoffset=2 xadvance=19 page=0 chnl=15',
    'char id=39 x=7 y=154 width=6 xoffset=0 yoffset=2 xadvance=7 page=0 chnl=15',
    'kerning first=33 second=36 amount=2',
    'kerning first=39 second=35 amount=4'
  ].join('\n');

  function testNew() {
    final fontData = new FontData(sourceString);

    Assert.equals(20, fontData.lineHeight);
  }

  function testGetCharData() {
    final fontData = new FontData(sourceString);

    final info = fontData.getCharData(33);

    Assert.equals(33, info.id);
    Assert.equals(132, info.x);
    Assert.equals(108, info.y);
    Assert.equals(6, info.width);
    Assert.equals(14, info.height);
    Assert.equals(0, info.xOffset);
    Assert.equals(2, info.yOffset);
    Assert.equals(7, info.xAdvance);
  }

  function testGetKerning() {
    final fontData = new FontData(sourceString);

    final kerning = fontData.getKerning(33, 36);

    Assert.equals(2, kerning);
  }
}
