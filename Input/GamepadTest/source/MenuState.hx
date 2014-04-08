package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Zaphod
 */
class MenuState extends FlxState
{

	override public function create():Void 
	{
		FlxG.cameras.bgColor = FlxColor.WHITE;
		
		var text:FlxText = new FlxText(0, 0, FlxG.width - 200, "Press any button on your gamepad so we can detect it.", 16);
		text.setFormat(null, 16, FlxColor.BLACK, "center");
		FlxSpriteUtil.screenCenter(text);
		add(text);
		
		super.create();
	}
	
	override public function update():Void 
	{
		if (FlxG.gamepads.anyButton())
		{
			FlxG.switchState(new PlayState());
		}
		
		super.update();
	}
	
}