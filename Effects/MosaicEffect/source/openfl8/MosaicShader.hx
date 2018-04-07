package openfl8;

import flixel.system.FlxAssets.FlxShader;

/**
 * A classic mosaic effect, just like in the old days!
 * 
 * Usage notes:
 * - The effect will be applied to the whole screen.
 * - Set the x/y-values on the 'uBlocksize' vector to the desired size (setting this to 0 will make the screen go black)
 */
class MosaicShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform vec2 uTextureSize;
		uniform vec2 uBlocksize;

		void main()
		{
			vec2 blocks = uTextureSize / uBlocksize;
			gl_FragColor = texture2D(bitmap, floor(openfl_TextureCoordv * blocks) / blocks);
		}'
	)

	public function new()
	{
		super();
	}
}
