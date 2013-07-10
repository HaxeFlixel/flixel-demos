package;
import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.FlxGame;

class FlxInvaders extends FlxGame
{
	public function new()
	{
		super(320, 240, PlayState, 2); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		#if !neko
		FlxG.cameras.bgColor = 0x000000;
		#end
	}
}