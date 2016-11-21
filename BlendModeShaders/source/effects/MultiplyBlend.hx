package effects;

import openfl.display.Shader;
 
/**
 * Note: BitmapFilters can only be used on 'OpenFL Next'
 */
class MultiplyBlend
{
	/**
	 * The instance of the actual shader class
	 */
	public var shader(default, null):MultiplyShader;
	
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
	 * A value between 0-1
	 */
	public var a(default, set):Float = 1.0;
	
	public function new(r:Float = 0., g:Float = 0., b:Float = 0., a:Float = 1.):Void
	{
		shader = new MultiplyShader();
		setRGBA(r, g, b, a);
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
	
	public function set_r(value:Float):Float
	{
		this.r = value;
		shader.uBlendColor[0] = this.r;
		
		return value;
	}
	
	public function set_g(value:Float):Float
	{
		this.g = value;
		shader.uBlendColor[1] = this.g;
		
		return value;
	}
	
	public function set_b(value:Float):Float
	{
		this.b = value;
		shader.uBlendColor[2] = this.b;
		
		return value;
	}
	
	public function set_a(value:Float):Float
	{
		this.a = value;
		shader.uBlendColor[3] = this.a;
		
		return value;
	}
}

class MultiplyShader extends Shader
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
	
	vec4 blendMultiply(vec4 base, vec4 blend)
	{
		return base * blend;
	}
	
	vec4 blendMultiply(vec4 base, vec4 blend, float opacity)
	{
		return (blendMultiply(base, blend) * opacity + base * (1.0 - opacity));
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
		
		gl_FragColor = blendMultiply(base, blend, blend.a);
	}
	';
	
	public function new()
	{
		super();
	}
}