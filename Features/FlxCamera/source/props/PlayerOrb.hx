package props;

import flixel.FlxG;
import nape.geom.Vec2;

/**
 * User controlled orb
 */
class PlayerOrb extends Orb
{
	/**
	 * The impulse applied each frame when pressing the corresponding key
	 */
	static inline var IMPULSE = 20;
	
	/**
	 * Used Internally to avoid creating new instances each frame
	 */
	static final impulseHelper = new Vec2();
	
	public function new(x = 0.0, y = 0.0)
	{
		super(x, y, 18, "assets/Orb.png", "assets/OrbShadow.png");
		// small amount of drag
		setDrag(0.98);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		// apply impusles to the body based on key presses
		
		if (FlxG.keys.anyPressed([A, LEFT]))
			applyImpulseXY(-IMPULSE, 0);
		
		if (FlxG.keys.anyPressed([S, DOWN]))
			applyImpulseXY(0, IMPULSE);
		
		if (FlxG.keys.anyPressed([D, RIGHT]))
			applyImpulseXY(IMPULSE, 0);
		
		if (FlxG.keys.anyPressed([W, UP]))
			applyImpulseXY(0, -IMPULSE);
	}
	
	/**
	 * Helper to apply impulse via x and y floats to avoid creating new Vec2 instances each frame
	 */
	inline function applyImpulseXY(x:Float, y:Float)
	{
		body.applyImpulse(impulseHelper.setxy(x, y));
	}
}