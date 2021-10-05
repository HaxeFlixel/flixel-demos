import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxRect;

class DemoSprite extends FlxSprite
{
	public function new (x = 0.0, y = 0.0)
	{
		super(x, y);
	}
	
	/**
	 * Switches the between the red/white color to show whether an overlap is occurring.
	 */
	public function setCollides(value:Bool)
	{
		color = value ? 0xFFac3232 : 0xFF6abe30;
	}
	
	public function resetAngle()
	{
		angle = 0;
		angularVelocity = 0;
	}
	
	public function resetScale()
	{
		scale.set(1, 1);
	}
	
	public function randomAngle()
	{
		angle = FlxG.random.float() * 360;
		angularVelocity = FlxG.random.float(50, 100);
	}
	
	public function randomScale()
	{
		scale.x = FlxG.random.float(0.5, 2.0);
		scale.y = scale.x;
	}
}