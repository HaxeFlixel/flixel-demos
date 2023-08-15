package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

using StringTools;

class PlayState extends FlxState
{
	static inline var BASE_INFO:String = "LEFT & RIGHT to move, UP to jump";
	static inline var GROUND_POUND_INFO:String = "DOWN (in the air) to ground-pound";
	static inline var RESET_INFO:String = "R to Reset\n\nCurrent State: {STATE}";
	
	var _map:FlxTilemap;
	var _slime:Slime;
	var _superJump:FlxSprite;
	var _groundPound:FlxSprite;

	var _info:String = BASE_INFO + "\n" + RESET_INFO;
	var _txtInfo:FlxText;

	override public function create():Void
	{
		bgColor = 0xff661166;
		super.create();

		final J = 99;
		final G = 100;
		final columns = 20;
		final data = [
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, G, 0, 1,
			1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
			1, 0, 0, J, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
		];
		
		// remove powerups from map, store index so we can place them
		final superJumpIndex = data.indexOf(J);
		data[superJumpIndex] = 0;
		
		final groundPoundIndex = data.indexOf(G);
		data[groundPoundIndex] = 0;
		
		final tileSize = 16;
		_map = new FlxTilemap();
		_map.loadMapFromArray(data, 20, 15, "assets/tiles.png", tileSize, tileSize);
		add(_map);

		_slime = new Slime(192, 128);
		add(_slime);

		_superJump = new FlxSprite((superJumpIndex % columns) * tileSize, Std.int(superJumpIndex / columns) * tileSize, "assets/powerup.png");
		add(_superJump);

		_groundPound = new FlxSprite((groundPoundIndex % columns) * tileSize, Std.int(groundPoundIndex / columns) * tileSize, "assets/powerup.png");
		_groundPound.flipY = true;
		_groundPound.y += 4;
		add(_groundPound);

		_txtInfo = new FlxText(16, 16, -1, _info);
		add(_txtInfo);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.collide(_map, _slime);
		
		FlxG.overlap(_slime, _superJump, function (_, _)
		{
			_slime.addSuperJump();
			_superJump.kill();
		});
		
		FlxG.overlap(_slime, _groundPound, function (_, _)
		{
			_slime.addGroundPound();
			_groundPound.kill();
			startGroundPoundInfoTween();
		});

		_txtInfo.text = _info.replace("{STATE}", Type.getClassName(_slime.fsm.stateClass));

		if (FlxG.keys.justReleased.R)
		{
			FlxG.camera.flash(FlxColor.BLACK, .1, FlxG.resetState);
		}
	}
	
	function startGroundPoundInfoTween()
	{
		final duration = 2.0;
		final flash_period = 0.15 / duration;
		final oldColor = _txtInfo.color;
		final ease = FlxEase.linear;
		FlxTween.num(0, 1, duration, 
			{
				onComplete:function (_)
				{
					_txtInfo.color = oldColor;
					_info = BASE_INFO + "\n" + GROUND_POUND_INFO + "\n" + RESET_INFO;
				}
			},
			function(n)
			{
				_txtInfo.color = ((n / flash_period) % 1 > 0.5) ? FlxColor.YELLOW : oldColor;
				final chars = Std.int(ease(n) * GROUND_POUND_INFO.length);
				_info = BASE_INFO + "\n" + GROUND_POUND_INFO.substr(0, chars) + "\n" + RESET_INFO;
			}
		);
	}
}
