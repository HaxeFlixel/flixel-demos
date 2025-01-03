package;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flixel.util.FlxSave;

class Reg
{
	/**
	 * The current total score.
	 */
	static public var score:Int = 0;

	/**
	 * High score storage.
	 */
	static public var highScore:Int = 0;

	/**
	 * A reference to the active playstate. Lets you call Reg.PS globally to access the playstate.
	 */
	static public var PS:PlayState;

	/**
	 * Just a 2px by 2px transparent piece of "dust".
	 */
	static public function dustMote():BitmapData
	{
		if (dustMoteData == null)
			dustMoteData = new BitmapData(2, 2, true, 0x88FFFFFF);
		return dustMoteData;
	}

	static var dustMoteData:BitmapData;

	/**
	 * Draws the bounce panels. Useful for mobile devices with weird resolutions.
	 *
	 * @param	Height	The height of the panel to draw.
	 * @return	A BitmapData object representing the paddle.
	 */
	static public function createBounceImage(Height:Int):BitmapData
	{
		var bitmapData:BitmapData = new BitmapData(8, Height, false, GREY_MED);
		var rect:Rectangle;

		rect = new Rectangle(4, 0, 4, Height);
		bitmapData.fillRect(rect, GREY_LIGHT);
		rect = new Rectangle(0, 1, 1, Height - 2);
		bitmapData.fillRect(rect, GREY_DARK);
		rect.x = 3;
		bitmapData.fillRect(rect, GREY_DARK);
		rect = new Rectangle(1, 0, 2, 1);
		bitmapData.fillRect(rect, GREY_DARK);
		rect.y = Height - 1;
		bitmapData.fillRect(rect, GREY_DARK);
		rect = new Rectangle(4, 1, 1, Height - 2);
		bitmapData.fillRect(rect, WHITE);
		rect.x = 7;
		bitmapData.fillRect(rect, WHITE);
		rect = new Rectangle(5, 0, 2, 1);
		bitmapData.fillRect(rect, WHITE);
		rect.y = Height - 1;
		bitmapData.fillRect(rect, WHITE);

		return bitmapData;
	}

	// This is all stuff used for drawing the paddles.

	inline static var WHITE:Int = 0xffFFFFFF;
	inline static var GREY_LIGHT:Int = 0xffB0B0BF;
	inline static var GREY_MED:Int = 0xff646A7D;
	inline static var GREY_DARK:Int = 0xff35353D;
}
