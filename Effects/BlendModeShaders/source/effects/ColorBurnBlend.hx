package effects;

import openfl.display.Shader;
 
/**
 * Note: BitmapFilters can only be used on 'OpenFL Next'
 */
class ColorBurnBlend
{
	public var shader(default, null):ColorBurnShader;
	
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
		shader = new ColorBurnShader();
		setRGBA(r, g, b, a);
	}
	
	private function set_a(v:Float):Float
	{
		this.a = (v < 0.0 ? 0.0 : v);
		this.a = (v > 1.0 ? 1.0 : v);
		
		shader.uBlendColor[3] = this.a;
		return v;
	}
	
	public function setRGBA(r:Float, g:Float, b:Float, a:Float):Void
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
		
		shader.uBlendColor[0] = this.r;
		shader.uBlendColor[1] = this.g;
		shader.uBlendColor[2] = this.b;
		shader.uBlendColor[3] = this.a;
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
	
	float applyColorBurnToChannel( float base, float blend )
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
		vec4 base = texture2D(${Shader.uSampler }, ${Shader.vTexCoord });
		
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