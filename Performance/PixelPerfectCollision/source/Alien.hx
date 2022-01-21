import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Alien extends DemoSprite
{
	var collides:Bool = false;
	
	public function new()
	{
		super();
		
		// set dance dance interstellar animations
		loadGraphic("assets/alien.png", true);
		/*
		 * WebGL has trouble displaying large number of sprites with dynamic coloring,
		 * so we switch bewteen two similar animations with different colors.
		 */
		var fps = FlxG.random.int(6, 10);
		animation.add("dance_off", [0, 1, 0, 2], fps);
		animation.add("dance_on", [3, 4, 3, 5], fps);
		animation.play("dance_off"); // dance!
	}
	
	/**
	 * Randomize position, scrollFactor, velocity and alpha.
	 */
	public function randomize()
	{
		var ran = FlxG.random;
		x = ran.int(0, Std.int(FlxG.width - width)) + FlxG.camera.scroll.x;
		y = ran.int(0, Std.int(FlxG.height - height)) + FlxG.camera.scroll.y;
		alpha = ran.float(0.1, 1.0);
		scrollFactor.x = alpha;
		// negate the x-offset caused from scrollFactor
		x += FlxG.camera.scroll.x * (scrollFactor.x - 1);
		velocity.set(-ran.float(5, 25), 0);

		// Neat tweening effect for new aliens appearing
		var toY = y;
		y = (y < FlxG.height / 2) ? -20 : FlxG.height + 20;
		FlxTween.tween(this, {y: toY}, 1.0, { ease: FlxEase.expoOut, startDelay: ran.float() * 0.5 });
	}

	/**
	 * Switches the between the red/white color to show whether an overlap is occurring.
	 * @param value 
	 */
	override function setCollides(value:Bool)
	{
		if (value != collides)
		{
			collides = value;
			var frame = animation.curAnim.curFrame;
			animation.play("dance_" + (collides ? "on" : "off"), false, false, frame);
		}
	}
}