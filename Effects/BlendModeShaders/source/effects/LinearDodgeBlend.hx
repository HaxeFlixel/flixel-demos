package effects;

import openfl.display.Shader;
 
class LinearDodgeBlend
{
	/**
	 * The instance of the actual shader class
	 */
	public var shader(default, null):LinearDodgeShader;
	
	/**
	 * A value between 0-255
	 */
	public var r(default, set):Float = 1.0;
	
	/**
	 * A value between 0-255
	 */
	public var g(default, set):Float = 1.0;
	
	/**
	 * A value between 0-255
	 */
	public var b(default, set):Float = 1.0;
	
	/**
	 * A color in the RRGGBB format
	 */
	public var blendColor(default, set):Int = 0xFFFFFF;
	
	/**
	 * A value between 0-1
	 */
	public var a(default, set):Float = 1.0;
	
	public function new(Color:Int = 0xFFFFFF, a:Float = 1):Void
	{
		shader = new LinearDodgeShader();
		blendColor = Color;
		this.a = a;
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
	
	private function set_r(value:Float):Float
	{
		value = (value > 255 ? 255 : value);
		value = (value < 0.0 ? 0.0 : value);
		
		r = value;
		shader.uBlendColor[0] = r;
		
		return value;
	}
	
	private function set_g(value:Float):Float
	{
		value = (value > 255 ? 255 : value);
		value = (value < 0.0 ? 0.0 : value);
		
		g = value;
		shader.uBlendColor[1] = g;
		
		return value;
	}
	
	private function set_b(value:Float):Float
	{
		value = (value > 255 ? 255 : value);
		value = (value < 0.0 ? 0.0 : value);
		
		b = value;
		shader.uBlendColor[2] = b;
		
		return value;
	}
	
	private function set_a(value:Float):Float
	{
		value = (value > 1.0 ? 1.0 : value);
		value = (value < 0.0 ? 0.0 : value);
		
		a = value;
		shader.uBlendColor[3] = a;
		
		return value;
	}
	
	/**
	 * @param	value The color as a hex-value, like 0xRRGGBB
	 */
	private function set_blendColor(value:Int):Int
	{
		blendColor = value;
		
		r = (value & 0xFF0000) >> 16;
		g = (value & 0xFF00) >> 8;
		b = (value & 0xFF);
		
		return value;
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
		vec4 base = texture2D(${Shader.uSampler }, ${Shader.vTexCoord });
		
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