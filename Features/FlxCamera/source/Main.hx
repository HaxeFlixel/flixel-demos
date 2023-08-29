package;

import flixel.FlxGame;
import flixel.FlxSprite;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		FlxSprite.defaultAntialiasing = true;
		addChild(new FlxGame(640, 480, PlayState));
	}
}
