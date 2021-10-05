import flixel.FlxG;
import flixel.FlxSprite;

class Player extends DemoSprite
{
	// How fast the player moves
	inline static var PLAYER_SPEED:Int = 75;
	
	public function new()
	{
		super();
		loadGraphic("assets/ship.png");
		screenCenter();
		x += FlxG.width;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		// player movement
		velocity.set(0, 0);

		if (FlxG.keys.pressed.LEFT)
			velocity.x = -PLAYER_SPEED;
		if (FlxG.keys.pressed.RIGHT)
			velocity.x = PLAYER_SPEED;
		if (FlxG.keys.pressed.UP)
			velocity.y = -PLAYER_SPEED;
		if (FlxG.keys.pressed.DOWN)
			velocity.y = PLAYER_SPEED;
	}
}