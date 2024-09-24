package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxPieGuage;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.geom.Rectangle;

/**
 * Demo for the soon to be added feature, FlxPieGuage. Will replace FlxPieDial and this demo
 */
class GuageState extends FlxState
{
	override public function create():Void
	{
		super.create();
		FlxG.cameras.bgColor = FlxColor.GRAY;
		
		final graphic = FlxG.bitmap.create(50, 50, FlxColor.BLACK, true, "make-guage");
		graphic.bitmap.fillRect(new Rectangle(2, 2, 46, 46), FlxColor.WHITE);

		final colors = [FlxColor.RED, FlxColor.BLUE, FlxColor.LIME, FlxColor.WHITE, FlxColor.YELLOW, FlxColor.MAGENTA];
		final spacingX = 66;
		final spacingY = 71;
		final setSize = colors.length;

		inline function makeStaticShapeGuage(x, y, color:FlxColor, shape:FlxPieGuageShape, clockwise = true, innerRadius:Int, amount:Float)
		{
			final guage = new FlxPieGuage(x, y);
			guage.makePieDialGraphic(shape, 25, innerRadius, color);
			if (!clockwise)
			{
				guage.setOrientation(270, -90);
			}
			guage.amount = amount;
			add(guage);
			return guage;
		}

		inline function makeStaticAssetGuage(x, y, graphic, clockwise = true, amount:Float, color = FlxColor.WHITE)
		{
			final guage = new FlxPieGuage(x, y, graphic);
			guage.color = color;
			
			if (!clockwise)
			{
				guage.setOrientation(270, -90);
			}
			
			guage.amount = amount;
			add(guage);
			return guage;
		}

		inline function makeStaticSet(x:Float, y, graphic:GuageGraphic, clockwise = true)
		{
			switch (graphic)
			{
				case SHAPE(shape, innerRadius):
					final innerRadius = innerRadius == null ? 0 : innerRadius;
					for (i in 0...setSize)
						makeStaticShapeGuage(x + i * spacingX, y, colors[i], shape, clockwise, innerRadius, (i+1) / setSize);
				case ASSET(asset):
					for (i in 0...setSize)
						makeStaticAssetGuage(x + i * spacingX, y, asset, clockwise, (i+1) / setSize, colors[i]);
				case MAKE:
					final graphic = FlxG.bitmap.get("make-guage");
					for (i in 0...setSize)
						makeStaticAssetGuage(x + i * spacingX, y, graphic, clockwise, (i+1) / setSize, colors[i]);
			}
		}
		
		var y = 10;
		
		inline function makeStaticRow(graphic:GuageGraphic)
		{
			makeStaticSet(10, y, graphic, true);
			makeStaticSet(spacingX * setSize + 10, y, graphic, false);
			y += spacingY;
		}
		
		makeStaticRow(SHAPE(CIRCLE));
		makeStaticRow(SHAPE(SQUARE));
		makeStaticRow(SHAPE(CIRCLE, 12));
		makeStaticRow(SHAPE(SQUARE, 12));
		makeStaticRow(ASSET("assets/images/flixel.png"));
		makeStaticRow(MAKE);
		
		var x = 10;
		final tweened = new FlxTypedGroup<FlxPieGuage>();
		inline function makeTweened(graphic:GuageGraphic, clockwise = true, color = FlxColor.WHITE)
		{
			final guage = switch (graphic)
			{
				case SHAPE(shape, innerRadius):
					final guage = new FlxPieGuage(x, y);
					guage.makePieDialGraphic(shape, 25, innerRadius, color);
					guage;
				case ASSET(asset):
					new FlxPieGuage(x, y, asset);
				case MAKE:
					final guage = new FlxPieGuage(x, y, FlxG.bitmap.get("make-guage"));
					guage.color = color;
					guage;
			}
			
			if (!clockwise)
			{
				guage.setOrientation(270, -90);
			}
			
			tweened.add(guage);
			x += spacingX;
			
			return guage;
		}
		add(tweened);
		
		// clockwise
		makeTweened(SHAPE(CIRCLE, 0 ), true, colors[0]);
		makeTweened(SHAPE(CIRCLE, 10), true, colors[1]);
		makeTweened(SHAPE(SQUARE, 0 ), true, colors[2]);
		makeTweened(SHAPE(SQUARE, 10), true, colors[3]);
		makeTweened(ASSET("assets/images/flixel.png"), true);
		makeTweened(MAKE, true, colors[5]);
		// counter-clockwise
		makeTweened(SHAPE(CIRCLE, 0 ), false, colors[0]);
		makeTweened(SHAPE(CIRCLE, 10), false, colors[1]);
		makeTweened(SHAPE(SQUARE, 0 ), false, colors[2]);
		makeTweened(SHAPE(SQUARE, 10), false, colors[3]);
		makeTweened(ASSET("assets/images/flixel.png"), false);
		makeTweened(MAKE, false, colors[5]);
		
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

enum GuageGraphic
{
	SHAPE(shape:FlxPieGuageShape, ?innerRadius:Int);
	ASSET(asset:FlxGraphicAsset);
	MAKE;
}
