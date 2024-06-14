package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 * @author David Bell
 */
class EnemyTemplate extends FlxSprite
{
	public var health:Int = 0;

	var _player:Player;
	var _startx:Float;
	var _starty:Float;

	public function new(X:Float, Y:Float, ThePlayer:Player)
	{
		super(X, Y);

		_startx = X;
		_starty = Y;
		_player = ThePlayer;
	}

	public function hurt(damage:Int = 1):Void
	{
		// remember, right means facing left
		if (facing == RIGHT)
		{
			// Knock him to the right
			velocity.x = drag.x * 4;
		}
		// Don't really need the if part, but hey.
		else if (facing == LEFT)
		{
			velocity.x = -drag.x * 4;
		}

		FlxTween.flicker(this, 0.5);
		FlxG.sound.play("assets/sounds/monhurt2" + Reg.SoundExtension, 1, false);
		health -= damage;
	}
}
