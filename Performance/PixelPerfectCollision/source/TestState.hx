package;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxAngle;
import flixel.math.FlxRect;

using flixel.util.FlxSpriteUtil;

class TestState extends FlxState
{
	var player:Player;

	override public function create():Void
	{
		super.create();

		// create the player
		add(player = new Player());

		// don't need the cursor
		FlxG.mouse.visible = false;
		
		var field = new FlxText();
		field.text
			= "Mouse: move\n"
			+ "Click: toggle auto rotate\n"
			+ "Arrows: move offset\n"
			+ "SHIFT + Arrows: change scale\n"
			+ "ALT + Arrows: move origin\n"
			+ "Q/E: rotate\n"
			+ "Enter: reset";
		field.y = FlxG.height - field.height;
		field.setBorderStyle(OUTLINE);
		#if debug field.ignoreDrawDebug = true; #end
		add(field);
		
		#if debug FlxG.debugger.drawDebug = true; #end
	}
}

private class Player extends FlxSprite
{
	var rotatedRect = new FlxObject();
	var offsetRect = new FlxObject();
	var pivot = new FlxObject(0, 0, 2, 2);
	var rect = new FlxRect();
	
	public function new()
	{
		super();
		makeGraphic(50, 50, 0xFFffffff);
		screenCenter();
		rotatedRect.immovable = true;
		offsetRect.immovable = true;
		pivot.immovable = true;
		
		#if debug
		// ignoreDrawDebug = true;
		#end
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		x = FlxG.mouse.x;
		y = FlxG.mouse.y;
		
		var left  = FlxG.keys.anyPressed([LEFT , A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);
		var up    = FlxG.keys.anyPressed([UP   , W]);
		var down  = FlxG.keys.anyPressed([DOWN , S]);
		
		if (FlxG.keys.pressed.SHIFT)
		{
			if (left ) scale.x -= 0.05;
			if (right) scale.x += 0.05;
			if (up   ) scale.y += 0.05;
			if (down ) scale.y -= 0.05;
			
			width  = frameWidth  * scale.x;
			height = frameHeight * scale.y;
		}
		else if (FlxG.keys.pressed.ALT)
		{
			if (left ) origin.x--;
			if (right) origin.x++;
			if (up   ) origin.y--;
			if (down ) origin.y++;
		}
		else
		{
			// move opposite for offset
			if (left ) offset.x++;
			if (right) offset.x--;
			if (up   ) offset.y++;
			if (down ) offset.y--;
		}
		
		if (FlxG.keys.pressed.Q) angle -= 2;
		if (FlxG.keys.pressed.E) angle += 2;
		if (FlxG.keys.pressed.ENTER)
		{
			scale.set(1, 1);
			offset.set(0, 0);
			updateHitbox();
			centerOrigin();
			angle = 0;
			angularVelocity = 0;
		}
		
		var wheel = FlxG.mouse.wheel;
		if (wheel != 0)
		{
			var scroll = FlxMath.bound(scrollFactor.x + wheel / 50, 1/50, 2.0);
			scrollFactor.set(scroll, scroll);
			trace(wheel, scroll);
		}
		
		if (FlxG.mouse.justPressed)
			angularVelocity = angularVelocity == 0 ? 50 : 0;
		
		offsetRect.update(elapsed);
		offsetRect.width  = scale.x * frameWidth;
		offsetRect.height = scale.y * frameHeight;
		offsetRect.x = x - offset.x + origin.x - origin.x * scale.x;
		offsetRect.y = y - offset.y + origin.y - origin.y * scale.y;
		
		pivot.update(elapsed);
		pivot.x = x + origin.x - offset.x - pivot.width  / 2;
		pivot.y = y + origin.y - offset.y - pivot.height / 2;
		
		rotatedRect.update(elapsed);
		rect = calcRotatedGraphicBounds(rect);
		rotatedRect.x = rect.x;
		rotatedRect.y = rect.y;
		rotatedRect.width = rect.width;
		rotatedRect.height = rect.height;
	}
	
	override function draw()
	{
		super.draw();
		
		rotatedRect.draw();
		offsetRect.draw();
		pivot.draw();
	}
}
