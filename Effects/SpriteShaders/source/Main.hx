package;

import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.Assets;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(1024, 512, PlayState, 1));
	}
}