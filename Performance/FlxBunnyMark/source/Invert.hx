package ;

import openfl.display.Shader;

/**
 * ...
 * @author MrCdK
 */
class Invert extends Shader
{
	@fragment var fragment = '

	void main()
	{
		vec4 color = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});
		gl_FragColor = vec4(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, color.a);
	}
	';
	
	public function new()
	{
		super();
	}
}