package blends;

import openfl.display.Shader;

class VividLightShader extends Shader
{
	@fragment var code = '

	uniform vec4 uBlendColor;
	
	/**
	 * Helper method that normalized an RGB value (in the 0-255 range) to a value between 0-1.
	 */
	float normalize(float value)
	{
		return (value-0) / (255. - 0.);
	}
	
	float colorDodge(float base, float blend)
	{
		return (blend == 1.0) ? blend : min(base / (1.0 - blend), 1.0);
	}
	
	float colorBurn(float base, float blend)
	{
		return (blend == 0.0) ? blend : max((1.0 - ((1.0 - base) / blend)), 0.0);
	}
	
	float vividLight( float base, float blend )
	{
		return ((blend < 0.5) ? colorBurn(base, (2.0 * blend)) : colorDodge(base, (2.0 * (blend - 0.5))));
	}
	
	vec4 vividLight(vec4 base, vec4 blend)
	{
		return vec4(
			vividLight(base.r, blend.r),
			vividLight(base.g, blend.g),
			vividLight(base.b, blend.b),
			vividLight(base.a, blend.a)
		);
	}
	
	vec4 vividLight(vec4 base, vec4 blend, float opacity)
	{
		return (vividLight(base, blend) * opacity + base * (1.0 - opacity));
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
		
		gl_FragColor = vividLight(base, blendColor, uBlendColor[3]);
	}
	';
	
	public function new()
	{
		super();
	}
}