package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 110;
	/** Reaches top speed in 0.15 seconds */
	static inline var ACCEL:Float = SPEED / 0.15;

	public final maxHealth:Float = 3.0;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		
		loadGraphic(AssetPaths.player__png, true, 24, 24);
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		animation.add("d_idle", [0]);
		animation.add("lr_idle", [3]);
		animation.add("u_idle", [6]);
		animation.add("d_walk", [0, 1, 0, 2], 6);
		animation.add("lr_walk", [3, 4, 3, 5], 6);
		animation.add("u_walk", [6, 7, 6, 8], 6);

		drag.x = drag.y = 800;
		maxVelocity.x = maxVelocity.y = SPEED;
		setSize(12, 12);
		offset.set(6, 12);

		health = maxHealth;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		updateMovement();
	}

	function updateMovement()
	{
		var action = "idle";
		// check if the player is moving, and not walking into walls
		if (velocity.x != 0 || velocity.y != 0)
		{
			// FlxG.sound.play(AssetPaths.step__wav)
			action = "walk";
		}

		switch (facing)
		{
			case LEFT, RIGHT:
				animation.play("lr_" + action);
			case UP:
				animation.play("u_" + action);
			case DOWN:
				animation.play("d_" + action);
			case _:
		}
		
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		#if FLX_KEYBOARD
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		#end

		#if mobile
		var virtualPad = PlayState.virtualPad;
		up = up || virtualPad.buttonUp.pressed;
		down = down || virtualPad.buttonDown.pressed;
		left = left || virtualPad.buttonLeft.pressed;
		right = right || virtualPad.buttonRight.pressed;
		#end
		
		// Cancel out opposing directions
		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;
		
		acceleration.set(0, 0);
		if (right)
		{
			facing = RIGHT;
			acceleration.x = ACCEL;
		}
		else if (left)
		{
			facing = LEFT;
			acceleration.x = -ACCEL;
		}
		
		if (down)
		{
			facing = DOWN;
			acceleration.y = ACCEL;
		}
		else if (up)
		{
			facing = UP;
			acceleration.y = -ACCEL;
		}
		
		// Prevent faster speeds on diagonal movement
		var magnitude = velocity.length;
		if (magnitude > SPEED)
		{
			// Reduce speed to SPEED but maintain direction
			velocity.x *= SPEED / magnitude;
			velocity.y *= SPEED / magnitude;
		}
	}
}
