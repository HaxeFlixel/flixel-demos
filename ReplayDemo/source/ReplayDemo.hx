package ;
import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.FlxGame;

/**
 * ...
 * @author Zaphod
 */

class ReplayDemo extends FlxGame
{

	public function new() 
	{
		var manager = new StateManager();
		
		super(400, 300, MenuState, 1, 20, 20);
	}
	
}