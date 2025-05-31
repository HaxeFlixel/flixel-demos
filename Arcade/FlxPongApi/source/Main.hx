package;

import flixel.addons.api.gamejolt.FlxGameJoltRequest;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(450, 150, MenuState));
		FlxG.signals.postUpdate.add(() -> new FlxGameJoltRequest(SESSION_PING(true)).send(true));
	}
}
