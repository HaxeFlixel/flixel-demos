package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxPieDial;
import flixel.addons.display.FlxPieGuage;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class DemoState extends FlxState
{
	var pieDial:FlxPieDial;
	
	override public function create():Void
	{
		super.create();
		FlxG.cameras.bgColor = FlxColor.GRAY;

		final colors = [FlxColor.RED, FlxColor.BLUE, FlxColor.LIME, FlxColor.WHITE];
		final spacingX = 100;
		final spacingY = 100;

		inline function createDial(x, y, color, shape = CIRCLE, clockwise = true, innerRadius = 0, quarters:Int)
		{
			final dial = new FlxPieDial(x, y, 25, color, 4, shape, clockwise, innerRadius);
			dial.amount = quarters * .25;
			add(dial);
			return dial;
		}

		inline function createFour(x:Float, y, shape = CIRCLE, clockwise = true, innerRadius = 0)
		{
			for (i in 0...4)
				createDial(x + i * spacingX, y, colors[i], shape, clockwise, innerRadius, i+1);
		}
		
		var y = 10;
		
		inline function createEight(shape = CIRCLE, innerRadius = 0)
		{
			createFour(10, y, shape, true, innerRadius);
			createFour(spacingX * 4 + 10, y, shape, false, innerRadius);
			y += spacingY;
		}
		
		createEight(CIRCLE);
		createEight(SQUARE);
		createEight(CIRCLE, 12);
		createEight(SQUARE, 12);
		
		var x = 10;
		final tweened = new FlxTypedGroup<FlxPieDial>();
		inline function createTweened(color, shape, innerRadius = 0, clockwise = true)
		{
			final dial = new FlxPieDial(x, y, 25, color, 36, shape, clockwise, innerRadius);
			tweened.add(dial);
			x += spacingX;
			
			return dial;
		}
		add(tweened);
		
		// clockwise
		createTweened(colors[0], CIRCLE, 0 , true);
		createTweened(colors[1], CIRCLE, 10, true);
		createTweened(colors[2], SQUARE, 0 , true);
		createTweened(colors[3], SQUARE, 10, true);
		// counter-clockwise
		createTweened(colors[0], CIRCLE, 0 , false);
		createTweened(colors[1], CIRCLE, 10, false);
		createTweened(colors[2], SQUARE, 0 , false);
		createTweened(colors[3], SQUARE, 10, false);
		
		FlxTween.num(-0.1, 1.1, 2.0, {type: PINGPONG}, function (n)
		{
			final n = Math.min(1.0, Math.max(0.0, n));
			for (dial in tweened)
				dial.amount = n;
			
			#if debug
			FlxG.watch.addQuick("amount", n);
			#end
		});
	}
}
