package openfl8;

import flixel.system.FlxAssets.FlxShader;

class FloodFill extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform float uFloodFillY;

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
		}'
	)

	public function new()
	{
		super();
	}
}
