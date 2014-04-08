package ;
import flash.Lib;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flash.display.BitmapData;
import flixel.FlxG;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Masadow
 */
class Enemy extends Entity
{
	public static inline var SEEKER:UInt = 0;
	public static inline var WANDERER:UInt = 1;
	public static inline var BLACK_HOLE:UInt = 2;
	
	//private var enemyPixels:Array<BitmapData>;
	private var enemyPixels:Array<String>;
	private var pointValue:Int = 10;
	
	private var _saveWidth : Int;
	private var _saveHeight : Int;
	
	public function new(X:Float = 0, Y:Float = 0, Type:UInt = 0)
	{
		super(FlxG.width * FlxRandom.float(), FlxG.height * FlxRandom.float());

		//enemyPixels = new Array<BitmapData>();
		enemyPixels = new Array<String>();
//
		//enemyPixels.push(loadRotatedGraphic("images/Seeker.png", 360, -1, true, true).pixels);
		//enemyPixels.push(loadRotatedGraphic("images/Wanderer.png", 360, -1, true, true).pixels);
		//enemyPixels.push(loadRotatedGraphic("images/BlackHole.png", 360, -1, true, true).pixels);
		enemyPixels.push("images/Seeker.png");
		enemyPixels.push("images/Wanderer.png");
		enemyPixels.push("images/BlackHole.png");

		//_saveWidth = cast width;
		//_saveHeight = cast height;
//		cachedGraphics.bitmap = enemyPixels[SEEKER];
		//pixels = enemyPixels[SEEKER];
		//region.width = cast width = frameWidth = _saveWidth;
		//region.height = cast height = frameHeight = _saveHeight;
		
		loadRotatedGraphic(enemyPixels[SEEKER], 360, -1, true, true);
		
		type = SEEKER;
		
		radius = 20;
		hitboxRadius = 18;
		maxVelocity.x = maxVelocity.y = 300;
		
		alive = false;
		exists = false;
	}
	
	override public function draw():Void
	{
		super.draw();
	}
	
	override public function update():Void
	{
		super.update();
		
		if (!alive) return;
		
		if (alpha >= 1)
		{
			applyBehaviors();
		}
		else
		{
			alpha += FlxG.elapsed;
		}
		
		if (type == BLACK_HOLE)
		{
			var _angle:Float = (0.720 * Lib.getTimer()) % 360;
			ScreenState.grid.applyImplosiveForce(position, 0.5 * Math.sin(Entity.toRadians(_angle)) * 150 + 300, 200);
			if (cooldownTimer.finished)
			{
//					cooldownTimer.abort();
				cooldownTimer.reset(0.02 + 0.08 * FlxRandom.float());
				var _color:UInt = 0xff00ff;//Entity.HSVtoRGB(5, 0.5, 0.8); // light purple
				var _speed:Float = 360 + FlxRandom.float() * 90;
				var _offsetX:Float = 16 * Math.sin(Entity.toRadians(_angle));
				var _offsetY:Float = -16 * Math.cos(Entity.toRadians(_angle));
				ScreenState.makeParticle(Particle.ENEMY, position.x + _offsetX, position.y + _offsetY, _angle, _speed, _color);
			}
		}

		//gradually build up speed
		//velocity.x *= 0.8;
		//velocity.y *= 0.8;
		postUpdate();
	}
	
	public function postUpdate():Void
	{
		if (type != BLACK_HOLE) hitEdgeOfScreen = clampToScreen();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function hurt(Damage:Float):Void
	{
		super.hurt(Damage);
		
		if (type == BLACK_HOLE)
		{
			var hue:Float = (0.180 * Lib.getTimer()) % 360;
			var _color:UInt = Entity.HSVtoRGB(hue, 0.25, 1);
			ScreenState.makeExplosion(Particle.IGNORE_GRAVITY, position.x, position.y, 100, Particle.MEDIUM_SPEED, _color);
		}
	}
	
	override public function kill():Void
	{
		if (!alive) return;
		PlayerShip.addPoints(pointValue);
		PlayerShip.increaseMultiplier();
		super.kill();
		GameSound.randomSound(GameSound.sfxExplosion, 0.5);
		
		var _color:UInt;
		switch (Std.int(6 * FlxRandom.float()))
		{
			case 0: _color = 0xff3333;
			case 1: _color = 0x33ff33;
			case 2: _color = 0x3333ff;
			case 3: _color = 0xffffaa;
			case 4: _color = 0xff33ff;
			case 5: _color = 0x00ffff;
			default: _color = 0xffffff;
		}
		ScreenState.makeExplosion(Particle.ENEMY, position.x, position.y, 90, Particle.MEDIUM_SPEED, _color, FlxColor.WHITE);
	}
	
	//public var type(get, set): UInt;
	//
	//public function get_type()
	//{
		//return type;
	//}
	
//	@:setter(type)
	override public function set_type(Value:UInt):UInt
	{
		var _previousType:UInt = type;
		type = Value;

		// Change the pixel BitmapData if the type changed
		if (_previousType != type)
		{
			//cachedGraphics.bitmap = enemyPixels[type];
			//pixels = enemyPixels[type];
			//region.tileWidth = cast width = frameWidth = _saveWidth;
			//region.tileHeight = cast height = frameHeight = _saveHeight;
			loadRotatedGraphic(enemyPixels[type], 360, -1, true, true);
			dirty = true;
		}
		
		switch (type)
		{
			case SEEKER:
				alpha = 0;
				health = 1;
				radius = 20;
				hitboxRadius = 18;
			case WANDERER:
				alpha = 0;
				health = 1;
				radius = 20;
				hitboxRadius = 18;
			case BLACK_HOLE:
				alpha = 1;
				health = 10;
				radius = 250;
				hitboxRadius = 18;
		}
		width = height = 2 * Math.max(radius, hitboxRadius);
		centerOffsets();
		return Value;
	}
	
	override public function collidesWith(Object:Entity, DistanceSquared:Float):Void
	{
		var CombinedHitBoxRadius:Float = hitboxRadius + Object.hitboxRadius;
		var IsHitBoxCollision:Bool = (CombinedHitBoxRadius * CombinedHitBoxRadius) >= DistanceSquared;
		var AngleFromCenters:Float = Entity.toRadians(FlxAngle.getAngle(position, Object.position));
		if (Std.is(Object, Bullet))
		{
			if (IsHitBoxCollision) 
			{
				Object.kill();
				hurt(1);
			}
			else
			{
				if (type == BLACK_HOLE)
				{
					Object.velocity.x -= FlxG.elapsed * 1100 * Math.cos(AngleFromCenters);
					Object.velocity.y -= FlxG.elapsed * 1100 * Math.sin(AngleFromCenters);
				}
			}
		}
		else if (Std.is(Object, Enemy))
		{
			var IsBlackHole:Bool = (type == BLACK_HOLE);
			if (IsBlackHole && cast(Object, Enemy).type == BLACK_HOLE) return;
			
			if (IsHitBoxCollision) 
			{
				if (IsBlackHole) Object.kill();
			}
			else
			{
				if (IsBlackHole)
				{
					var GravityStrength:Float = FlxG.elapsed * 15 * Entity.Interpolate(60, 0, Math.sqrt(DistanceSquared) / radius);
					Object.velocity.x += GravityStrength * Math.cos(AngleFromCenters);
					Object.velocity.y += GravityStrength * Math.sin(AngleFromCenters);
				}
				else
				{
					var XDistance:Float = position.x - Object.position.x;
					var YDistance:Float = position.y - Object.position.y;
					velocity.x += FlxG.elapsed * 18000 * XDistance / (DistanceSquared + 1);
					velocity.y += FlxG.elapsed * 18000 * YDistance / (DistanceSquared + 1);
				}
			}
		}
		else if (Std.is(Object, PlayerShip))
		{
			if (IsHitBoxCollision) Object.kill();
		}
	}
	
	override public function reset(X:Float, Y:Float):Void
	{
		cooldownTimer.abort();
		alpha = 0;
		acceleration.x = acceleration.y = 0;	
		angularVelocity = 0;
		super.reset(X - 0.5 * width, Y - 0.5 * height);
	}
	
	private function applyBehaviors():Void
	{
		if (type == SEEKER) followPlayer();
		else if (type == WANDERER) moveRandomly();
		else if (type == BLACK_HOLE) applyGravity();
	}
	
	private function followPlayer(Acceleration:Float = 5):Void
	{
		if (PlayerShip.instance.alive) 
		{
			acceleration.x = Acceleration * (PlayerShip.instance.position.x - position.x);
			acceleration.y = Acceleration * (PlayerShip.instance.position.y - position.y);
			angle = Entity.angleInDegrees(acceleration);
		}
		else moveRandomly();
	}
	
	private function moveRandomly(Acceleration:Float = 320):Void
	{
		var Angle:Float;
		if (hitEdgeOfScreen) 
		{
			//cooldownTimer.abort();
			//cooldownTimer = FlxTimer.start(1);
			cooldownTimer.reset(1);
			Angle = 2 * Math.PI * FlxRandom.float();
			velocity.x = 0;
			velocity.y = 0;
			acceleration.x = Acceleration * Math.cos(Angle);
			acceleration.y = Acceleration * Math.sin(Angle);
			angularVelocity = 200;
		}
		
		if (!cooldownTimer.finished || hitEdgeOfScreen) return;
		//cooldownTimer.abort();
		//cooldownTimer = FlxTimer.start(1);
		cooldownTimer.reset(1);
		Angle = 2 * Math.PI * FlxRandom.float();
		acceleration.x = Acceleration * Math.cos(Angle);
		acceleration.y = Acceleration * Math.sin(Angle);
		angularVelocity = 200;
	}
	
	private function applyGravity(Acceleration:Float = 320):Void
	{
		angularVelocity = 200;
	}
}