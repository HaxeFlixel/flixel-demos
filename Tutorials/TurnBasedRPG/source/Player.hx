package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 100;

	var stepSound:FlxSound;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		animation.add("d_idle", [0]);
		animation.add("lr_idle", [3]);
		animation.add("u_idle", [6]);
		animation.add("d_walk", [0, 1, 0, 2], 6);
		animation.add("lr_walk", [3, 4, 3, 5], 6);
		animation.add("u_walk", [6, 7, 6, 8], 6);

		drag.x = drag.y = 800;
		setSize(8, 8);
		offset.set(4, 8);

		stepSound = FlxG.sound.load(AssetPaths.step__wav);
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}

	function updateMovement()
	{
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
		
		if (right)
		{
			facing = RIGHT;
			velocity.x = SPEED;
		}
		else if (left)
		{
			facing = LEFT;
			velocity.x = -SPEED;
		}
		
		if (down)
		{
			facing = DOWN;
			velocity.y = SPEED;
		}
		else if (up)
		{
			facing = UP;
			velocity.y = -SPEED;
		}
		
		// Prevent faster speeds on diagonal movement
		var magnitude = velocity.length;
		if (magnitude > SPEED)
			// Reduce velocity to SPEED but maintain the same direction
			velocity.scale(SPEED / magnitude);
		
		var action = "idle";
		// check if the player is moving, and not walking into walls
		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
		{
			stepSound.play();
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
	}
}
