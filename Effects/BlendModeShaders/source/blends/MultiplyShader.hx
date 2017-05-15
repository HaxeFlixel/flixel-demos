package blends;

import openfl.display.Shader;

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
		vec4 base = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});
		
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