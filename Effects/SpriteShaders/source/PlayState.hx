package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxBGSprite;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleAdjustSizeScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Shader;
import shaders.Invert;
import shaders.FloodFill;

import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxTileFrames;
import openfl.display.BitmapData;
import openfl.display.Bitmap;

class PlayState extends FlxState
{
	private var floodFill:FloodFill;
	private var invert:Invert;
	private var sprite1:FlxSprite;
	private var sprite2:FlxSprite;
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		
		floodFill = new FloodFill();
		floodFill.uFloodFillY = 0.0;
		invert = new Invert();
		
		sprite1 = new FlxSprite(0, 0, "assets/screen.png");
		sprite2 = new FlxSprite(sprite1.width, 0, "assets/screen.png");
		
		sprite1.shader = floodFill;
		sprite2.shader = invert;
		
		add(sprite1);
		add(sprite2);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.mouse.justPressed)
		{
			if (sprite1.shader == floodFill)
			{
				sprite1.shader = invert;
				sprite2.shader = floodFill;
			}
			else
			{
				sprite1.shader = floodFill;
				sprite2.shader = invert;
			}
		}
		
		floodFill.uFloodFillY = 0.5 * (1.0 + Math.sin(Lib.getTimer() / 1000));
		
		super.update(elapsed);
	}
}