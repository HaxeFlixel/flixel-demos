import openfl.display.BitmapData;
import flixel.FlxCamera;
import flixel.FlxG;
class PlayStateShader extends PlayState
{
	var shaderCam:FlxCamera;
	var bgBuffer:BitmapData;
	
	var shader:Shader;
	
	override function create():Void
	{
		super.create();
	}
	
	override function createCams()
	{
		// FlxG.camera draws the actual world. In this case, that means the background
		final mainCam = FlxG.camera;
		mainCam.bgColor = 0x5a81ad;
		gem.camera = mainCam;
		background.camera = mainCam;
		FlxG.cameras.setDefaultDrawTarget(mainCam, false);
		
		// shaderCam draws casted shadows from everything drawn to it, these draw above FlxG.camera
		// In this case that means everything except ui and the background
		shaderCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(shaderCam);
		shaderCam.bgColor = 0x0;
		shader = new Shader();
		mainCam.buffer = new BitmapData(mainCam.width, mainCam.height);
		shader.bgImage.input = mainCam.buffer;
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
		
		inline function random(mean:Float) return FlxG.random.floatNormal(mean, mean / 8);
		shader.setOrigin((gem.x + random(gem.origin.x)) / FlxG.width, (gem.y + random(gem.origin.y)) / FlxG.height);
	}
	
	override function draw()
	{
		super.draw();
		
		drawCameraBuffer(FlxG.camera);
	}
	
	static function drawCameraBuffer(camera:FlxCamera)
	{
		final buffer = camera.buffer;
		if (FlxG.renderTile)
		{
			@:privateAccess
			camera.render();
			
			buffer.fillRect(buffer.rect, 0x00000000);
			buffer.draw(camera.canvas);
		}
		return buffer;
	}
}