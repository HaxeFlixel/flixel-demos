package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Zaphod
 */
class Bunny extends FlxSprite
{
	public function new() 
	{
		super();
		
		#if FLX_RENDER_BLIT
		loadRotatedGraphic("assets/wabbit_alpha.png", 16, -1, false, true);
		#else
		loadGraphic("assets/wabbit_alpha.png");
		#end
	}
	
	public function init(Offscreen:Bool = false):Bunny
	{
		var speedMultiplier:Int = 50;
		
		if (Offscreen)
		{
			speedMultiplier = 5000;
		}
		
		velocity.x = speedMultiplier * FlxRandom.floatRanged( -5, 5);
		velocity.y = speedMultiplier * FlxRandom.floatRanged( -7.5, 2.5);
		acceleration.y = 5;
		angle = FlxRandom.floatRanged( -15, 15);
		angularVelocity = 30 * FlxRandom.floatRanged( -5, 5);
		complex = PlayState.complex;
		elasticity = 1;
		
		return this;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (complex)
		{
			alpha = 0.3 + 0.7 * y / FlxG.height;
		}
		
		if (!PlayState.offScreen)
		{
			setBounds();
		}
	}
	
	private function setBounds():Void
	{
		if (x > (FlxG.width - width))
		{
			velocity.x *= -1;
			x = (FlxG.width - width);
		}
		else if (x < 0)
		{
			velocity.x *= -1;
			x = 0;
		}
		
		if (y > (FlxG.height - height))
		{
			velocity.y *= -0.8;
			y = (FlxG.height - height);
			
			if (FlxRandom.chanceRoll()) 
			{
				velocity.y -= FlxRandom.floatRanged(3, 7);
			}
		}
		else if (y < 0)
		{
			velocity.y *= -0.8;
			y = 0;
		}
	}
	
	public var complex(default, set):Bool = false;
	
	private function set_complex(Value:Bool):Bool
	{
		if (Value)
		{
			scale.x = scale.y = FlxRandom.floatRanged(0.3, 1.3);
		}
		else 
		{
			scale.set(1, 1);
			alpha = 1;
		}
		
		return complex = Value;
	}
}