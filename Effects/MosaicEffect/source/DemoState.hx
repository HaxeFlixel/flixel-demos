package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class DemoState extends FlxState
{
	private var isActive:Bool = false;
	private var effect:MosaicEffect;
	
	override public function create():Void
	{	
		add(new FlxSprite(0, 0, "assets/images/backdrop.png"));
		
		// The effect is not a FlxObject, so no need to call the state's add()-method.
		effect = new MosaicEffect();
		
		var infoText:FlxText = new FlxText(10, 10, 100, "Press SPACE key to run the effect.");
		infoText.color = FlxColor.BLACK;
		add(infoText);
	}

	override public function update(elapsed:Float):Void
	{
		if (!isActive && FlxG.keys.justPressed.SPACE) 
		{
			isActive = true;
			FlxTween.num(MosaicEffect.DEFAULT_STRENGTH, 15, .1, { type:FlxTween.ONESHOT}, updateAmount).then(
				FlxTween.num(15, MosaicEffect.DEFAULT_STRENGTH, .1, { type:FlxTween.ONESHOT, onComplete:resetEffect }, updateAmount)
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
		effect.setEffectAmount(v, v);
	}
}
