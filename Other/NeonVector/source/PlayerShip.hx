package ;

import flash.Lib;
import flixel.FlxG;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;

/**
 * @author Masadow
 */
class PlayerShip extends Entity
{
	private static inline var MULTIPLIER_EXPIRY_TIME:Float = 0.8; // amount of time it takes, in seconds, for a multiplier to expire.
	private static inline var MULTIPLIER_MAX:Int = 20;
	
	public static var lives:Int;
	public static var score:UInt;
	public static var highScore:UInt;
	public static var multiplier:Int;
	public static var isGameOver:Bool = false;
	
	private static var multiplierTimeLeft:Float; // time until the current multiplier expires
	private static var scoreForExtraLife:UInt; // score required to gain an extra life
	
	public var bulletSpeed:Float = 660;
	private var aim:FlxPoint;
	
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
	
	override public function draw():Void
	{
		super.draw();
	}
	
	override public function update():Void
	{
		super.update();
		
		if (multiplier > 1)
		{
			// update the multiplier timer
			if ((multiplierTimeLeft -= FlxG.elapsed) <= 0)
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
			angle = Entity.angleInDegrees(velocity);
			exhaust();
		}
		
		aim = GameInput.aim;
		if (cooldownTimer.finished && (aim.x != 0 || aim.y != 0)) shoot(aim);
		
		postUpdate();
	}
	
	public function postUpdate():Void
	{
		clampToScreen();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function kill():Void
	{
		super.kill();
		ScreenState.makeExplosion(Particle.NONE, position.x, position.y, 1200, Particle.HIGH_SPEED, 0xffff00, 0xffffff);
		cooldownTimer.abort();
		if (lives-- < 0) 
		{
			isGameOver = true;
			cooldownTimer.run(5, onTimerRestart);
		}
		else cooldownTimer.run(2, onTimerReset);
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
			
			cooldownTimer.abort();
			cooldownTimer.finished = true;
	}
	
	public function restart():Void
	{
		reset(0.5 *FlxG.width, 0.5 *FlxG.height);
		
		if (score > UserSettings.highScore) UserSettings.highScore = score;
		score = 0;
		multiplier = 1;
		lives = 4;
		scoreForExtraLife = 2000;
		multiplierTimeLeft = 0;
	}
	
	override public function collidesWith(Object:Entity, Distance:Float):Void
	{
			
	}
	
	public function shoot(Aim:FlxPoint):Void
	{
		cooldownTimer.abort();
		cooldownTimer.run(cooldown);
		
		var RandomSpread:Float = 4.58366236 * (FlxRandom.float() + FlxRandom.float()) - 4.58366236;
		
		if (GameInput.aimWithMouse)
		{
			Aim.x -= x;
			Aim.y -= y;
			Aim.y *= -1;
		}
		
		FlxAngle.rotatePoint(Aim.x, Aim.y, 0, 0, RandomSpread, Aim);
		
		var Angle:Float = Entity.angleInDegrees(Aim);
		FlxAngle.rotatePoint(8, 25, 0, 0, Angle + 90, _point);
		var PositionX:Float = _point.x + position.x;
		var PositionY:Float = _point.y + position.y;
		ScreenState.makeBullet(PositionX, PositionY, Angle, bulletSpeed);
		
		FlxAngle.rotatePoint(-8, 25, 0, 0, Angle + 90, _point);
		PositionX = _point.x + position.x;
		PositionY = _point.y + position.y;
		ScreenState.makeBullet(PositionX, PositionY, Angle, bulletSpeed);
		
		GameSound.randomSound(GameSound.sfxShoot, 0.4);
	}
	
	private function exhaust():Void
	{
		var t:Float = Lib.getTimer();
		
		// The primary velocity of the particles is 3 pixels/frame in the direction opposite to which the ship is travelling.
		_point.x = -velocity.x;
		_point.y = -velocity.y;
		GameInput.normalize(_point);
		var _speed:Float = 120 + 60 * FlxRandom.float();
		
		// Calculate the sideways velocity for the two side streams. The direction is perpendicular to the ship's velocity and the
		// magnitude varies sinusoidally.
		var _angle:Float = (45 + 15 * FlxRandom.float()) * Math.sin(0.01 * t);
		var _sideColor:UInt = 0xc82609; // deep red
		var _midColor:UInt = 0xffbb1e; // orange-yellow
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
		if (!instance.alive) return;
		
		score += BasePoints * multiplier;
		while (score >= scoreForExtraLife)
		{
			scoreForExtraLife += 2000;
			lives++;
		}
	}
	
	public static function increaseMultiplier():Void
	{
		if (!instance.alive) return;
		
		multiplierTimeLeft = MULTIPLIER_EXPIRY_TIME;
		if (multiplier < MULTIPLIER_MAX) multiplier++;
	}
}