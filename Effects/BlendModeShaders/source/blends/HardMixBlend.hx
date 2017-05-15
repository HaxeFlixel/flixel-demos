package blends;

import flixel.util.FlxColor;
import openfl.display.Shader;

class HardMixBlend
{
	public var shader(default, null):HardMixShader;
	
	@:isVar
	public var color(default, set):FlxColor;
	
	public function new(color:FlxColor):Void
	{
		shader = new HardMixShader();
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

class HardMixShader extends Shader
{
	@fragment var code = '

	uniform vec4 uBlendColor;
	
	float normalize(float value)
	{
		return (value-0)/(255-0);
	}
	
	float blendColorDodge(float base, float blend) {
		return (blend == 1.0)
			? blend
			: min(base / (1.0 - blend), 1.0);
	}
	
	float blendColorBurn(float base, float blend) {
		return (blend == 0.0)
			? blend
			: max((1.0 - ((1.0 - base) / blend)), 0.0);
	}

	float blendVividLight(float base, float blend) {
		return (blend < 0.5)
			? blendColorBurn(base, (2.0 * blend))
			: blendColorDodge(base, (2.0 * (blend - 0.5)));
	}

	float blendHardMix(float base, float blend) {
		return (blendVividLight(base, blend) < 0.5)
			? 0.0
			: 1.0;
	}

	vec4 blendHardMix(vec4 base, vec4 blend) {
		return vec4(
			blendHardMix(base.r, blend.r),
			blendHardMix(base.g, blend.g),
			blendHardMix(base.b, blend.b),
			blendHardMix(base.a, blend.a)
		);
	}

	vec4 blendHardMix(vec4 base, vec4 blend, float opacity) {
		return (blendHardMix(base, blend) * opacity + base * (1.0 - opacity));
	}
	
	void main()
	{
		vec4 base = vec4(
			normalize(uBlendColor[0]),
			normalize(uBlendColor[1]),
			normalize(uBlendColor[2]),
			uBlendColor[3]
		);
		
		vec4 blend = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});
		vec4 res = blendHardMix(base, blend);
		
		gl_FragColor = blendHardMix(blend, res, uBlendColor[3]);
	}
	';
	
	public function new()
	{
		super();
	}
}