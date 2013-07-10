package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flash.display.Sprite;
import flash.Lib;

import flixel.FlxGame;

/**
 * @author Joshua Granick
 */
class Main extends Sprite 
{
	
	public function new () 
	{
		super();
		
		var demo:FlxGame = new CollisionDemo();
		addChild(demo);
	}
	
	// Entry point
	public static function main() {
		
		Lib.current.addChild(new Main());
	}
	
}