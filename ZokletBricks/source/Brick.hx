package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxSound;
import flixel.FlxSprite;

class Brick extends FlxSprite 
{	
	private var ballMC:Ball;
	public var deathTimer:Float;
	public var KILLTHIS:Bool;
	
	public var oldSpeedX:Float;
	public var oldSpeedY:Float;

	public function new() 
	{
		super();
	}
	
	public function init(brickX:Int, brickY:Int, imgString:String, ballClass:Ball):Brick
	{
		this.x = brickX;
		this.y = brickY;
		this.loadGraphic(imgString);
		
		deathTimer = .1;
		KILLTHIS = false;
		
		ballMC = ballClass;
		this.immovable = true;
		
		return this;
	}
	
	override public function update():Void 
	{					
		super.update();
		
		oldSpeedX = ballMC.velocity.x;
		oldSpeedY = ballMC.velocity.y;
		
		if (FlxG.collide(this, ballMC)) 
		{
			Reg.score++;
			FlxG.sound.play("BoopSound");
			this.kill();
			
			var verticalContact:Bool = (this.justTouched(FlxObject.DOWN) || this.justTouched(FlxObject.UP));
			var horizontalContact:Bool = (this.justTouched(FlxObject.LEFT) || this.justTouched(FlxObject.RIGHT));
			
			if (verticalContact)
			{
				ballMC.velocity.y = -oldSpeedY;
			}
			
			if (horizontalContact)
			{
				ballMC.velocity.x = -oldSpeedX;
			}
		}				
	}
}