package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		#if flash
		addChild(new FlxGame(800, 500, PieDialState.new));
		#else
		addChild(new FlxGame(800, 500, GaugeEditorState.new));
		#end
	}
}
