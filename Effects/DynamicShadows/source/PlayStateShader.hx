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
		// FlxG.camera draws the actual world. In this case, that means the background and the gem
		// Note, the shader also draws this cam, so in the end this camera is completely covered by shaderCam
		final bgCam = FlxG.camera;
		bgCam.bgColor = 0x5a81ad;
		gem.camera = bgCam;
		background.camera = bgCam;
		FlxG.cameras.setDefaultDrawTarget(bgCam, false);
		
		/* shaderCam draws the foreground elements (except the gem), then passes that as input to
		 * the shader along with the bg camera, the fg is used to cast shadows on the bg
		 * In this case that means everything except the gem, ui and background
		 */
		shaderCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(shaderCam);
		shaderCam.bgColor = 0x0;
		shader = new Shader();
		// add the bg camera as an image to the shader so we can add color effects to it
		bgCam.buffer = new BitmapData(bgCam.width, bgCam.height);
		shader.bgImage.input = bgCam.buffer;
		shaderCam.filters = [new openfl.filters.ShaderFilter(shader)];
		
		// draws anything above the shadows, in this case infoText
		uiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(uiCam, false);
		uiCam.bgColor = 0x0;
		infoText.camera = uiCam;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		inline function random(mean:Float)
			return FlxG.random.floatNormal(mean, mean / 8);
		shader.setOrigin((gem.x + random(gem.origin.x)) / FlxG.width, (gem.y + random(gem.origin.y)) / FlxG.height);
	}
	
	override function draw()
	{
		super.draw();
		
		// draw the camera's canvas to it's buffer so it shows up in the shader
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
