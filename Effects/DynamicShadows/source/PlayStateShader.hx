import flixel.FlxCamera;
import flixel.FlxG;
class PlayStateShader extends PlayState
{
	var shaderCam:FlxCamera;
	
	var shader:Shader;
	
	override function create():Void
	{
		super.create();
	}
	
	override function createCams()
	{
		// FlxG.camera draws the actual world. In this case, that means the background
		FlxG.camera.bgColor = 0x5a81ad;
		gem.camera = FlxG.camera;
		background.camera = FlxG.camera;
		FlxG.cameras.setDefaultDrawTarget(FlxG.camera, false);
		
		// shaderCam draws casted shadows from everything drawn to it, these draw above FlxG.camera
		// In this case that means everything except ui and the background
		shaderCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(shaderCam);
		shaderCam.bgColor = 0x0;
		shader = new Shader();
		shaderCam.setFilters([new openfl.filters.ShaderFilter(shader)]);
		
		// draws anything above the sahdows, in this case infoText
		uiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(uiCam, false);
		uiCam.bgColor = 0x0;
		infoText.camera = uiCam;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		shader.setOrigin((gem.x + gem.origin.x) / FlxG.width, (gem.y + gem.origin.y) / FlxG.height);
	}
}