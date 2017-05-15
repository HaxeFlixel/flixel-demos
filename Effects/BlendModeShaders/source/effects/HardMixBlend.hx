package effects;

import openfl.display.Shader;
 
/**
 * Note: BitmapFilters can only be used on 'OpenFL Next'
 */
class HardMixBlend
{
	/**
	 * The instance of the actual shader class
	 */
	public var shader(default, null):HardMixShader;
	
	/**
	 * A value between 0-255
	 */
	public var r(default, null):Float = 1.0;
	
	/**
	 * A value between 0-255
	 */
	public var g(default, null):Float = 1.0;
	
	/**
	 * A value between 0-255
	 */
	public var b(default, null):Float = 1.0;
	
	/**
	 * A value between 0-1
	 */
	public var a(default, set):Float = 1.0;
	
	public function new(r:Float = 255, g:Float = 255, b:Float = 255, a:Float = 1):Void
	{
		shader = new HardMixShader();
		setRGBA(r, g, b, a);
	}
	
	private function set_a(v:Float):Float
	{
		a = (v < 0.0 ? 0.0 :
			(v > 1.0 ? 1.0 : v));
		
		shader.uBlendColor[3] = a;
		return v;
	}
	
	public function setRGBA(r:Float, g:Float, b:Float, a:Float = 1):Void
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
		
		shader.uBlendColor[0] = r;
		shader.uBlendColor[1] = g;
		shader.uBlendColor[2] = b;
		shader.uBlendColor[3] = a;
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
		
		vec4 blend = texture2D(${Shader.uSampler }, ${Shader.vTexCoord });
		vec4 res = blendHardMix(base, blend);
		
		gl_FragColor = blendHardMix(blend, res, uBlendColor[3]);
	}
	';
	
	public function new()
	{
		super();
	}
}