package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.FlxSprite;

class PlayerShip extends FlxSprite		//Class declaration for the player's little ship
{
	
	//Constructor for the player - just initializing a simple sprite using a graphic.
	public function new()
	{
		//This initializes this sprite object with the graphic of the ship and
		// positions it in the middle of the screen.
		super(FlxG.width / 2 - 6, FlxG.height - 12, "assets/ship.png");
	}
	
	//Basic game loop function again!
	override public function update():Void
	{
		//Controls!
		velocity.x = 0;				//Default velocity to zero
		if(FlxG.keys.LEFT)
		{
			velocity.x -= 150;		//If the player is pressing left, set velocity to left 150
		}
		if(FlxG.keys.RIGHT)	
		{
			velocity.x += 150;		//If the player is pressing right, then right 150
		}
		
		//Just like in PlayState, this is easy to forget but very important!
		//Call this to automatically evaluate your velocity and position and stuff.
		super.update();
		
		//Here we are stopping the player from moving off the screen,
		// with a little border or margin of 4 pixels.
		if(x > FlxG.width-width-4)
		{
			x = FlxG.width-width-4; //Checking and setting the right side boundary
		}
		if(x < 4)
		{
			x = 4;					//Checking and setting the left side boundary
		}
		
		//Finally, we gotta shoot some bullets amirite?  First we check to see if the
		// space bar was just pressed (no autofire in space invaders you guys)
		if(FlxG.keys.justPressed("SPACE"))
		{
			//Space bar was pressed!  FIRE A BULLET
			var bullet:FlxSprite = cast(cast(FlxG.state, PlayState).playerBullets.recycle(), FlxSprite);
			bullet.reset(x + width/2 - bullet.width/2, y);
			bullet.velocity.y = -140;
		}
		
		super.update();
	}
}