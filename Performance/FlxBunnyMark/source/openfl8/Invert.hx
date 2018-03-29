package openfl8;

import flixel.system.FlxAssets.FlxShader;

class Invert extends FlxShader
{
	@:glFragmentSource('
		varying vec2 openfl_vTexCoord;
		uniform sampler2D bitmap;

		void main()
		{
			vec4 color = texture2D(bitmap, openfl_vTexCoord);
			gl_FragColor = vec4((1.0 - color.r) * color.a, (1.0 - color.g) * color.a, (1.0 - color.b) * color.a, color.a);
		}'
	)
	
	public function new()
	{
		super();
	}
}