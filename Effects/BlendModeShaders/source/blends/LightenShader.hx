package blends;

import openfl.display.Shader;

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