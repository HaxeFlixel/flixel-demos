package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

/**
 * @author Zaphod
 */
class PlayState extends FlxState
{
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		
		// Sky-colored background
		FlxG.cameras.bgColor = 0xFF4D9BD3;
		
		var bottom = new FlxSprite();
		bottom.makeGraphic(FlxG.width, 5, 0xFF161b3a);
		bottom.y = FlxG.height - bottom.height;
		add(bottom);
		
		var grass:Grass;
		
		add(grass = new Grass(0, 0, 0, 0));
		grass.y = bottom.y - grass.height;
		
		add(grass = new Grass(0, 0, 1, -0.2));
		grass.y = bottom.y - grass.height;
		
		add(grass = new Grass(0, 0, 2, 0.2));
		grass.y = bottom.y - grass.height;
	}
}
