package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxGame;
	
class MultiTouchTest extends FlxGame
{
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / 320;
		var ratioY:Float = stageHeight / 240;
		var ratio:Float = Math.min(ratioX, ratioY);
		#if (flash || desktop || neko)
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), MenuState, ratio, 60, 60);
		#else
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), MenuState, ratio, 60, 30);
		#end
		
		#if android
		FlxG.sound.add("Beep");
		#end	
	}
}
