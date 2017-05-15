package blends;

import flixel.util.FlxColor;

typedef BlendModeShader =
{
	var uBlendColor(get, set):Array<Float>;
}

class BlendModeEffect
{
	public var shader(default, null):BlendModeShader;
	
	@:isVar
	public var color(default, set):FlxColor;
	
	public function new(shader:BlendModeShader, color:FlxColor):Void
	{
		this.shader = shader;
		this.color = color;
	}
	
	private function set_color(color:FlxColor):FlxColor
	{
		shader.uBlendColor[0] = color.red;
		shader.uBlendColor[1] = color.green;
		shader.uBlendColor[2] = color.blue;
		shader.uBlendColor[3] = color.alphaFloat;

		return this.color = color;
	}
}
