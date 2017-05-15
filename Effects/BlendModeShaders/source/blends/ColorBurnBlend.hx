package blends;

import flixel.util.FlxColor;
import openfl.display.Shader;

class ColorBurnBlend
{
	public var shader(default, null):ColorBurnShader;
	
	@:isVar
	public var color(default, set):FlxColor;
	
	public function new(color:FlxColor):Void
	{
		shader = new ColorBurnShader();
		this.color = color;
	}
	
	private function set_color(color:FlxColor):FlxColor
	{
		shader.uBlendColor[0] = color.red;
		shader.uBlendColor[1] = color.green;
		shader.uBlendColor[2] = color.blue;
		shader.uBlendColor[3] = color.alphaFloat;

		return this.color = color;
	}
}

class ColorBurnShader extends Shader
{
	@fragment var code = '

	uniform vec4 uBlendColor;
	
	/**
	 * Helper method that normalized an RGB value (in the 0-255 range) to a value between 0-1.
	 */
	float normalize(float value)
	{
		return (value-0)/(255-0);
	}
	
	float applyColorBurnToChannel(float base, float blend)
	{
		return ((blend == 0.0) ? blend : max((1.0 - ((1.0 - base) / blend)), 0.0));
	}
	
	vec4 blendColorBurn(vec4 base, vec4 blend)
	{
		return vec4(
			applyColorBurnToChannel(base.r, blend.r),
			applyColorBurnToChannel(base.g, blend.g),
			applyColorBurnToChannel(base.b, blend.b),
			applyColorBurnToChannel(base.a, blend.a)
		);
	}
	
	vec4 blendColorBurn(vec4 base, vec4 blend, float opacity)
	{
		return (blendColorBurn(base, blend) * opacity + base * (1.0 - opacity));
	}
	
	void main()
	{
		vec4 base = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});
		
		vec4 blend = vec4(
			normalize(uBlendColor[0]),
			normalize(uBlendColor[1]),
			normalize(uBlendColor[2]),
			uBlendColor[3]
		);
		
		gl_FragColor = blendColorBurn(base, blend, uBlendColor[3]);
	}
	';
	
	public function new()
	{
		super();
	}
}