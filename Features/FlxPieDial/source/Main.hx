package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		#if flash
		addChild(new FlxGame(800, 500, DemoState.new));
		#else
		// addChild(new FlxGame(800, 500, GaugeState.new));
		addChild(new FlxGame(800, 500, GaugeEditorState.new));
		#end
	}
}
