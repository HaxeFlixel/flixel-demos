package ;
import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.system.FlxPreloader;

/**
 * ...
 * @author Zaphod
 */

class MyPreloader extends FlxPreloader
{

	public function new() 
	{
		super();
		allowedURLs = ['http://adamatomic.com/canabalt/', FlxPreloader.LOCAL];
	}
	
}