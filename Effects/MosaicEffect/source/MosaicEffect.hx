package;

import openfl.display.Shader;
import flixel.system.FlxAssets.FlxShader;

class MosaicEffect
{
	/**
	 * The effect's "start-value" on the x/y-axes (the effect is not visible with this value).
	 */
	public static inline var DEFAULT_STRENGTH:Float = 1;

	/**
	 * The instance of the actual shader class
	 */
	public var shader(default, null):MosaicShader;
	
	/**
	 * The effect's strength on the x-axis.
	 */
	public var strengthX(default, null):Float = DEFAULT_STRENGTH;
	
	/**
	 * The effect's strength on the y-axis.
	 */
	public var strengthY(default, null):Float = DEFAULT_STRENGTH;
	
	public function new(width:Float, height:Float):Void
	{
		shader = new MosaicShader();
		#if (openfl >= "8.0.0")
		shader.data.uTextureSize.value = [width, height];
		shader.data.uBlocksize.value = [strengthX, strengthY];
		#else
		shader.uTextureSize = [width, height];
		shader.uBlocksize = [strengthX, strengthY];
		#end
	}
	
	public function setStrength(strengthX:Float, strengthY:Float):Void
	{
		this.strengthX = strengthX;
		this.strengthY = strengthY;
		#if (openfl >= "8.0.0")
		shader.data.uBlocksize.value[0] = strengthX;
		shader.data.uBlocksize.value[1] = strengthY;
		#else
		shader.uBlocksize[0] = strengthX;
		shader.uBlocksize[1] = strengthY;
		#end
	}
}

/**
 * A classic mosaic effect, just like in the old days!
 * 
 * Usage notes:
 * - The effect will be applied to the whole screen.
 * - Set the x/y-values on the 'uBlocksize' vector to the desired size (setting this to 0 will make the screen go black)
 */
class MosaicShader extends FlxShader
{
	#if (openfl >= "8.0.0")
	@:glFragmentSource('
	varying vec2 openfl_vTexCoord;
	uniform vec2 uTextureSize;
	uniform vec2 uBlocksize;
	uniform sampler2D bitmap;

	void main()
	{
		vec2 blocks = uTextureSize / uBlocksize;
		gl_FragColor = texture2D(bitmap, floor(openfl_vTexCoord * blocks) / blocks);
	}')
	#else
	@fragment var code = '
	uniform vec2 uTextureSize;
	uniform vec2 uBlocksize;

	void main()
	{
		vec2 blocks = uTextureSize / uBlocksize;
		gl_FragColor = texture2D(${Shader.uSampler}, floor(${Shader.vTexCoord} * blocks) / blocks);
	}';
	#end
	
	public function new()
	{
		super();
	}
}