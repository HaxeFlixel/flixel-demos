package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxGame;
	
class Mode extends FlxGame
{
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / 320;
		var ratioY:Float = stageHeight / 240;
		var ratio:Float = Math.min(ratioX, ratioY);
		//var ratio:Float = 1;
		#if (flash || desktop || neko)
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), MenuState, ratio, 60, 60);
		#else
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), MenuState, ratio, 60, 30);
		#end
		
		#if android
		FlxG.sound.add("Beep");
		FlxG.sound.add("Asplode");
		FlxG.sound.add("Button");
		FlxG.sound.add("Countdown");
		FlxG.sound.add("Enemy");
		FlxG.sound.add("Hit");
		FlxG.sound.add("Hurt");
		FlxG.sound.add("Jam");
		FlxG.sound.add("Jet");
		FlxG.sound.add("Jump");
		FlxG.sound.add("Land");
		FlxG.sound.add("MenuHit");
		FlxG.sound.add("MenuHit2");
		FlxG.sound.add("Shoot");
		#end
		
	//	forceDebugger = true;
	}
}
