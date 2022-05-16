package;

import flash.Lib;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * @author Masadow
 */
class PlayerShip extends Entity
{
	static inline var MULTIPLIER_EXPIRY_TIME:Float = 0.8; // amount of time it takes, in seconds, for a multiplier to expire.
	static inline var MULTIPLIER_MAX:Int = 20;

	public static var lives:Int = 0;
	public static var score:UInt = 0;
	public static var highScore:UInt = 0;
	public static var multiplier:Int = 0;
	public static var isGameOver:Bool = false;

	static var multiplierTimeLeft:Float = 0; // time until the current multiplier expires
	static var scoreForExtraLife:UInt = 0; // score required to gain an extra life

	public var bulletSpeed:Float = 660;

	var aim:FlxPoint;

	public static var instance:PlayerShip;

	public function new()
	{
		super(0.5 * FlxG.width, 0.5 * FlxG.height);

		moveSpeed = 480;
		loadRotatedGraphic("images/Player.png", 8, -1, true, true);
		radius = 20;
		hitboxRadius = 18;
		aim = FlxPoint.get();
		instance = this;
		UserSettings.load();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (multiplier > 1)
		{
			// update the multiplier timer
			if ((multiplierTimeLeft -= elapsed) <= 0)
			{
				multiplierTimeLeft = MULTIPLIER_EXPIRY_TIME;
				resetMultiplier();
			}
		}

		velocity = GameInput.move;
		velocity.x *= moveSpeed;
		velocity.y *= moveSpeed;
		if (velocity.x != 0 || velocity.y != 0)
		{
			angle = -Entity.angleInDegrees(velocity);
			exhaust();
		}

		aim = GameInput.aim;
		if (cooldownTimer.finished && (aim.x != 0 || aim.y != 0))
		{
			shoot(aim);
		}

		postUpdate();
	}

	public function postUpdate():Void
	{
		clampToScreen();
	}

	override public function kill():Void
	{
		super.kill();
		ScreenState.makeExplosion(Particle.NONE, position.x, position.y, 1200, Particle.HIGH_SPEED, 0xffff00, 0xffffff);
		cooldownTimer.cancel();
		if (lives-- < 0)
		{
			isGameOver = true;
			cooldownTimer.start(5, onTimerRestart);
		}
		else
			cooldownTimer.start(2, onTimerReset);
	}

	public function onTimerRestart(Timer:FlxTimer):Void
	{
		restart();
		ScreenState.reset();
		isGameOver = false;
	}

	public function onTimerReset(Timer:FlxTimer):Void
	{
		reset(0.5 * FlxG.width, 0.5 * FlxG.height);
		ScreenState.reset();
	}

	override public function reset(X:Float, Y:Float):Void
	{
		super.reset(X - 0.5 * width, Y - 0.5 * height);

		cooldownTimer.cancel();
		cooldownTimer.finished = true;
	}

	public function restart():Void
	{
		reset(0.5 * FlxG.width, 0.5 * FlxG.height);

		if (score > UserSettings.highScore)
			UserSettings.highScore = score;
		score = 0;
		multiplier = 1;
		lives = 4;
		scoreForExtraLife = 2000;
		multiplierTimeLeft = 0;
	}

	public function shoot(aim:FlxPoint):Void
	{
		cooldownTimer.cancel();
		cooldownTimer.start(cooldown);

		var RandomSpread:Float = 4.58366236 * (FlxG.random.float() + FlxG.random.float()) - 4.58366236;

		if (GameInput.aimWithMouse)
		{
			aim.x -= x;
			aim.y -= y;
		}

		aim.degrees += RandomSpread;

		var angle:Float = Entity.angleInDegrees(aim);
		_point.set(8, -25);
		_point.degrees += angle + 90;
		var positionX:Float = _point.x + position.x;
		var positionY:Float = _point.y + position.y;
		ScreenState.makeBullet(positionX, positionY, angle, bulletSpeed);

		_point.set(-8, -25);
		_point.degrees += angle + 90;
		positionX = _point.x + position.x;
		positionY = _point.y + position.y;
		ScreenState.makeBullet(positionX, positionY, angle, bulletSpeed);

		GameSound.randomSound(GameSound.sfxShoot, 0.4);
	}

	function exhaust():Void
	{
		var t:Float = Lib.getTimer();

		// The primary velocity of the particles is 3 pixels/frame in the direction opposite to which the ship is travelling.
		_point.x = -velocity.x;
		_point.y = -velocity.y;
		GameInput.normalize(_point);
		var _speed:Float = 120 + 60 * FlxG.random.float();

		// Calculate the sideways velocity for the two side streams. The direction is perpendicular to the ship's velocity and the
		// magnitude varies sinusoidally.
		var _angle:Float = (45 + 15 * FlxG.random.float()) * Math.sin(0.01 * t);
		var _sideColor:FlxColor = 0xc82609; // deep red
		var _midColor:FlxColor = 0xffbb1e; // orange-yellow
		var _exhaustX:Float = position.x + 20 * _point.x;
		var _exhaustY:Float = position.y + 20 * _point.y;

		// middle particle stream
		ScreenState.makeParticle(Particle.ENEMY, _exhaustX, _exhaustY, angle + 180, _speed, _midColor, true);
		ScreenState.makeParticle(Particle.ENEMY, _exhaustX, _exhaustY, angle + 180 + _angle, _speed, _sideColor);
		ScreenState.makeParticle(Particle.ENEMY, _exhaustX, _exhaustY, angle + 180 - _angle, _speed, _sideColor);
	}

	public function resetMultiplier():Void
	{
		multiplier = 1;
	}

	public static function addPoints(BasePoints:Int):Void
	{
		if (!instance.alive)
			return;

		score += BasePoints * multiplier;
		while (score >= scoreForExtraLife)
		{
			scoreForExtraLife += 2000;
			lives++;
		}
	}

	public static function increaseMultiplier():Void
	{
		if (!instance.alive)
			return;

		multiplierTimeLeft = MULTIPLIER_EXPIRY_TIME;
		if (multiplier < MULTIPLIER_MAX)
			multiplier++;
	}
}
