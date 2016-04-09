package shaders;

import openfl.display.Shader;

/**
 * ...
 * @author MrCdK
 */
class FXAA extends Shader
{
	
	@fragment var code = '
	
		vec2 delta = (1 / ${Shader.uTextureSize}.x, 1 / ${Shader.uTextureSize}.y);
		
		void main()
		{
			vec2 tuv = ${Shader.vTexCoord}.xy;
			vec3 nw = texture2D(${Shader.uSampler}, tuv + vec2(-1, -1) * delta).rgb;
			vec3 ne = texture2D(${Shader.uSampler}, tuv + vec2(1, -1) * delta).rgb;
			vec3 sw = texture2D(${Shader.uSampler}, tuv + vec2(-1, 1) * delta).rgb;
			vec3 se = texture2D(${Shader.uSampler}, tuv + vec2(1, 1) * delta).rgb;
			vec4 texColor = texture2D(${Shader.uSampler}, tuv).rgba;
			vec3 mid = texColor.rgb;
			
			vec3 lumA = vec3(0.299, 0.587, 0.114);
			
			float lumNW = dot(nw, lumA);
			float lumNE = dot(ne, lumA);
			float lumSW = dot(sw, lumA);
			float lumSE = dot(se, lumA);
			float lumMid = dot(mid, lumA);
			
			float lumMin = min(lumMid, min(min(lumNW, lumNE), min(lumSW, lumSE)));
			float lumMax = max(lumMid, max(max(lumNW, lumNE), max(lumSW, lumSE)));
			
			vec2 dir;
			dir.x = -((lumNW + lumNE) - (lumSW + lumSE));
			dir.y = (lumNW + lumSW) - (lumNE + lumSE);
			
			float dirReduce = max((lumNW + lumNE + lumSW + lumSE) * (0.25 / 128), 1.0 / 8);
			float rcpDirMin = 1 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
			dir = min(vec2(8, 8), max(vec2(-8, -8), dir * rcpDirMin)) * delta;
			
			vec3 rgbA = 0.5 * (texture2D(${Shader.uSampler}, tuv + dir * (1.0 / 3.0 - 0.5)).xyz + texture2D(${Shader.uSampler}, tuv + dir * (2.0 / 3.0 - 0.5)).xyz);
			vec3 rgbB = rgbA * 0.5 + 0.25 * (texture2D(${Shader.uSampler}, tuv + dir * -0.5).xyz + texture2D(${Shader.uSampler}, tuv + dir * 0.5).xyz);
			float lumB = dot(rgbB, lumA);
			vec4 color;
			
			if ((lumB < lumMin) || (lumB > lumMax))
			{
				color = vec4(rgbA, texColor.a);
			}
			else
			{
				color = vec4(rgbB, texColor.a);
			}
			
			gl_FragColor = color;
		}
	';
	
	public function new() 
	{
		super();
	}
	
}