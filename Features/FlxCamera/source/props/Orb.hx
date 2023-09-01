package props;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxDestroyUtil;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */
class Orb extends FlxNapeSprite
{
	var shadow:FlxSprite;

	public function new(x = 0.0, y = 0.0, radius:Int, ?graphic, ?shadowGraphic)
	{
		super(x, y, null, false);
		createCircularBody(radius);
		body.allowRotation = false;
		pixelPerfectPosition = false;
		pixelPerfectRender = false;
		
		// create a shadow that follows the sprite around
		shadow = new FlxSprite(x, y, shadowGraphic);
		shadow.blend = MULTIPLY;
		shadow.pixelPerfectPosition = false;
		shadow.pixelPerfectRender = false;
		#if debug
		shadow.ignoreDrawDebug = true;
		#end
		
		// call loadGraphic after the body is created so it adjusts the hitbox
		if (graphic != null)
			loadGraphic(graphic);
	}
	
	override function loadGraphic(graphic, animated = false, frameWidth = 0, frameHeight = 0, unique = false, ?key:String)
	{
		super.loadGraphic(graphic, animated, frameWidth, frameHeight, unique, key);
		
		// adjust flixel hitbox to match the radius for tighter camera following
		if (body != null && body.shapes != null)
		{
			width = body.bounds.width;
			height = body.bounds.height;
			centerOffsets(false);
			origin.set(width / 2, height / 2);
			
			// same offset for shadowP
			shadow.offset.copyFrom(offset);
		}
		
		return this;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		shadow.update(elapsed);
		shadow.x = x;
		shadow.y = y;
	}
	
	override function draw()
	{
		// draw shadow first, so it's underneath
		shadow.draw();
		super.draw();
	}
	
	override function destroy()
	{
		super.destroy();
		shadow = FlxDestroyUtil.destroy(shadow);
	}
}
