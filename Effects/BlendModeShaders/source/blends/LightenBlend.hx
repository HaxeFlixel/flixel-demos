package blends;

import flixel.util.FlxColor;
import openfl.display.Shader;

class LightenBlend
{
	public var shader(default, null):LightenShader;
	
	@:isVar
	public var color(default, set):FlxColor;
	
	public function new(color:FlxColor):Void
	{
		shader = new LightenShader();
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