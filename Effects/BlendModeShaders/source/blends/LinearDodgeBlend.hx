package blends;

import flixel.util.FlxColor;
import openfl.display.Shader;

class LinearDodgeBlend
{
	public var shader(default, null):LinearDodgeShader;
	
	@:isVar
	public var color(default, set):FlxColor;
	
	public function new(color:FlxColor):Void
	{
		shader = new LinearDodgeShader();
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

class LinearDodgeShader extends Shader
{
	@fragment var code = '

	uniform vec4 uBlendColor;
	
	/**
	 * RBG values goes from 0-255, but the vec4 getting passed to gl_FragColor needs it to be in the range of 0-1
	 */
	float normalize(float value)
	{
		return (value-0)/(255-0);
	}
	
	// Note : Same implementation as BlendAddf
	float blendLinearDodge(float base, float blend) {
		return min(base + blend, 1.0);
	}
	
	vec4 blendLinearDodge(vec4 base, vec4 blend) {
		return vec4(
			blendLinearDodge(base.r, blend.r),
			blendLinearDodge(base.g, blend.g),
			blendLinearDodge(base.b, blend.b),
			blendLinearDodge(base.a, blend.a)
		);
	}

	vec4 blendLinearDodge(vec4 base, vec4 blend, float opacity) {
		return (blendLinearDodge(base, blend) * opacity + base * (1.0 - opacity));
	}
	
	void main()
	{
		vec4 base = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});
		
		vec4 blendColor = vec4(
			normalize(uBlendColor[0]),
			normalize(uBlendColor[1]),
			normalize(uBlendColor[2]),
			uBlendColor[3]
		);
		
		gl_FragColor = blendLinearDodge(base, blendColor, uBlendColor[3]);
	}
	';
	
	public function new()
	{
		super();
	}
}