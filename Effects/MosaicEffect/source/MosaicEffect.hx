package ;
 
	import flash.filters.BitmapFilter;
	import flixel.FlxG;
	import openfl.filters.ShaderFilter;
	
	/**
	 * Note: BitmapFilters can only be used on OpenFL next
	 */
	class MosaicEffect
	{
		private var shader:MosaicShader;
		public static inline var DEFAULT_STRENGTH:Float = 1;
		
		public function new():Void
		{
			shader = new MosaicShader();
			var filter:ShaderFilter = new ShaderFilter(shader);
			var filters:Array<BitmapFilter> = [filter];
			
			shader.uBlocksize = [DEFAULT_STRENGTH, DEFAULT_STRENGTH];
			
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
