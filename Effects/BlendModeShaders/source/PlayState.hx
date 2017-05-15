package;

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
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.filters.ShaderFilter;

class PlayState extends FlxState
{
	private static inline var LOGO_COLOR_RED:Int = 0xff3366;
	private static inline var LOGO_COLOR_BLUE:Int = 0x3333ff;
	private static inline var LOGO_COLOR_YELLOW:Int = 0xffcc33;
	private static inline var LOGO_COLOR_LIGHT_BLUE:Int = 0x00ccff;
	private static inline var LOGO_COLOR_GREEN:Int = 0x00cc33;
	// effects (also shader based)
	#if !flash
	private var shutter:ShutterEffect;
	private var wiggleEffect:WiggleEffect;
	private var colorSwap:ColorSwap;
	#end
	private var shutterCanvas:FlxSprite;
	private var logoColors:Array<Int>;
	private var infoText:FlxText;
	
	override public function create():Void
	{
		FlxG.debugger.toggleKeys = [FlxKey.DELETE];
		
		var backdrop = new FlxSprite(0, 0, AssetPaths.backdrop__png);
		add(backdrop);
		
		#if flash
		return;
		#else
		wiggleEffect = new WiggleEffect();
		wiggleEffect.effectType = WiggleEffect.EFFECT_TYPE_DREAMY;
		wiggleEffect.waveAmplitude = .2;
		wiggleEffect.waveFrequency = 7;
		wiggleEffect.waveSpeed = 1;
		
		// set this to false to apply effect to the whole screen
		var doApplyShaderToBackdrop = true;
		
		if (doApplyShaderToBackdrop) 
		{
			backdrop.shader = wiggleEffect.shader;
		}
		else
		{
			FlxG.camera.setFilters([
				new ShaderFilter(wiggleEffect.shader),
			]);
		}
		
		var logo = new FlxSprite(0, 0, AssetPaths.logo__png);
		logo.screenCenter(FlxAxes.XY);
		add(logo);
		
		setupShutterEffect();
		
		logoColors = [LOGO_COLOR_RED, LOGO_COLOR_BLUE, LOGO_COLOR_LIGHT_BLUE, LOGO_COLOR_GREEN, LOGO_COLOR_YELLOW];
		colorSwap = new ColorSwap(LOGO_COLOR_RED, FlxG.random.int(0, logoColors.length-1));
		logo.shader = colorSwap.shader;
		
		
		new FlxTimer().start(.02, function (timer)
		{
			colorSwap.colorToReplace = logoColors[FlxG.random.int(0, logoColors.length - 1)];
			colorSwap.newColor = logoColors[FlxG.random.int(0, logoColors.length - 1)];
		}, 0);
		
		FlxTween.num(0.0, 450, 1.5, {ease:FlxEase.quintOut, startDelay:.2}, function (v:Float)
		{
			shutter.radius = v;
		});
		
		infoText = new FlxText(10, 10, 120, "Press DEL to display render statistics.\n\nPress R to restart demo.", 11);
		infoText.color = FlxColor.BLACK;
		add(infoText);
		
		var r = FlxG.random.float(0., 255.);
		var g = FlxG.random.float(0., 255.);
		var b = FlxG.random.float(0., 255.);
		
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
		#end
	}
	
	#if !flash
	private function setupShutterEffect():Void
	{
		shutter = new ShutterEffect();
		shutterCanvas = new FlxSprite(0, 0);
		shutterCanvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		shutterCanvas.shader = shutter.shader;
		add(shutterCanvas);
	}

	override public function update(elapsed:Float):Void
	{
		wiggleEffect.update(elapsed);
		
		if (FlxG.keys.justPressed.R) 
		{
			FlxG.resetState();
		}
		
		super.update(elapsed);
	}
	#end
}
