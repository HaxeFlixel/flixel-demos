package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

#if !flash
import blends.ColorBurnBlend;
import blends.HardMixBlend;
import blends.LightenBlend;
import blends.LinearDodgeBlend;
import blends.MultiplyBlend;
import blends.VividLightBlend;
import effects.WiggleEffect;
import effects.ColorSwapEffect;
import effects.ShutterEffect;
import openfl.filters.ShaderFilter;
import openfl.display.Shader;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.ui.FlxUIDropDownMenu;
#else
import flixel.text.FlxText;
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
	#if !flash
	var wiggleEffect:WiggleEffect;
	
	var effects:Map<String, Float->Float->Float->Float->{public var shader(default, null):Shader;}> = [
		"ColorBurnBlend" => ColorBurnBlend.new,
		"HardMixBlend" => HardMixBlend.new,
		"LightenBlend" => LightenBlend.new,
		// LinearDodgeBlend.new,
		"MultiplyBlend" => MultiplyBlend.new,
		"VividLightBlend" => VividLightBlend.new
	];
	#end	

	override public function create():Void
	{
		super.create();

		var backdrop = new FlxSprite(0, 0, AssetPaths.backdrop__png);
		add(backdrop);
		
		#if flash
		var infoText = new FlxText(0, 0, 0, "Not supported on Flash!", 16);
		infoText.color = FlxColor.BLACK;
		infoText.screenCenter();
		add(infoText);
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
		
		var logoColors = [RED, BLUE, YELLOW, CYAN, GREEN];
		var colorSwap = new ColorSwapEffect(RED, FlxG.random.int(0, logoColors.length - 1));
		logo.shader = colorSwap.shader;
		
		new FlxTimer().start(0.2, function(timer)
		{
			colorSwap.colorToReplace = logoColors[FlxG.random.int(0, logoColors.length - 1)];
			colorSwap.newColor = logoColors[FlxG.random.int(0, logoColors.length - 1)];
		}, 0);

		var labels = FlxUIDropDownMenu.makeStrIdLabelArray([for (name in effects.keys()) name]);
		add(new FlxUIDropDownMenu(2, 2, labels, selectBlendEffect, new FlxUIDropDownHeader(150)));

		selectBlendEffect("ColorBurnBlend");
		createShutterEffect();
		#end
	}

	#if !flash
	private function selectBlendEffect(blendEffect:String)
	{
		var r = FlxG.random.float(0, 255);
		var g = FlxG.random.float(0, 255);
		var b = FlxG.random.float(0, 255);
		
		var effect = effects[blendEffect](r, g, b, 0.5);
		FlxG.camera.setFilters([new ShaderFilter(effect.shader)]);
	}
	
	private function createShutterEffect():Void
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
		super.update(elapsed);
	}
	#end
}
