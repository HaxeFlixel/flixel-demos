package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

class Bullet extends FlxSprite
{
	private var _speed:Float;
	
	public function new()
	{
		super();
		
		loadGraphic(Reg.BULLET, true);
		width = 6;
		height = 6;
		offset.set(1, 1);
		
		animation.add("up", [0]);
		animation.add("down", [1]);
		animation.add("left", [2]);
		animation.add("right", [3]);
		animation.add("poof", [4, 5, 6, 7], 50, false);
		
		_speed = 360;
	}
	
	override public function update():Void
	{
		if (!alive)
		{
			if (animation.finished)
			{
				exists = false;
			}
		}
		else if (touching != 0)
		{
			kill();
		}
		super.update();
	}
	
	override public function kill():Void
	{
		if (!alive)
		{
			return;
		}
		
		velocity.set(0, 0);
		
		if (isOnScreen())
		{
			FlxG.sound.play("Jump");
		}
		
		alive = false;
		solid = false;
		animation.play("poof");
	}
	
	public function shoot(Location:FlxPoint, Aim:Int):Void
	{
		FlxG.sound.play("Shoot");
		
		super.reset(Location.x - width / 2, Location.y - height / 2);
		
		solid = true;
		
		switch (Aim)
		{
			case FlxObject.UP:
				animation.play("up");
				velocity.y = - _speed;
			case FlxObject.DOWN:
				animation.play("down");
				velocity.y = _speed;
			case FlxObject.LEFT:
				animation.play("left");
				velocity.x = - _speed;
			case FlxObject.RIGHT:
				animation.play("right");
				velocity.x = _speed;
		}
	}
}