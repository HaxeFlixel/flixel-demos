package openfl8;

import flixel.system.FlxAssets.FlxShader;

class Scanline extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		const float scale = 1.0;

		void main()
		{
			if (mod(floor(openfl_TexCoordv.y * 480.0 / scale), 2.0) == 0.0)
				gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
			else
				gl_FragColor = texture2D(bitmap, openfl_TexCoordv);
		}'
	)
	
	public function new()
	{
		super();
	}
}