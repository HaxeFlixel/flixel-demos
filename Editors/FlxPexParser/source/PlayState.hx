package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.pex.FlxPexParser;
import flixel.effects.particles.FlxEmitter;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	var emitter:FlxEmitter;

	override public function create():Void
	{
		FlxG.mouse.visible = false;

		emitter = new FlxEmitter(FlxG.width / 2, FlxG.height / 2);
		initEmitter(0.5);
		emitter.start(false, 0.01);
		add(emitter);

		var instructions = new FlxText(0, 10, 0, "Drag to move the fire\npress to increase scale");
		instructions.alignment = CENTER;
		instructions.screenCenter(X);
		add(instructions);
	}

	function initEmitter(scale:Float):Void
	{
		FlxPexParser.parse("assets/data/particle.pex", "assets/images/texture.png", emitter, scale);
	}

	override public function update(elapsed:Float):Void
	{
		emitter.setPosition(FlxG.mouse.x, FlxG.mouse.y);

		if (FlxG.mouse.justPressed)
			initEmitter(1.0);
		else if (FlxG.mouse.justReleased)
			initEmitter(0.5);

		super.update(elapsed);
	}
}
