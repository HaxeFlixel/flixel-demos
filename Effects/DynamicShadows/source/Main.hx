package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		addChild(new FlxGame(640, 320, #if flash PlayStateFlash #else PlayStateShader #end));
	}
}
