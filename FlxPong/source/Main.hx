/**
* FlxSnake
* @author Richard Davey
*/

package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.FlxGame;
import flash.Lib;

class Main extends FlxGame
{
	
	public function new()
	{
		super(224, 160, MenuState, 2, 60, 60);
	}
	
	public static function main() 
	{
		var pong = new Main();
		Lib.current.stage.addChild(pong);
	}
}