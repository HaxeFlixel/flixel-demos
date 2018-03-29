package openfl8;

import flixel.system.FlxAssets.FlxShader;

class FloodFill extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform float uFloodFillY;

		void main()
		{
			vec2 border = vec2(openfl_TexCoordv.x, uFloodFillY);
			vec4 color;

			if (openfl_TexCoordv.y > uFloodFillY)
			{
				color = texture2D(bitmap, border);
			}
			else
			{
				color = texture2D(bitmap, openfl_TexCoordv);
			}

			gl_FragColor = color;
		}'
	)

	public function new()
	{
		super();
	}
}
