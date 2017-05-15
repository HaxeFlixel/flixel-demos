package blends;

import openfl.display.Shader;
 
/**
 * Note: BitmapFilters can only be used on 'OpenFL Next'
 */
class LightenBlend
{
	/**
	 * The instance of the actual shader class
	 */
	public var shader(default, null):LightenShader;
	
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
	public var a(default, null):Float = 1.0;
	
	public function new(r:Float = 255, g:Float = 255, b:Float = 255, a:Float = 1):Void
	{
		shader = new LightenShader();
		setRGBA(r, g, b, a);
	}
	
	public function setAlpha(a:Float):Void
	{
		this.a = a;
		shader.uBlendColor[3] = a;
	}
	
	public function setRGBA(r:Float, g:Float, b:Float, a:Float):Void
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

class LightenShader extends Shader
{
	@fragment var code = '

	uniform vec4 uBlendColor;
	
	float normalize(float value)
	{
		return (value-0)/(255-0);
	}
	
	vec4 blendLighten(vec4 base, vec4 blend)
	{
		return max(blend, base);
	}
	
	vec4 blendLighten(vec4 base, vec4 blend, float opacity)
	{
		return (blendLighten(base, blend) * opacity + base * (1.0 - opacity));
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
		
		gl_FragColor = blendLighten(base, blend, blend.a);
	}
	';
	
	public function new()
	{
		super();
	}
}