package openfl8.effects;

import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxShader;

class ColorSwapEffect
{
	/**
	 * The instance of the actual shader class
	 */
	public var shader(default, null):ColorSwapShader;
	
	/**
	 * The color to replace with another
	 */
	public var colorToReplace(default, set):FlxColor;
	
	/**
	 * The desired new color
	 */
	public var newColor(default, set):FlxColor;
	
	/**
	 * Activates/Deactivates the shader
	 */
	public var isShaderActive(default, set):Bool;
	
	public function new():Void
	{
		shader = new ColorSwapShader();
		shader.shaderIsActive.value = [true];
		shader.colorOld.value = [];
		shader.colorNew.value = [];
	}
	
	private function set_isShaderActive(value:Bool):Bool
	{
		isShaderActive = value;
		shader.shaderIsActive.value[0] = value;
		return value;
	}
	
	private function set_colorToReplace(color:FlxColor):FlxColor
	{
		colorToReplace = color;

		shader.colorOld.value[0] = color.red;
		shader.colorOld.value[1] = color.green;
		shader.colorOld.value[2] = color.blue;
		
		return color;
	}
	
	private function set_newColor(color:FlxColor):FlxColor
	{
		newColor = color;
		
		shader.colorNew.value[0] = color.red;
		shader.colorNew.value[1] = color.green;
		shader.colorNew.value[2] = color.blue;
		
		return color;
	}
}

class ColorSwapShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform vec3 colorOld;
		uniform vec3 colorNew;
		uniform bool shaderIsActive;

		/**
		 * Helper method that normalizes an RGB value (in the 0-255 range) to a value between 0-1.
		 */
		float normalize(float value)
		{
			return (value - 0.0) / (255.0 - 0.0);
		}

		void main()
		{
			vec4 pixel = texture2D(bitmap, openfl_TexCoordv);

			if (!shaderIsActive)
			{
				gl_FragColor = pixel;
				return;
			}

			/**
			 * Used to create some leeway when comparing the colors.
			 * Smaller values = smaller leeway.
			 */
			vec3 eps = vec3(0.009, 0.009, 0.009);

			vec3 colorOldNormalized = vec3(
				normalize(colorOld[0]),
				normalize(colorOld[1]),
				normalize(colorOld[2])
			);

			vec3 colorNewNormalized = vec3(
				normalize(colorNew[0]),
				normalize(colorNew[1]),
				normalize(colorNew[2])
			);

			if (all(greaterThanEqual(pixel, vec4(colorOldNormalized - eps, 1.0)) ) &&
				all(lessThanEqual(pixel, vec4(colorOldNormalized + eps, 1.0)) )
			)
			{
				pixel = vec4(colorNewNormalized, 1.0);
			}

			gl_FragColor = pixel;
		}'
	)
	
	public function new()
	{
		super();
	}
}