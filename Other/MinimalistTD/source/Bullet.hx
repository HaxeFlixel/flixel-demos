package;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxVelocity;

class Bullet extends FlxSprite 
{
	public var target:Enemy;
	public var damage:Int;
	
	public function new(X:Float, Y:Float, Target:Enemy, Damage:Int) 
	{
		target = Target;
		damage = Damage;
		super(X, Y);
		makeGraphic(3, 3);
		blend = BlendMode.INVERT;
	}
	
	override public function update():Void
	{
		if (!onScreen(FlxG.camera)) kill();
		if (target.alive) FlxVelocity.moveTowardsObject(this, target, 200);
		
		super.update();
	}
}