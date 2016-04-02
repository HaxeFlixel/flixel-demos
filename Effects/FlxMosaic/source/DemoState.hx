package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class DemoState extends FlxState
{
	private var isActive:Bool = false;
	private var mosaic:FlxMosaic;
	private var infoText:FlxText;
	
	override public function create():Void
	{
		mosaic = new FlxMosaic(0, 0, "assets/images/backdrop.png");
		add(mosaic);
		
		infoText = new FlxText(10, 10, 100, "Press SPACE key to run the effect.");
		infoText.color = FlxColor.BLACK;
		add(infoText);
	}

	override public function update(elapsed:Float):Void
	{
		if (!isActive && FlxG.keys.justPressed.SPACE) 
		{
			isActive = true;
			FlxTween.num(0, 10, .3, { type:FlxTween.ONESHOT}, updateAmount).then(
			FlxTween.num(10, 0, .3, { type:FlxTween.ONESHOT, onComplete:resetEffect }, updateAmount)
			);
		}
		
		super.update(elapsed);
	}
	
	private function resetEffect(t:FlxTween):Void
	{
		isActive = false;
	}
	
	private function updateAmount(v:Float):Void
	{
		mosaic.setAmount(v);
	}
}
