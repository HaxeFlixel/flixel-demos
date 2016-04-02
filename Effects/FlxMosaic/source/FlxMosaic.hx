/**
 * Credits: Terry Paton
 * http://www.terrypaton.com
 * 
 * http://snipplr.com/view/47554/as3-pixelate-bitmapdata/
 */

package ;
 
	import flixel.FlxSprite;
	import openfl.Assets;
	import openfl.display.BitmapData;
	import openfl.geom.Matrix;
	import openfl.geom.Point;
	import openfl.geom.Rectangle;
	
	/**
	 * FlxMosaic applies a mosaic (pixelated) effect to the provided image
	 */
	
	class FlxMosaic extends FlxSprite
	{
		public var _pixelateMatrix:Matrix = new Matrix();
		
		/**
		 * The "canvas" on which to draw the manipulated pixels on.
		 */
		public var _resultBmd:BitmapData;
		
		/**
		 * The original image data
		 */
		public var _srcBmd:BitmapData;
		
		/**
		 * How pixelated the graphic is
		 */
		private var amount:Float = 0;
		
		public function new(_x:Float, _y:Float, assetStr:String):Void
		{
			super(0, 0, assetStr);
			_srcBmd = Assets.getBitmapData(assetStr);
			_resultBmd = new BitmapData(pixels.width, pixels.height);
		}
		
		public function setAmount(v:Float):Void
		{
			amount = v;
		}
		
		override public function update(elapsed:Float):Void
		{
			if (amount > 0)
			{
				process(_srcBmd, amount);
				pixels.copyPixels(_resultBmd, new Rectangle(0, 0, _resultBmd.width, _resultBmd.height), new Point(0, 0));
			}
			
			super.update(elapsed);
		}
		
		public function process(_source:BitmapData, amount:Float):Void
		{
			var scaleFactor:Float = 1 / amount;
			var bmpX:Int = Std.int(scaleFactor * _resultBmd.width);
			var bmpY:Int = Std.int(scaleFactor * _resultBmd.height);
			
			if (bmpX < 1)
			{
				bmpX = 10;
			}
			if (bmpY < 1)
			{
				bmpY = 10;
			}
			
			// scale image down
			_pixelateMatrix.identity();
			_pixelateMatrix.scale(scaleFactor, scaleFactor);
			
			var _tempBmpData:BitmapData = new BitmapData(bmpX, bmpY, false, 0xFF0000);
			_tempBmpData.draw(_source, _pixelateMatrix);
			
			// now scale it back
			_pixelateMatrix.identity();
			_pixelateMatrix.scale(amount, amount);
			
			_resultBmd.draw(_tempBmpData, _pixelateMatrix);
		}
	}
