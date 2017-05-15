package effects;

import flixel.FlxG;
import openfl.display.Shader;
 
/**
 * Note: BitmapFilters can only be used on 'OpenFL Next'
 */
class ShutterEffect
{
	public static inline var SHUTTER_TARGET_FLXSPRITE:Int = 0;
	public static inline var SHUTTER_TARGET_FLXCAMERA:Int = 1;
	
	public var shutterTargetMode(default, set):Int = 0;
	
	/**
	 * The instance of the actual shader class
	 */
	public var shader(default, null):ShutterShader;
	
	/**
	 * Size of the circle or "shutter"
	 */
	public var radius(default, set):Float;
	
	/**
	 * Center point of the "shutter"
	 */
	public var shutterCenterX(default, set):Float;
	public var shutterCenterY(default, set):Float;
	
	public var isActive(default, set):Bool;
	
	public function new():Void
	{
		shader = new ShutterShader();
		setResolution();
		isActive = true;
		shutterCenterX = FlxG.width * .5;
		shutterCenterY = FlxG.height * .5;
		shutterTargetMode = SHUTTER_TARGET_FLXSPRITE;
		radius = 0;
	}
	
	private function setResolution():Void
	{
		shader.uResolution[0] = FlxG.width;
		shader.uResolution[1] = FlxG.height;
	}
	
	private function set_shutterTargetMode(v:Int):Int
	{	
		shutterTargetMode = v;
		shader.shutterTargetMode = shutterTargetMode;
		return v;
	}
	
	private function set_isActive(v:Bool):Bool
	{
		isActive = v;
		shader.shaderIsActive = isActive;
		return v;
	}
	
	private function set_radius(v:Float):Float
	{
		radius = (v <= 0.0 ? 0.0 : v);
		shader.uCircleRadius = radius;
		return v;
	}
	
	private function set_shutterCenterX(v:Float):Float
	{
		shutterCenterX = v;
		shader.centerPtX = v;
		return v;
	}
	
	private function set_shutterCenterY(v:Float):Float
	{
		shutterCenterY = v;
		shader.centerPtY = v;
		return v;
	}
}

class ShutterShader extends Shader
{
	@fragment var code = '

	#ifdef GL_ES
		precision mediump float;
	#endif

	const int SHUTTER_TARGET_FLXSPRITE = 0;
	const int SHUTTER_TARGET_FLXCAMERA = 1;
	const float scale = 1.0;
	
	uniform vec2 uResolution;
	uniform float centerPtX;
	uniform float centerPtY;
	uniform float uCircleRadius;
	uniform int shutterTargetMode;
	uniform bool shaderIsActive;
	
	vec2 getCoordinates()
	{
		return vec2(
			(${ Shader.vTexCoord }.x * uResolution.x) / scale,
			(${ Shader.vTexCoord }.y * uResolution.y) / scale
		);
	}
	
	float getDist(vec2 pt1, vec2 pt2)
	{
		float dx = pt1.x - pt2.x;
		float dy = pt1.y - pt2.y;
		
		return sqrt(
			(dx*dx) + (dy*dy)
		);
	}
	
	void main()
	{		
		if (!shaderIsActive)
		{
			gl_FragColor = texture2D(${ Shader.uSampler }, ${ Shader.vTexCoord } );
			return;
		}
		
		vec2 centerPt = vec2(centerPtX, centerPtY);
		
		if (uCircleRadius <= 0.0 || getDist(getCoordinates(), centerPt) > uCircleRadius)
		{
			gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
		}
		else
		{
			/* If this shader is used on a FlxCamera, uncomment the line below to
			draw the underlying pixels inside the shutter (as they would look normally).
			
			If using this shader on a FlxSprite, keep the line below commented out, to
			draw transparency inside the shutter */
			
			if (shutterTargetMode == SHUTTER_TARGET_FLXCAMERA)
			{
				gl_FragColor = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});	
			}
		}
	}
	';
	
	public function new()
	{
		super();
	}
}