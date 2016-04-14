package ;
 
	import flash.filters.BitmapFilter;
	import flixel.FlxG;
	import openfl.display.Shader;
	import openfl.filters.ShaderFilter;
	
	/**
	 * A classic mosaic effect, just like in the old days!
	 * Note: The effect will be applied to the whole screen.
	 */
	class FlxMosaic
	{
		/**
		 * The amount of pixelation applied to the graphic
		 */
		private var shader:MosaicShader;
		private static inline var DEFAULT_STRENGTH:Float = 1;
		
		public function new():Void
		{
			shader = new MosaicShader();
			var filter:ShaderFilter = new ShaderFilter(shader);
			
			shader.uBlocksize = [DEFAULT_STRENGTH, DEFAULT_STRENGTH];
			
			var filters:Array<BitmapFilter> = [filter];
			FlxG.camera.setFilters(filters);
			FlxG.camera.filtersEnabled = true;
		}
		
		/**
		 * Sets the size of the inflated pixels
		 * @param	strengthX
		 * @param	strengthY
		 */
		public function setEffectAmount(strengthX:Float, strengthY:Float):Void
		{
			shader.uBlocksize = [strengthX, strengthY];
		}
	}

class MosaicShader extends Shader
{
    @fragment var code = '
    
    uniform vec2 uBlocksize;

    void main()
	{
        vec2 blocks = ${Shader.uTextureSize} / uBlocksize;
		gl_FragColor = texture2D(${Shader.uSampler}, floor(${Shader.vTexCoord} * blocks) / blocks);
    }
    ';
    
    public function new()
    {
        super();
    }
}
