﻿package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flash.display.Sprite;
import flash.Lib;

/**
 * ...
 * @author Zaphod
 */

class Main extends Sprite
{
	
	static function main() 
	{
		new Main();
	}
	
	public function new() 
	{
		super();
		flash.Lib.current.addChild(new TileMapDemo());
	}
}