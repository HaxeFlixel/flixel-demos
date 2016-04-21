package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flash.filters.BitmapFilter;
import openfl.filters.ShaderFilter;

class DemoState extends FlxState
{
	private var effect:MosaicEffect;
	private var effectTween:FlxTween;
	private var bg1:FlxSprite;
	
	override public function create():Void
	{	
		add(new FlxSprite(0, 0, "assets/images/backdrop.png"));
		
		// The effect is not a FlxObject, so no need to call the state's add()-method.
		effect = new MosaicEffect();
		
		var filter:ShaderFilter = new ShaderFilter(effect.getShader());
		var filters:Array<BitmapFilter> = [filter];
		
		FlxG.camera.setFilters(filters);
		FlxG.camera.filtersEnabled = true;
		
		var infoText:FlxText = new FlxText(10, 10, 100, "Press SPACE to pause the effect.");
		infoText.color = FlxColor.BLACK;
		add(infoText);
		
		effectTween = FlxTween.num(MosaicEffect.DEFAULT_VALUE, 15, 2, {type:FlxTween.PINGPONG}, updateAmount);
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.SPACE) 
		{
			effectTween.active = !effectTween.active;
		}
		
		super.update(elapsed);
	}
	
	private function updateAmount(v:Float):Void
	{
		effect.setEffectStrengthXY(v, v);
	}
}
