package;

import openfl.display.Shader;
import flixel.system.FlxAssets.FlxShader;

class FloodFill extends FlxShader
{
	#if (openfl >= "8.0.0")
	@:glFragmentSource('
	varying vec2 openfl_vTexCoord;
	uniform float uFloodFillY;
	uniform sampler2D bitmap;
	
	void main() 
	{
		vec2 border = vec2(openfl_vTexCoord.x, uFloodFillY);
		vec4 color;
		
		if (openfl_vTexCoord.y > uFloodFillY)
		{
			color = texture2D(bitmap, border);
		}
		else
		{
			color = texture2D(bitmap, openfl_vTexCoord);
		}
		
		gl_FragColor = color;
	}')
	#else
	@fragment var code = '
	uniform float uFloodFillY;
	
	void main() 
	{
		vec2 border = vec2(${Shader.vTexCoord}.x, uFloodFillY);
		vec4 color;
		
		if (${Shader.vTexCoord}.y > uFloodFillY)
		{
			color = texture2D(${Shader.uSampler}, border);
		}
		else
		{
			color = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});
		}
		
		gl_FragColor = color;
	}';
	#end

	public function new()
	{
		super();
	}
}
