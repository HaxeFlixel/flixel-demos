package;

import flixel.addons.util.FlxScene;
import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MinimalState extends FlxState
{
	private var _scene:FlxScene;

	override public function create():Void
	{
		super.create();

		_scene = new FlxScene("assets/minimal.xml");
		_scene.spawn();

		var back:FlxButton = _scene.object("back_button");
		back.onDown.callback = backCallback;
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function backCallback():Void
	{
		FlxG.switchState(new PlayState());
	}
}