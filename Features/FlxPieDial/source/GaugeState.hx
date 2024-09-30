package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxRadialGauge;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.geom.Rectangle;

/**
 * Demo for the soon to be added feature, FlxRadialGauge. Will replace FlxPieDial and this demo
 */
class GaugeState extends FlxState
{
	override public function create():Void
	{
		super.create();
		FlxG.cameras.bgColor = FlxColor.GRAY;
		
		makeGraphics();
		
		final colors = [FlxColor.RED, FlxColor.BLUE, FlxColor.LIME, FlxColor.WHITE, FlxColor.YELLOW, FlxColor.MAGENTA];
		final spacingX = 66;
		final spacingY = 71;
		final setSize = colors.length;

		inline function makeStaticShapeGauge(x, y, color:FlxColor, shape:FlxRadialGaugeShape, clockwise = true, innerRadius:Int, amount:Float)
		{
			final gauge = new FlxRadialGauge(x, y);
			gauge.makeShapeGraphic(shape, 25, innerRadius, color);
			if (!clockwise)
			{
				gauge.setOrientation(270, -90);
			}
			gauge.amount = amount;
			add(gauge);
			return gauge;
		}

		inline function makeStaticAssetGauge(x, y, graphic, clockwise = true, amount:Float, color = FlxColor.WHITE)
		{
			final gauge = new FlxRadialGauge(x, y, graphic);
			gauge.color = color;
			
			if (!clockwise)
			{
				gauge.setOrientation(270, -90);
			}
			
			gauge.amount = amount;
			add(gauge);
			return gauge;
		}

		inline function makeStaticSet(x:Float, y, graphic:GaugeGraphic, clockwise = true)
		{
			switch (graphic)
			{
				case SHAPE(shape, innerRadius):
					final innerRadius = innerRadius == null ? 0 : innerRadius;
					for (i in 0...setSize)
						makeStaticShapeGauge(x + i * spacingX, y, colors[i], shape, clockwise, innerRadius, (i+1) / setSize);
				case ASSET(asset):
					for (i in 0...setSize)
						makeStaticAssetGauge(x + i * spacingX, y, asset, clockwise, (i+1) / setSize, colors[i]);
			}
		}
		
		var y = 10;
		
		inline function makeStaticRow(graphic:GaugeGraphic)
		{
			makeStaticSet(10, y, graphic, true);
			makeStaticSet(spacingX * setSize + 10, y, graphic, false);
			y += spacingY;
		}
		
		makeStaticRow(SHAPE(CIRCLE));
		makeStaticRow(SHAPE(SQUARE));
		makeStaticRow(SHAPE(CIRCLE, 12));
		makeStaticRow(SHAPE(SQUARE, 12));
		makeStaticRow(ASSET("logo-50x50"));
		makeStaticRow(ASSET("square-50x50"));
		
		var x = 10;
		final tweened = new FlxTypedGroup<FlxRadialGauge>();
		inline function makeTweened(graphic:GaugeGraphic, clockwise = true, color = FlxColor.WHITE)
		{
			final gauge = switch (graphic)
			{
				case SHAPE(shape, innerRadius):
					final gauge = new FlxRadialGauge(x, y);
					gauge.makeShapeGraphic(shape, 25, innerRadius, color);
					gauge;
				case ASSET(asset):
					final gauge = new FlxRadialGauge(x, y, asset);
					gauge.color = color;
					gauge;
			}
			
			if (!clockwise)
			{
				gauge.setOrientation(270, -90);
			}
			
			tweened.add(gauge);
			x += spacingX;
			
			return gauge;
		}
		add(tweened);
		
		// clockwise
		makeTweened(SHAPE(CIRCLE, 0 ), true, colors[0]);
		makeTweened(SHAPE(CIRCLE, 10), true, colors[1]);
		makeTweened(SHAPE(SQUARE, 0 ), true, colors[2]);
		makeTweened(SHAPE(SQUARE, 10), true, colors[3]);
		makeTweened(ASSET("logo-50x50"), true);
		makeTweened(ASSET("square-50x50"), true, colors[5]);
		// counter-clockwise
		makeTweened(SHAPE(CIRCLE, 0 ), false, colors[0]);
		makeTweened(SHAPE(CIRCLE, 10), false, colors[1]);
		makeTweened(SHAPE(SQUARE, 0 ), false, colors[2]);
		makeTweened(SHAPE(SQUARE, 10), false, colors[3]);
		makeTweened(ASSET("logo-50x50"), false);
		makeTweened(ASSET("square-50x50"), false, colors[5]);
		
		FlxTween.num(-0.1, 1.1, 2.0, {type: PINGPONG}, function (n)
		{
			final n = Math.min(1.0, Math.max(0.0, n));
			for (gauge in tweened)
				gauge.amount = n;
			
			#if debug
			FlxG.watch.addQuick("amount", n);
			#end
		});
	}
	
	function makeGraphics()
	{
		// Create outlined square
		final graphic = FlxG.bitmap.create(50, 50, FlxColor.BLACK, true, "square-50x50");
		graphic.bitmap.fillRect(new Rectangle(2, 2, 46, 46), FlxColor.WHITE);
		
		// Create logo graphic
		final logo = new openfl.display.Shape();
		flixel.system.FlxAssets.drawLogo(logo.graphics);
		final mat = new flixel.math.FlxMatrix();
		final graphic = FlxG.bitmap.create(50, 50, 0x0, false, "logo-50x50");
		mat.scale(graphic.width / logo.width, graphic.height / logo.height);
		graphic.bitmap.draw(logo, mat);
	}
}

enum GaugeGraphic
{
	SHAPE(shape:FlxRadialGaugeShape, ?innerRadius:Int);
	ASSET(asset:FlxGraphicAsset);
}
