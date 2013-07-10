package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.FlxGame;

class SpaceWar extends FlxGame
{
	public function new()
	{
		super(640, 480, MenuState, 1, 60, 60);
		FlxG.cameras.bgColor = 0x00808080;
	}
}