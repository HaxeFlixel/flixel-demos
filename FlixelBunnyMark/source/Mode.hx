package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flash.Lib;
import flixel.FlxGame;
	
class Mode extends FlxGame
{
	
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		#if (desktop || neko)
		super(stageWidth, stageHeight, BunnyMarkState, 1, 60, 60);
		#else
		super(stageWidth, stageHeight, BunnyMarkState, 1, 60, 30);
		#end

	}
}
