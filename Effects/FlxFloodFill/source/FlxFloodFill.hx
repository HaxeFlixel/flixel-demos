/**
 * 
 * A HaxeFlixel port of Photonstorm's 'FloodFillFX':
 * https://github.com/photonstorm/Flixel-Power-Tools/blob/master/src/org/flixel/plugin/photonstorm/FX/FloodFillFX.as
 * 
 */

package;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

/**
 * "Creates a flood fill effect FlxSprite, useful for bringing in images in cool ways"
 */
class FlxFloodFill extends FlxSprite
{
	private var complete:Bool = false;
	private var isFilling:Bool = false;
	private var dropRect:Rectangle;
	private var dropPoint:Point;
	private var dropY:Int;
	private var srcBitmapData:BitmapData;
	private var fillDelay:Float = .05;
	private var fillClock:Float = 0;
	
	/**
	 * How many pixels to drop per update
	 */
	private var fillOffset:Int = 1;
	
	/**
	 * @param _x The effect's x-position.
	 * @param _y The effect's y-position.
	 * @param _srcBmd The image data used for the effect.
	 * @param _width The width of the effect.
	 * @param _height The height of the effect (a value larger than the source image makes the effect taller!).
	 * @param _fillLinesPerUpdate Number of lines per update to fill the effect with.
	 * @param _delayPerUpdate The time delay between each update.
	 */
	public function new(_x:Float, _y:Float, _srcBmd:BitmapData, ?_width:Int, ?_height:Int, ?_fillLinesPerUpdate:Int = 1, ?_delayPerUpdate:Float = .05)
	{
		super(_x, _y);
		
		if ((_width != null && _width != _srcBmd.width) || (_height != null && _height != _srcBmd.height))
		{
			srcBitmapData = new BitmapData(_width, _height, true, FlxColor.TRANSPARENT);
			srcBitmapData.copyPixels(_srcBmd, new Rectangle(0, 0, _srcBmd.width, _srcBmd.height), new Point(0, _height -_srcBmd.height));
		}
		else
		{
			srcBitmapData = _srcBmd;
		}
		
		makeGraphic(srcBitmapData.width, srcBitmapData.height, FlxColor.TRANSPARENT, true);
		
		fillDelay = _delayPerUpdate;
		fillOffset = _fillLinesPerUpdate;
		
		dropRect = new Rectangle(0, srcBitmapData.height-fillOffset, srcBitmapData.width, fillOffset);
		dropPoint = new Point();
		dropY = srcBitmapData.height;
	}
	
	/**
	 * Starts the effect
	 */
	public function start():Void
	{
		isFilling = true;
	}
	
	/**
	 * Pauses the effect
	 */
	public function stop():Void
	{
		isFilling = false;
	}
	
	override public function update(elapsed:Float)
	{
		if (isFilling && complete == false) 
		{
			fillClock += FlxG.elapsed;
			
			if (dropRect.y >= 0 && fillClock >= fillDelay)
			{
				pixels.lock();
				
				var _y:Int = 0;
				while (_y < dropY) 
				{
					dropPoint.y = _y;
					pixels.copyPixels(srcBitmapData, dropRect, dropPoint);
					_y += fillOffset;
				}
				
				dropY -= fillOffset;
				dropRect.y -= fillOffset;
				
				dirty = true;
				pixels.unlock();
				fillClock = 0;
				
				if (dropY <= 0)
				{
					complete = true;
				}
			}
		}
		
		super.update(elapsed);
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		FlxDestroyUtil.dispose(srcBitmapData);
		srcBitmapData = null;
		
		dropPoint = null;
		dropRect = null;
	}
}