import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxBitmapFont;
import flixel.text.FlxBitmapText;

/**
 * Note: This is not in the tutorial, the tutorial uses FlxText everywhere, which is easier to teach.
 * Feel free to use this in your games
 * Font created by Rick Hoppmann: https://tinyworlds.itch.io/free-pixel-font-thaleah
 */
@:forward
abstract LargeText(FlxBitmapText) to FlxBitmapText
{
	static function getDefaultFont()
	{
		final graphic = FlxG.bitmap.add(AssetPaths.font__png);
		final font = FlxBitmapFont.findFont(graphic.imageFrame.frame);
		if (font != null)
			return font;
		
		final chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!";
		final widths = ['I'.code=>3, '!'.code=>3, 'T'.code=>7];
		final defaultWidth = 8;
		final defaultHeight = 8;
		final font = FlxBitmapFont.fromMonospace(graphic, "", new FlxPoint(defaultWidth, defaultHeight));
		
		var x:Int = 0;
		for (i in 0...chars.length)
		{
			final charCode = chars.charCodeAt(i);
			final width = if (widths.exists(charCode)) widths[charCode] else defaultWidth;
			final frame = FlxRect.get(x, 0, width, defaultHeight);
			@:privateAccess
			font.addCharFrame(charCode, frame, FlxPoint.weak(), width);
			x += width;
		}
		return font;
	}
	
	public function new (x = 0.0, y = 0.0, text = "", scale = 4)
	{
		this = new FlxBitmapText(x, y, text, getDefaultFont());
		this.text = text;
		this.autoUpperCase = true;
		setScale(scale);
	}
	
	function setScale(scale:Int)
	{
		this.scale.set(scale, scale);
		this.updateHitbox();
	}
	
	inline public function setBorderStyle(style, color = 0x0, size = 1, quality = 1)
	{
		this.setBorderStyle(style, color, size, quality);
		this.updateHitbox();
	}
}