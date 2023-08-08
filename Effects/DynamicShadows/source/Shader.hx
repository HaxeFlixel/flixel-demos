package;

import flixel.FlxG;
import flixel.math.FlxPoint;

class Shader extends flixel.system.FlxAssets.FlxShader
{
	public var originX(get, never):Float;
	inline function get_originX() return this.uOrigin.value[0];
	
	public var originY(get, never):Float;
	inline function get_originY() return this.uOrigin.value[1];
	
	public var glowRadius(get, set):Float;
	inline function get_glowRadius() return this.uGlowRadius.value[0];
	inline function set_glowRadius(value:Float)
	{
		this.uGlowRadius.value = [Math.min(1, Math.max(0, value))];
		FlxG.watch.addQuick("glowRadius", value);
		return value;
	}
	
	@:glFragmentSource('
		#pragma header
		
		uniform sampler2D bgImage;
		uniform vec2 uOrigin;
		uniform float uScale;
		uniform float uGlowRadius;
		
		vec2 scalePos(vec2 p, float scale)
		{
			vec2 origin = uOrigin;// / openfl_TextureSize;
			return origin + (p - origin) / scale;
		}
		
		float getShadow(vec2 p)
		{
			// Not an effecient way to do this, but just scaling up the texture and put shadow if any part of it is "blocked"
			float shadowAmount = 0.0;
			for (float scale = 1.0; scale < 2.0; scale += 0.02) 
			{
				shadowAmount = max(shadowAmount, texture2D(bitmap, scalePos(p, scale)).a);
			}
			return shadowAmount;
		}
		
		float getGlow(vec2 p)
		{
			vec2 res = openfl_TextureSize;
			p = p-uOrigin;
			p.y *= res.y / res.x;
			return 1.0 - smoothstep(uGlowRadius * 0.5, uGlowRadius, length(p));
		}
		
		const vec4 fgGlow = vec4(1.0, 0.125, 0.0, 0.5);
		vec4 applyFgGlow(vec4 fg, float glowAmount)
		{
			vec3 glowRgb = fgGlow.rgb * fgGlow.a * glowAmount;
			vec3 mult = fg.rgb * glowRgb;
			vec3 add = fg.rgb + glowRgb;
			return vec4((mult + add)/2.0, fg.a);
		}
		
		const vec3 unshadedRgb = vec3(0.6, 0.6, 1.0);
		const vec4 shadeColor = vec4(0.0, 0.0, 0.4, 0.6);
		const vec4 bgGlow = vec4(1.0, 0.125, 0.0, 0.25);
		vec4 applyBgGlow(vec4 bg, float shadeAmount, float glowAmount)
		{
			vec3 shadeRgb = mix(unshadedRgb, shadeColor.rgb, shadeColor.a * shadeAmount);
			vec3 glowRgb = bgGlow.rgb * bgGlow.a * glowAmount;
			vec3 mult = (bg.rgb + glowRgb / 2.0) * (glowRgb + shadeRgb);
			return vec4(mult, bg.a);
		}
		
		void main()
		{
			vec2 uv = openfl_TextureCoordv;
			
			vec4 bg = texture2D(bgImage, uv);
			vec4 fg = texture2D(bitmap, uv);
			float shadowAmount = getShadow(uv);
			float glowAmount = getGlow(uv);
			
			gl_FragColor = mix(applyBgGlow(bg, shadowAmount, glowAmount), applyFgGlow(fg, glowAmount), fg.a);
		}
	')
	
	public function new ()
	{
		super();
		
		setOrigin(FlxG.width, FlxG.height);
		glowRadius = 0.05;
	}
	
	static var point = FlxPoint.get();
	public function setOrigin(x:Float, y:Float)
	{
		FlxG.watch.addQuick("origin", point.set(x, y));
		this.uOrigin.value = [x, y];
	}
}