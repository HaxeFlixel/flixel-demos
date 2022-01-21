package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Matrix;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
#if (flash || html5)
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.net.FileReference;
import openfl.net.FileFilter;
#elseif (sys && !hl)
import systools.Dialogs;
#end

/**
 * @author Lars Doucet
 */
class PlayState extends FlxState
{
	static inline var MIN_SCALE:Float = 0.1;
	static inline var MAX_SCALE:Float = 5;
	static inline var ZOOM_FACTOR:Int = 15;

	var _text:FlxText;
	var _button:FlxButton;
	var _img:FlxSprite;
	var _displayWidth:Float;
	var _displayHeight:Float;
	var _scaleText:FlxText;

	override public function create():Void
	{
		FlxG.cameras.bgColor = FlxColor.BLACK;

		_img = new FlxSprite(0, 0);
		_img.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		_img.antialiasing = true;
		add(_img);

		var gutter:Int = 4;

		var uiBG:FlxSprite = new FlxSprite(0, 0);
		uiBG.makeGraphic(FlxG.width, 30, FlxColor.BLACK);
		uiBG.alpha = 0.6;
		add(uiBG);

		var _button = new FlxButton(gutter, gutter, "Open Image", _onClick);
		add(_button);

		var bw:Float = _button.width + 15;
		_text = new FlxText(bw, gutter, Std.int(FlxG.width - bw - 5), "Click the button to load a PNG or JPG!");
		_text.setFormat(null, 16, FlxColor.WHITE, LEFT);
		add(_text);

		_scaleText = new FlxText(FlxG.width - 100, FlxG.height - 20, 100, 100);
		_scaleText.setFormat(null, 16, FlxColor.WHITE, RIGHT);
		add(_scaleText);

		_showImage(new GraphicLogo(0, 0));
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.mouse.wheel != 0)
		{
			_updateScale(_img.scale.x + FlxG.mouse.wheel / ZOOM_FACTOR);
		}

		// Little fading effect for the scale text
		if (_scaleText.alpha > 0)
		{
			_scaleText.alpha -= 0.03;
		}

		// Reset to a scale of x1
		if (FlxG.keys.anyPressed([R, SPACE, ONE]))
		{
			_updateScale(1);
		}

		// Scale shortcuts
		if (FlxG.keys.justPressed.TWO)
		{
			_updateScale(2);
		}
		else if (FlxG.keys.justPressed.THREE)
		{
			_updateScale(3);
		}
		else if (FlxG.keys.justPressed.FOUR)
		{
			_updateScale(4);
		}
		else if (FlxG.keys.justPressed.FIVE)
		{
			_updateScale(5);
		}

		super.update(elapsed);
	}

	function _updateScale(NewScale:Float):Void
	{
		if (NewScale > MAX_SCALE)
		{
			NewScale = MAX_SCALE;
		}
		else if (NewScale < MIN_SCALE)
		{
			NewScale = MIN_SCALE;
		}

		_img.scale.set(NewScale, NewScale);
		_scaleText.text = "x" + FlxMath.roundDecimal(_img.scale.x, 2);
		_scaleText.alpha = 1;
		_centerImage();
	}

	function _centerImage():Void
	{
		_img.offset.x = _displayWidth * _img.scale.x / 2;
		_img.offset.y = _displayHeight * _img.scale.y / 2;
		_img.centerOffsets();
	}

	function _onClick():Void
	{
		_showFileDialog();
	}

	function _showFileDialog():Void
	{
		#if (flash || html5)
		var fr:FileReference = new FileReference();
		fr.addEventListener(Event.SELECT, _onSelect, false, 0, true);
		fr.addEventListener(Event.CANCEL, _onCancel, false, 0, true);
		var filters:Array<FileFilter> = new Array<FileFilter>();
		filters.push(new FileFilter("PNG Files", "*.png"));
		filters.push(new FileFilter("JPEG Files", "*.jpg;*.jpeg"));
		fr.browse();
		#elseif (sys && !hl)
		var filters:FILEFILTERS = {
			count: 2,
			descriptions: ["PNG files", "JPEG files"],
			extensions: ["*.png", "*.jpg;*.jpeg"]
		};
		var result:Array<String> = Dialogs.openFile("Select a file please!", "Please select one or more files, so we can see if this method works", filters);

		_onSelect(result);
		#end
	}

	#if (flash || html5)
	function _onSelect(E:Event):Void
	{
		var fr:FileReference = cast(E.target, FileReference);
		_text.text = fr.name;
		fr.addEventListener(Event.COMPLETE, _onLoad, false, 0, true);
		fr.load();
	}

	function _onLoad(E:Event):Void
	{
		var fr:FileReference = cast E.target;
		fr.removeEventListener(Event.COMPLETE, _onLoad);

		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onImgLoad);
		loader.loadBytes(fr.data);
	}

	function _onImgLoad(E:Event):Void
	{
		var loaderInfo:LoaderInfo = cast E.target;
		loaderInfo.removeEventListener(Event.COMPLETE, _onImgLoad);
		var bmp:Bitmap = cast(loaderInfo.content, Bitmap);
		_showImage(bmp.bitmapData);
	}
	#elseif (sys && !hl)
	function _onSelect(arr:Array<String>):Void
	{
		if (arr != null && arr.length > 0)
		{
			_text.text = arr[0];
			var img = #if lime_legacy BitmapData.load(arr[0]); #else BitmapData.fromFile(arr[0]); #end

			if (img != null)
			{
				_showImage(img);
			}
		}
		else
		{
			_onCancel(null);
		}
	}
	#end

	function _onCancel(_):Void
	{
		_text.text = "Cancelled!";
	}

	function _showImage(Data:BitmapData):Void
	{
		_img.scale.set(1, 1);

		var imgWidth:Float = FlxG.width / Data.width;
		var imgHeight:Float = FlxG.height / Data.height;

		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
		{
			scale = 1;
		}

		_displayWidth = Data.width * scale;
		_displayHeight = Data.height * scale;
		_img.makeGraphic(Std.int(_displayWidth), Std.int(_displayHeight), FlxColor.BLACK);

		var data2:BitmapData = _img.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.BLACK);
		data2.draw(Data, matrix, null, null, null, true);
		_img.pixels = data2;

		// Center the image
		_img.x = (FlxG.width - _displayWidth) / 2;
		_img.y = (FlxG.height - _displayHeight) / 2;
	}
}
