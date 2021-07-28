package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	override public function create():Void
	{
		FlxG.mouse.visible = false;

		FlxG.camera.setFilters([new BlurFilter()]);

		// Title text, nothing crazy here!

		var text:FlxText;
		text = new FlxText(FlxG.width / 4, FlxG.height / 2 - 20, Math.floor(FlxG.width / 2), "FlxBlur");
		text.setFormat(null, 32, FlxColor.WHITE, CENTER);
		add(text);

		text = new FlxText(FlxG.width / 4, FlxG.height / 2 + 20, Math.floor(FlxG.width / 2), "press space to toggle");
		text.setFormat(null, 16, FlxColor.BLUE, CENTER);
		add(text);

		// This is the particle emitter that spews things off the bottom of the screen.
		// I'm not going to go over it in too much detail here, but basically we
		// create the emitter, then we create 50 32x32 sprites and add them to it.
		var emitter:FlxEmitter = new FlxEmitter(0, FlxG.height + 20, 50);
		emitter.width = FlxG.width;
		emitter.acceleration.set(0, -40);
		emitter.velocity.set(-20, -75, 20, -25);

		var particle:FlxParticle;
		var particles:Int = 50;
		var colors:Array<Int> = [
			FlxColor.BLUE,
			(FlxColor.BLUE | FlxColor.GREEN),
			FlxColor.GREEN,
			(FlxColor.GREEN | FlxColor.RED),
			FlxColor.RED
		];

		for (i in 0...particles)
		{
			particle = new FlxParticle();
			particle.makeGraphic(32, 32, colors[Std.int(FlxG.random.float() * colors.length)]);
			particle.exists = false;
			emitter.add(particle);
		}

		emitter.start(false, 0.1);
		add(emitter);

		// Let the player toggle the effect with the space bar.  Effect starts off.
		FlxG.camera.filtersEnabled = false;
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.camera.filtersEnabled = !FlxG.camera.filtersEnabled;
		}

		super.update(elapsed);
	}
}
