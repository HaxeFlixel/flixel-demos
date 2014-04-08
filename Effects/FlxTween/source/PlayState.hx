package;

import flixel.addons.effects.FlxTrail;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.TweenOptions;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.system.FlxAssets;

/**
 * Tweening demo.
 *
 * @author Gama11
 * @author Devolonter
 * @link https://github.com/devolonter/flixel-monkey-bananas/tree/master/tweening
 */
class PlayState extends FlxState
{
	/**
	 * The duration of the tween
	 */
	private static inline var DURATION:Float = 1;

	/**
	 * The tween types
	 */
	private static inline var TWEEN				:Int = 0;
	private static inline var ANGLE				:Int = 1;
	private static inline var COLOR				:Int = 2;
	private static inline var LINEAR_MOTION		:Int = 3;
	private static inline var LINEAR_PATH		:Int = 4;
	private static inline var CIRCULAR_MOTION	:Int = 5;
	private static inline var CUBIC_MOTION		:Int = 6;
	private static inline var QUAD_MOTION		:Int = 7;
	private static inline var QUAD_PATH			:Int = 8;

	private var _easeInfo:Array<EaseInfo>;
	
	private var _currentEaseIndex:Int = 0;
	private var _currentEaseType:String = "quad";
	private var _currentEaseDirection:String = "In";
	private var _currentTweenIndex:Int = TWEEN; // Start with tween() tween, it's used most commonly.
	
	private var _tween:FlxTween;
	private var _sprite:FlxSprite;
	private var _trail:FlxTrail;
	private var _min:FlxPoint;
	private var _max:FlxPoint;
	
	private var _currentEase(get, never):EaseFunction;

	override public function create():Void
	{
		FlxG.autoPause = false;
		
		// Set up an array containing all the different ease functions there are
		_easeInfo = new Array<EaseInfo>();

		_easeInfo.push({ name: "quadIn",       ease: FlxEase.quadIn       });
		_easeInfo.push({ name: "quadOut",      ease: FlxEase.quadOut      });
		_easeInfo.push({ name: "quadInOut",    ease: FlxEase.quadInOut    });
		
		_easeInfo.push({ name: "cubeIn",       ease: FlxEase.cubeIn       });
		_easeInfo.push({ name: "cubeOut",      ease: FlxEase.cubeOut      });
		_easeInfo.push({ name: "cubeInOut",    ease: FlxEase.cubeInOut    });
		
		_easeInfo.push({ name: "quartIn",      ease: FlxEase.quartIn      });
		_easeInfo.push({ name: "quartOut",     ease: FlxEase.quartOut     });
		_easeInfo.push({ name: "quartInOut",   ease: FlxEase.quartInOut   });
		
		_easeInfo.push({ name: "quintIn",      ease: FlxEase.quintIn      });
		_easeInfo.push({ name: "quintOut",     ease: FlxEase.quintOut     });
		_easeInfo.push({ name: "quintInOut",   ease: FlxEase.quintInOut   });
		
		_easeInfo.push({ name: "sineIn",       ease: FlxEase.sineIn       });
		_easeInfo.push({ name: "sineOut",      ease: FlxEase.sineOut      });
		_easeInfo.push({ name: "sineInOut",    ease: FlxEase.sineInOut    });
		
		_easeInfo.push({ name: "bounceIn",     ease: FlxEase.bounceIn     });
		_easeInfo.push({ name: "bounceOut",    ease: FlxEase.bounceOut    });
		_easeInfo.push({ name: "bounceInOut",  ease: FlxEase.bounceInOut  });
		
		_easeInfo.push({ name: "circIn",       ease: FlxEase.circIn       });
		_easeInfo.push({ name: "circOut",      ease: FlxEase.circOut      });
		_easeInfo.push({ name: "circInOut",    ease: FlxEase.circInOut    });
		
		_easeInfo.push({ name: "expoIn",       ease: FlxEase.expoIn       });
		_easeInfo.push({ name: "expoOut",      ease: FlxEase.expoOut      });
		_easeInfo.push({ name: "expoInOut",    ease: FlxEase.expoInOut    });
		
		_easeInfo.push({ name: "backIn",       ease: FlxEase.backIn       });
		_easeInfo.push({ name: "backOut",      ease: FlxEase.backOut      });
		_easeInfo.push({ name: "backInOut",    ease: FlxEase.backInOut    });
		
		_easeInfo.push({ name: "elasticIn",    ease: FlxEase.elasticIn    });
		_easeInfo.push({ name: "elasticOut",   ease: FlxEase.elasticOut   });
		_easeInfo.push({ name: "elasticInOut", ease: FlxEase.elasticInOut });
		
		_easeInfo.push({ name: "none",         ease: null                 });
		
		var title = new FlxText(0, 0, FlxG.width, "FlxTween", 64);
		title.alignment = "center";
		FlxSpriteUtil.screenCenter(title);
		title.alpha = 0.15;
		add(title);
		
		// Create the sprite to tween (flixel logo)
		_sprite = new FlxSprite();
		_sprite.loadGraphic(GraphicLogo, true);
		_sprite.antialiasing = true; // subpixel-rendering for smoother movement
		
		// Add a trail effect
		_trail = new FlxTrail(_sprite, GraphicLogo, 12, 0, 0.4, 0.02);
		
		add(_trail);
		add(_sprite);
		
		_min = FlxPoint.get(FlxG.width * 0.1, FlxG.height * 0.25);
		_max = FlxPoint.get(FlxG.width * 0.7, FlxG.height * 0.75);
		
		/*** From here on: UI setup ***/
		
		// First row
		
		var yOff = 10;
		var xOff = 10;
		var gutter = 10;
		var headerWidth = 60;
		
		add(new FlxText(xOff, yOff + 3, 200, "Tween:", 12));
		
		xOff = 80;
		
		var tweenTypes:Array<String> = ["tween", "angle", "color", "linearMotion", "linearPath", "circularMotion", "cubicMotion",
										 "quadMotion", "quadPath"];
		
		var header = new FlxUIDropDownHeader(130);
		var tweenTypeDropDown = new FlxUIDropDownMenu(xOff, yOff, FlxUIDropDownMenu.makeStrIdLabelArray(tweenTypes, true), onTweenChange, header);
		tweenTypeDropDown.header.text.text = "tween"; // Initialize header with correct value
		
		// Second row
		
		yOff += 30;
		xOff = 10;
		
		add(new FlxText(10, yOff + 3, 200, "Ease:", 12));
		
		xOff = Std.int(tweenTypeDropDown.x);
		
		var easeTypes:Array<String> = ["quad", "cube", "quart", "quint", "sine", "bounce", "circ", "expo", "back", "elastic", "none"];
		var header = new FlxUIDropDownHeader(headerWidth);
		var easeTypeDropDown = new FlxUIDropDownMenu(xOff, yOff, FlxUIDropDownMenu.makeStrIdLabelArray(easeTypes), onEaseTypeChange, header);
		
		xOff += (headerWidth + gutter);
		
		var easeDirections:Array<String> = ["In", "Out", "InOut"];
		var header2 = new FlxUIDropDownHeader(headerWidth);
		var easeDirectionDropDown = new FlxUIDropDownMenu(xOff, yOff, 
									FlxUIDropDownMenu.makeStrIdLabelArray(easeDirections), onEaseDirectionChange, header2);
		
		// Third row
		
		yOff += 30;
		xOff = 80;
		
		var trailToggleButton = new FlxUIButton(xOff, yOff, "Trail", onToggleTrail);
		trailToggleButton.loadGraphicSlice9(null, headerWidth, 0, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		trailToggleButton.toggled = true;
		
		// Add stuff in correct order - (lower y values first because of the dropdown menus)
		
		add(trailToggleButton);
		
		add(easeTypeDropDown);
		add(easeDirectionDropDown);
		
		add(tweenTypeDropDown);
		
		// Start the tween
		startTween();
		
		#if !FLX_NO_DEBUG
		FlxG.watch.add(this, "_currentEaseIndex");
		FlxG.watch.add(this, "_currentEaseType");
		FlxG.watch.add(this, "_currentEaseDirection");
		FlxG.watch.add(this, "_currentTweenIndex");
		#end
	}

	private function startTween():Void
	{
		var options:TweenOptions = { type: FlxTween.PINGPONG, ease: _currentEase }
		
		FlxSpriteUtil.screenCenter(_sprite);
		_sprite.x = _min.x;
		
		_sprite.angle = 0;
		_sprite.color = FlxColor.WHITE;
		_sprite.alpha = 0.8; // Lowered alpha looks neat
		
		// Cancel the old tween
		if (_tween != null) {
			_tween.cancel();
		}
		
		switch (_currentTweenIndex)
		{
			case TWEEN:
				_tween = FlxTween.tween(_sprite, { x: _max.x, angle: 180 }, DURATION, options);
				
			case ANGLE:
				_tween = FlxTween.angle(_sprite, 0, 90, DURATION, options);
				FlxSpriteUtil.screenCenter(_sprite);
				
			case COLOR:
				_tween = FlxTween.color(_sprite, DURATION, FlxColor.BLACK, FlxColor.BLUE, 1, 0, options);
				FlxSpriteUtil.screenCenter(_sprite);
				
			case LINEAR_MOTION:
				_tween = FlxTween.linearMotion(	_sprite,
												_sprite.x, _sprite.y,
												_max.x, _sprite.y,
												DURATION, true, options);
				
			case LINEAR_PATH:
				_sprite.y = (_max.y - _sprite.height);
				var path:Array<FlxPoint> = [FlxPoint.get(_sprite.x, _sprite.y),
											FlxPoint.get(_sprite.x + (_max.x - _min.x) * 0.5, _min.y),
											FlxPoint.get(_max.x, _sprite.y)];
				_tween = FlxTween.linearPath(_sprite, path, DURATION, true, options);
				
			case CIRCULAR_MOTION:
				_tween = FlxTween.circularMotion(	_sprite,
													(FlxG.width * 0.5) - (_sprite.width / 2), 
													(FlxG.height * 0.5) - (_sprite.height / 2),
													_sprite.width, 359,
													true, DURATION, true, options);
				
			case CUBIC_MOTION:
				_sprite.y = _min.y;
				_tween = FlxTween.cubicMotion(	_sprite,
												_sprite.x, _sprite.y,
												_sprite.x + (_max.x - _min.x) * 0.25, _max.y,
												_sprite.x + (_max.x - _min.x) * 0.75, _max.y,
												_max.x, _sprite.y,
												DURATION, options);
					
			case QUAD_MOTION:
				var rangeModifier = 100;
				_tween = FlxTween.quadMotion(	_sprite,
												_sprite.x, 					// start x
												_sprite.y + rangeModifier,	// start y
												_sprite.x + (_max.x - _min.x) * 0.5, // control x
												_min.y - rangeModifier, 	// control y 
												_max.x, 					// end x
												_sprite.y + rangeModifier,	// end y
												DURATION, true, options);
	
			case QUAD_PATH:
				var path:Array<FlxPoint> = [FlxPoint.get(_sprite.x, _sprite.y),
											FlxPoint.get(_sprite.x + (_max.x - _min.x) * 0.5, _max.y),
											FlxPoint.get(_max.x - (_max.x / 2) + (_sprite.width / 2), _sprite.y), 
											FlxPoint.get(_max.x - (_max.x / 2) + (_sprite.width / 2), _min.y),
											FlxPoint.get(_max.x, _sprite.y)];
				_tween = FlxTween.quadPath(_sprite, path, DURATION, true, options);
		}
		
		_trail.resetTrail();
	}

	private inline function get__currentEase():EaseFunction
	{
		return _easeInfo[_currentEaseIndex].ease;
	}
	
	private function onEaseTypeChange(ID:String):Void
	{
		_currentEaseType = ID;
		updateEaseIndex();
	}
	
	private function onEaseDirectionChange(ID:String):Void
	{
		_currentEaseDirection = ID;
		updateEaseIndex();
	}
	
	private function updateEaseIndex():Void
	{
		var curEase = _currentEaseType + _currentEaseDirection;
		var foundEase:Bool = false;
		
		// Find the ease info in the array with the right name
		for (i in 0..._easeInfo.length)
		{
			if (curEase == _easeInfo[i].name)
			{
				_currentEaseIndex = i;
				foundEase = true;
			}
		}
		
		if (!foundEase) {
			_currentEaseIndex = _easeInfo.length - 1; // last entry is "none"
		}
		
		// Need to restart the tween now
		startTween();
	}
	
	private function onTweenChange(ID:String):Void
	{
		_currentTweenIndex = Std.parseInt(ID);
		startTween();
	}
	
	private function onToggleTrail():Void
	{
		_trail.visible = !_trail.visible;
		_trail.resetTrail();
	}
}

typedef EaseInfo = {
	name:String,
	ease:EaseFunction
}