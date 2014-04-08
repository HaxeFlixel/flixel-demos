package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;

class PlayState extends FlxState
{
	private var _enabled:Bool;
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		
		// Required for the blur effect - flash only!
		FlxG.camera.useBgAlphaBlending = true;
		
		// Title text, nothing crazy here!
		var text:FlxText;
		text = new FlxText(FlxG.width / 4, FlxG.height / 2 - 20, Math.floor(FlxG.width / 2), "FlxBlur");
		text.setFormat(null, 32, FlxColor.WHITE, "center");
		add(text);
		
		text = new FlxText(FlxG.width / 4, FlxG.height / 2 + 20, Math.floor(FlxG.width / 2), "press space to toggle");
		text.setFormat(null, 16, FlxColor.BLUE, "center");
		add(text);
		
		// This is the particle emitter that spews things off the bottom of the screen.
		// I'm not going to go over it in too much detail here, but basically we
		// create the emitter, then we create 50 32x32 sprites and add them to it.
		var emitter:FlxEmitter = new FlxEmitter(0, FlxG.height + 20, 50);
		emitter.width = FlxG.width;
		emitter.gravity = -40;
		emitter.setXSpeed( -20, 20);
		emitter.setYSpeed( -75, -25);
		
		var particle:FlxParticle;
		var particles:Int = 50;
		var colors:Array<Int> = [FlxColor.BLUE, (FlxColor.BLUE | FlxColor.GREEN), FlxColor.GREEN, (FlxColor.GREEN | FlxColor.RED), FlxColor.RED];
		
		for (i in 0...particles)
		{
			particle = new FlxParticle();
			particle.makeGraphic(32, 32, colors[Std.int(FlxRandom.float() * colors.length)]);
			particle.exists = false;
			emitter.add(particle);
		}
		
		emitter.start(false, 0, 0.1);
		add(emitter);
		
		// Let the player toggle the effect with the space bar.  Effect starts on.
		_enabled = true;
	}
	
	override public function update():Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			_enabled = !_enabled;
		}
		
		if (_enabled)
		{
			// By setting the background color to a value with a low transparency,
			// we can generate a cool "blur" effect.
			FlxG.cameras.bgColor = 0x11000000;
		}
		else
		{
			// Setting it to an opaque color will turn the effect back off.
			FlxG.cameras.bgColor = FlxColor.BLACK;
		}
		
		super.update();
	}
}