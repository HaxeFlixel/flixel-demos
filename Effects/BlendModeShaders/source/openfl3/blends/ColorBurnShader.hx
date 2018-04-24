package openfl3.blends;

import openfl.display.Shader;

class ColorBurnShader extends Shader
{
	@fragment var code = '
		uniform vec4 uBlendColor;
		
		float applyColorBurnToChannel(float base, float blend)
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
			vec4 base = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});
			gl_FragColor = blendColorBurn(base, uBlendColor, uBlendColor[3]);
		}';
	
	public function new()
	{
		super();
	}
}