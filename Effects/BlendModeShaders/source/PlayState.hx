package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

#if !flash
import effects.ColorBurnBlend;
import effects.ColorSwap;
import effects.HardMixBlend;
import effects.LightenBlend;
import effects.LinearDodgeBlend;
import effects.MultiplyBlend;
import effects.ShutterEffect;
import effects.VividLightBlend;
import effects.WiggleEffect;
import openfl.filters.ShaderFilter;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#end

@:enum abstract LogoColor(FlxColor) to FlxColor
{
	var RED = 0xff3366;
	var BLUE = 0x3333ff;
	var YELLOW = 0xffcc33;
	var CYAN = 0x00ccff;
	var GREEN = 0x00cc33;
}

class PlayState extends FlxState
{
	// effects (also shader based)
	#if !flash
	private var wiggleEffect:WiggleEffect;
	#end
	
	override public function create():Void
	{
		var backdrop = new FlxSprite(0, 0, AssetPaths.backdrop__png);
		add(backdrop);
		
		var info:String;

		#if flash
		info = "Not supported on Flash!";
		#else
		wiggleEffect = new WiggleEffect();
		wiggleEffect.effectType = WiggleEffect.EFFECT_TYPE_DREAMY;
		wiggleEffect.waveAmplitude = 0.2;
		wiggleEffect.waveFrequency = 7;
		wiggleEffect.waveSpeed = 1;
		backdrop.shader = wiggleEffect.shader;
		
		var logo = new FlxSprite(0, 0, AssetPaths.logo__png);
		logo.screenCenter();
		add(logo);
		
		setupShutterEffect();
		
		var logoColors = [RED, BLUE, YELLOW, CYAN, GREEN];
		var colorSwap = new ColorSwap(RED, FlxG.random.int(0, logoColors.length - 1));
		logo.shader = colorSwap.shader;
		
		new FlxTimer().start(0.2, function(timer)
		{
			colorSwap.colorToReplace = logoColors[FlxG.random.int(0, logoColors.length - 1)];
			colorSwap.newColor = logoColors[FlxG.random.int(0, logoColors.length - 1)];
		}, 0);
		
		var r = FlxG.random.float(0, 255);
		var g = FlxG.random.float(0, 255);
		var b = FlxG.random.float(0, 255);
		
		switch (FlxG.random.int(0, 5))
		{
			case 0:
				var effect = new ColorBurnBlend(r, g, b, .5);
				FlxG.camera.setFilters([ new ShaderFilter(effect.shader) ]);
			case 1:
				var effect = new HardMixBlend(r, g, b, .5);
				FlxG.camera.setFilters([ new ShaderFilter(effect.shader) ]);
			case 2:
				var effect = new LightenBlend(r, g, b, .5);
				FlxG.camera.setFilters([ new ShaderFilter(effect.shader) ]);
			case 3:
				var effect = new LinearDodgeBlend(0xffffff, .5);
				FlxG.camera.setFilters([ new ShaderFilter(effect.shader) ]);
			case 4:
				var effect = new MultiplyBlend(r, g, b, .5);
				FlxG.camera.setFilters([ new ShaderFilter(effect.shader) ]);
			case 5:
				var effect = new VividLightBlend(r, g, b, .5);
				FlxG.camera.setFilters([ new ShaderFilter(effect.shader) ]);
		}
		
		super.create();

		info = "Press R to restart demo.";
		#end

		var infoText = new FlxText(10, 10, 120, info, 11);
		infoText.color = FlxColor.BLACK;
		add(infoText);
	}
	
	#if !flash
	private function setupShutterEffect():Void
	{
		var shutter = new ShutterEffect();
		var shutterCanvas = new FlxSprite();
		shutterCanvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		shutterCanvas.shader = shutter.shader;
		add(shutterCanvas);

		FlxTween.num(0.0, 450, 1.5, { ease: FlxEase.quintOut, startDelay: 0.2 }, function(v:Float)
		{
			shutter.radius = v;
		});
	}

	override public function update(elapsed:Float):Void
	{
		wiggleEffect.update(elapsed);
		
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
		
		super.update(elapsed);
	}
	#end
}
