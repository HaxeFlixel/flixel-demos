package props;

import flixel.FlxG;
import flixel.FlxSprite;
// import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;
// import nape.geom.Vec2;

class OtherOrb extends Orb
{
	public function new(x = 0.0, y = 0.0, colorIndex:Int)
	{
		super(x, y, 50, null, "assets/OtherOrbShadow.png");
		
		loadGraphic("assets/OtherOrb.png", true, 140, 140);
		animation.frameIndex = colorIndex;
		setBodyMaterial(1, 0.0, 0.0, 0.5);
	}
	
	/**
	 * Randomizes the position of this orb within the given bounds
	 */
	public function randomizePosition(minX = 0, maxX = 0, minY = 0, maxY = 0)
	{
		x = body.position.x = FlxG.random.int(minX, maxX - Math.ceil(width));
		y = body.position.y = FlxG.random.int(minY, maxY - Math.ceil(height));
		return this;
	}
	
	/**
	 * Randomizes the velocity of this orb with the given absolute speed range and a random angle
	 */
	public function randomizeVelocity(min = 100, max = 200)
	{
		body.velocity.setxy(FlxG.random.float(min, max), 0);
		body.velocity.angle = FlxG.random.float(0, 2 * Math.PI);
		return this;
	}
}