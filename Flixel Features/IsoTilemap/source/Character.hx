package ;

import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Masadow
 */
class Character extends FlxSprite
{

	public function new(X : Int, Y : Int) 
	{
		super(X, Y);
		loadGraphic("images/character.png", true, false, 32, 32);

		for (i in 0...4)
		{
			animation.add("stop" + i, [1 + (i * 3)]);
			animation.add("move" + i, [0 + (i * 3), 1 + (i * 3), 2 + (i * 3)]);
		}
	}
	
	//Return feet position
	public function getFeetpoint() : FlxPoint
	{
		return new FlxPoint(x + 16, y + 24);
	}
	
}