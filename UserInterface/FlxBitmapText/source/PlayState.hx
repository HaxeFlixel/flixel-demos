package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;
import flixel.util.FlxAxes;

class PlayState extends FlxState
{
	var tf:FlxBitmapText;
	var tf2:FlxBitmapText;

	override public function create():Void
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.WHITE;

		var letters:String = " !\"#$%&'()*+,-./"
			+ "0123456789:;<=>?"
			+ "@ABCDEFGHIJKLMNO"
			+ "PQRSTUVWXYZ[]^_"
			+ "abcdefghijklmno"
			+ "pqrstuvwxyz{|}~\\";
		var fontXNA = FlxBitmapFont.fromXNA("assets/fontData10pt.png", letters);

		var textBytes = Assets.getText("assets/NavTitle.fnt");
		var XMLData = Xml.parse(textBytes);
		var fontAngelCode = FlxBitmapFont.fromAngelCode("assets/NavTitle.png", XMLData);

		var monospaceLetters:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?!().,";
		var charSize = FlxPoint.get(48, 50);
		var fontMonospace = FlxBitmapFont.fromMonospace("assets/260.png", monospaceLetters, charSize);

		var fontDiacrit:FlxBitmapFont = FlxBitmapFont.fromAngelCode("assets/ucdm_font.png", "assets/ucdm_font.xml");

		tf = new FlxBitmapText(fontXNA);
		tf.text = "Mouse X/Y";
		tf.textColor = 0xff000000;
		tf.useTextColor = true;
		tf.autoSize = true;
		tf.multiLine = true;
		tf.alignment = FlxTextAlign.LEFT;
		tf.lineSpacing = 5;
		tf.padding = 5;
		tf.background = true;
		tf.backgroundColor = 0xff00ff00;
		add(tf);

		tf2 = new FlxBitmapText(fontAngelCode);
		tf2.y = 100;
		tf2.useTextColor = false;
		tf2.text = "Hello World!\nand this is\nmultiline!!!";
		tf2.borderStyle = FlxTextBorderStyle.SHADOW;
		tf2.borderColor = 0xffff0000;
		tf2.fieldWidth = 0;
		tf2.alignment = FlxTextAlign.CENTER;
		tf2.lineSpacing = 5;
		tf2.padding = 20;
		tf2.letterSpacing = 25;
		tf2.autoUpperCase = true;
		tf2.multiLine = true;
		tf2.wordWrap = false;
		tf2.screenCenter(FlxAxes.X);
		add(tf2);

		var tf3 = new FlxBitmapText(fontMonospace);
		tf3.y = 300;
		tf3.autoUpperCase = true;
		tf3.text = "Robocop rules!!!";
		tf3.screenCenter(FlxAxes.X);
		add(tf3);

		var tf4 = new FlxBitmapText(fontDiacrit);
		tf4.y = tf3.y + tf3.height + 50;
		tf4.alignment = FlxTextAlign.CENTER;
		tf4.text = "!\u20e4 You can e\u0332v\u0332e\u0332n\u0332 define and use\nUnicode Combining Diacritical Marks!";
		tf4.multiLine =  true;
		tf4.screenCenter(FlxAxes.X);
		add(tf4);
	}

	override public function update(elapsed:Float):Void
	{
		tf.text = "mouseX = " + Math.floor(FlxG.mouse.x) + "\n" + "mouseY = " + Math.floor(FlxG.mouse.y);
		super.update(elapsed);
	}
}
