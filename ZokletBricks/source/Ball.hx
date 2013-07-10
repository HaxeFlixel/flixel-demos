package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Ball extends FlxSprite 
{
	public var _paddle:Paddle;
	
	public function new(ballX:Int, ballY:Int, imgString:String) 
	{
		super(ballX, ballY, imgString);
	}
	
	override public function update():Void 
	{	
		super.update();
		
		if (this.x < 0 || (this.x > FlxG.width - this.width)) 
		{
			this.velocity.x *= -1;
		}
		
		if (this.y < 0) 
		{
			this.velocity.y *= -1;
		}
	}
}