package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import openfl.Assets;
import flixel.FlxG;
import flixel.FlxState;
import flixel.system.input.FlxTouch;

import flixel.FlxSprite;
import flixel.system.input.FlxTouchManager;

class MenuState extends FlxState
{
	private var activeSprites:Map<Int, FlxSprite>;
	private var inactiveSprites:Array<FlxSprite>;
	
	private var touchSprite:FlxSprite;
	private var touch:FlxTouch;
	private var touches:Array<FlxTouch>;
	
	override public function create():Void
	{
		FlxG.state.bgColor = 0xff131c1b;
		
		activeSprites = new Map<Int, FlxSprite>();
		inactiveSprites = new Array<FlxSprite>();
		
		/*touchSprite = new FlxSprite();
		touchSprite.makeGraphic(50, 50);
		touchSprite.color = Std.int(Math.random() * 0xffffff);
		add(touchSprite);*/
	}

	override public function update():Void
	{
		super.update();
		
		touches = FlxG.touchManager.touches;
		
		for (touch in touches)
		{
			touchSprite = null;
			
			if (touch.justPressed() == true && activeSprites.exists(touch.touchPointID) == false)
			{
				if (inactiveSprites.length > 0)
				{
					touchSprite = inactiveSprites.pop();
					touchSprite.visible = true;
				}
				else
				{
					touchSprite = new FlxSprite();
					touchSprite.makeGraphic(50, 50);
					add(touchSprite);
				}
				
				touchSprite.color = Std.int(Math.random() * 0xffffff);
				activeSprites.set(touch.touchPointID, touchSprite);
			}
			else if (touch.justReleased() == true && activeSprites.exists(touch.touchPointID) == true)
			{
				touchSprite = activeSprites.get(touch.touchPointID);
				touchSprite.visible = false;
				activeSprites.remove(touch.touchPointID);
				inactiveSprites.push(touchSprite);
				touchSprite = null;
			}
			else
			{
				touchSprite = activeSprites.get(touch.touchPointID);
			}
			
			if (touchSprite != null)
			{
				touchSprite.x = touch.x;
				touchSprite.y = touch.y;
			}
			
		}
	}
}