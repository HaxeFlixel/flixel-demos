package shaders;

import openfl.display.Shader;

/**
 * ...
 * @author MrCdK
 */
class Hq2x extends Shader
{

	@fragment var code = '

		void main()
		{
			float x = 1.0 / ${Shader.uTextureSize}.x;
			float y = 1.0 / ${Shader.uTextureSize}.y;

			vec4 color1 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}.st + vec2(-x, -y));
			vec4 color2 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}.st + vec2(0.0, -y));
			vec4 color3 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}.st + vec2(x, -y));

			vec4 color4 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}.st + vec2(-x, 0.0));
			vec4 color5 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}.st + vec2(0.0, 0.0));
			vec4 color6 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}.st + vec2(x, 0.0));

			vec4 color7 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}.st + vec2(-x, y));
			vec4 color8 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}.st + vec2(0.0, y));
			vec4 color9 = texture2D(${Shader.uSampler}, ${Shader.vTexCoord}.st + vec2(x, y));
			vec4 avg = color1 + color2 + color3 + color4 + color5 + color6 + color7 + color8 + color9;

			gl_FragColor = avg / 9.0;
		}
		
	';
	
	public function new() 
	{
		super();
		
	}
	
}