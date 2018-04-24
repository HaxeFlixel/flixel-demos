package;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxUIAssets;
import flixel.addons.ui.FlxUICheckBox;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;

#if shaders_supported
#if (openfl >= "8.0.0")
import openfl8.*;
#else
import openfl3.*;
#end
import openfl.filters.ShaderFilter;
import openfl.Lib;
#end

class PlayState extends FlxState
{
	var filters:Array<BitmapFilter> = [];
	var uiCamera:flixel.FlxCamera;
	var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}>;
	
	override public function create():Void
	{
		filterMap = [
			#if shaders_supported
			"Scanline" => {
				filter: new ShaderFilter(new Scanline()),
			},
			"Hq2x" => {
				filter: new ShaderFilter(new Hq2x()),
			},
			"Tiltshift" => {
				filter: new ShaderFilter(new Tiltshift()),
			},
			"Grain" => {
				var shader = new Grain();
				{
					filter: new ShaderFilter(shader),
					onUpdate: function() {
						#if (openfl >= "8.0.0")
						shader.uTime.value = [Lib.getTimer() / 1000];
						#else
						shader.uTime = Lib.getTimer() / 1000;
						#end
					}
				}
			},
			#end
			"Blur" => {
				filter:new BlurFilter(),
			},
			"Grayscale" => {
				var matrix:Array<Float> = [
					0.5, 0.5, 0.5, 0, 0,
					0.5, 0.5, 0.5, 0, 0,
					0.5, 0.5, 0.5, 0, 0,
					0,     0,   0, 1, 0,
				];
				
				{ filter: new ColorMatrixFilter(matrix) }
			},
			"Invert" => {
				var matrix:Array<Float> = [
					-1, 0, 0, 0, 255,
					0, -1, 0, 0, 255,
					0, 0, -1, 0, 255,
					0, 0,  0, 1, 0,
				];
				
				{ filter: new ColorMatrixFilter(matrix) }
			},
			"Deuteranopia" => {
				var matrix:Array<Float> = [
					0.43, 0.72, -.15, 0, 0,
					0.34, 0.57, 0.09, 0, 0,
					-.02, 0.03, 1   , 0, 0,
					0,    0,    0,    1, 0,
				];
				
				{ filter: new ColorMatrixFilter(matrix) }
			},
			"Protanopia" => {
				var matrix:Array<Float> = [
					0.20, 0.99, -.19, 0, 0,
					0.16, 0.79, 0.04, 0, 0,
					0.01, -.01, 1   , 0, 0,
					0,    0,    0,    1, 0,
				];
				
				{ filter: new ColorMatrixFilter(matrix) }
			},
			"Tritanopia" => {
				var matrix:Array<Float> = [
					0.97, 0.11, -.08, 0, 0,
					0.02, 0.82, 0.16, 0, 0,
					0.06, 0.88, 0.18, 0, 0,
					0,    0,    0,    1, 0,
				];
				
				{ filter: new ColorMatrixFilter(matrix) }
			}
		];
		
		uiCamera = new FlxCamera(0, 0, 130, 300);
		FlxG.cameras.add(uiCamera);
		
		var backdrop = new FlxBackdrop("assets/logo.png");
		backdrop.cameras = [FlxG.camera];
		backdrop.velocity.set(150, 150);
		add(backdrop);
		
		FlxG.camera.setFilters(filters);
		FlxG.game.setFilters(filters);
		
		FlxG.game.filtersEnabled = false;
		
		var x = 10;
		var y = 10;
		
		for (key in filterMap.keys())
		{
			createCheckbox(x, y, key, filterMap.get(key).filter);
			y += 25;
		}
		
		y += 10;
		var checkbox = new FlxUICheckBox(x, y, FlxUIAssets.IMG_CHECK_BOX,  FlxUIAssets.IMG_CHECK_MARK, "Apply to full game");
		checkbox.cameras = [uiCamera];
		add(checkbox);
		
		checkbox.callback = function()
		{
			
			FlxG.camera.filtersEnabled = !checkbox.checked;
			FlxG.game.filtersEnabled = checkbox.checked;
		}
	}
	
	function createCheckbox(x:Float, y:Float, name:String, filter:BitmapFilter)
	{
		var checkbox = new FlxUICheckBox(x, y, FlxUIAssets.IMG_CHECK_BOX,  FlxUIAssets.IMG_CHECK_MARK, name);
		checkbox.cameras = [uiCamera];
		add(checkbox);
		
		checkbox.callback = function()
		{
			if (checkbox.checked)
				filters.push(filter);
			else
				filters.remove(filter);
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		for (filter in filterMap)
		{
			if (filter.onUpdate != null)
				filter.onUpdate();
		}
	}
}
