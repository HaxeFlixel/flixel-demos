package effects;

import openfl.display.Shader;
import flixel.FlxG;
 
/**
 * Note: BitmapFilters can only be used on 'OpenFL Next'
 */
class WiggleEffect
{
	public static inline var EFFECT_TYPE_DREAMY:Int = 0;
	public static inline var EFFECT_TYPE_WAVY:Int = 1;
	public static inline var EFFECT_TYPE_HEAT_WAVE_HORIZONTAL:Int = 2;
	public static inline var EFFECT_TYPE_HEAT_WAVE_VERTICAL:Int = 3;
	public static inline var EFFECT_TYPE_FLAG:Int = 4;
	
	public  var effectType(default, set):Int = 0;
	public var shader(default, null):WiggleShader;
	public var waveSpeed(default, set):Float;
	public var waveFrequency(default, set):Float;
	public var waveAmplitude(default, set):Float;
	
	public function new():Void
	{
		shader = new WiggleShader();
		waveSpeed = 0.0;
		waveFrequency = 0.0;
		waveAmplitude = .00;
		
		effectType = EFFECT_TYPE_DREAMY;
	}
	
	public function update(elapsed:Float):Void
	{
		shader.uTime += elapsed;
	}
	
	private function set_effectType(v:Int):Int
	{
		this.effectType = v;
		shader.effectType = this.effectType;
		return v;
	}
	
	private function set_waveSpeed(v:Float):Float
	{
		this.waveSpeed = v;
		shader.uSpeed = this.waveSpeed;
		return v;
	}
	
	private function set_waveFrequency(v:Float):Float
	{
		this.waveFrequency = v;
		shader.uFrequency = this.waveFrequency;
		return v;
	}
	
	private function set_waveAmplitude(v:Float):Float
	{
		this.waveAmplitude = v;
		shader.uWaveAmplitude = this.waveAmplitude;
		return v;
	}
}

class WiggleShader extends Shader
{
	@fragment var code = '

	//uniform float tx, ty; // x,y waves phase
	uniform float uTime;
	
	const int EFFECT_TYPE_DREAMY = 0;
	const int EFFECT_TYPE_WAVY = 1;
	const int EFFECT_TYPE_HEAT_WAVE_HORIZONTAL = 2;
	const int EFFECT_TYPE_HEAT_WAVE_VERTICAL = 3;
	const int EFFECT_TYPE_FLAG = 4;
	
	uniform int effectType;
	
	/**
	 * How fast the waves move over time
	 */
	uniform float uSpeed;
	
	/**
	 * Number of waves over time
	 */
	uniform float uFrequency;
	
	/**
	 * How much the pixels are going to stretch over the waves
	 */
	uniform float uWaveAmplitude;

	vec2 sineWave( vec2 pt )
    {
		float x = 0.0;
		float y = 0.0;
		
		if (effectType == EFFECT_TYPE_DREAMY) 
		{
			float offsetX = sin(pt.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
			pt.x += offsetX; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
		}
		else if (effectType == EFFECT_TYPE_WAVY) 
		{
			float offsetY = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
			pt.y += offsetY; // * (pt.y - 1.0); // <- Uncomment to stop bottom part of the screen from moving
		}
		else if (effectType == EFFECT_TYPE_HEAT_WAVE_HORIZONTAL)
		{
			x = sin(pt.x * uFrequency + uTime * uSpeed) * uWaveAmplitude;
		}
		else if (effectType == EFFECT_TYPE_HEAT_WAVE_VERTICAL)
		{
			y = sin(pt.y * uFrequency + uTime * uSpeed) * uWaveAmplitude;
		}
		else if (effectType == EFFECT_TYPE_FLAG)
		{
			y = sin(pt.y * uFrequency + 10 * pt.x + uTime * uSpeed) * uWaveAmplitude;
			x = sin(pt.x * uFrequency + 5 * pt.y + uTime * uSpeed) * uWaveAmplitude;
		}
		
		return vec2(pt.x + x, pt.y + y);
    }

	void main()
    {
		vec2 uv = sineWave( ${Shader.vTexCoord} );
		gl_FragColor = texture2D(${Shader.uSampler}, uv);
    }

	';
	
	public function new()
	{
		super();
	}
}