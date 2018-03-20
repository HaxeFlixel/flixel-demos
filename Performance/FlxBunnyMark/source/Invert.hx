package;

import openfl.display.Shader;
import flixel.system.FlxAssets.FlxShader;

/**
 * ...
 * @author MrCdK
 */
class Invert extends FlxShader
{
	#if (openfl >= "8.0.0")
	@:glFragmentSource('
	varying vec2 openfl_vTexCoord;
	uniform sampler2D texture0;

	void main()
	{
		vec4 color = texture2D(texture0, openfl_vTexCoord);
		gl_FragColor = vec4((1.0 - color.r) * color.a, (1.0 - color.g) * color.a, (1.0 - color.b) * color.a, color.a);
	}')
	#else
	@fragment var fragment = '
	void main()
	{
		vec4 color = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});
		gl_FragColor = vec4((1.0 - color.r) * color.a, (1.0 - color.g) * color.a, (1.0 - color.b) * color.a, color.a);
	}';
	#end
	
	public function new()
	{
		super();
	}
}