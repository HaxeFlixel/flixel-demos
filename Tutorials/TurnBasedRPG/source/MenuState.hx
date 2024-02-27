package;

import ui.OptionsSubState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class MenuState extends FlxState
{
	override public function create()
	{
		// NOTE: differs from tutorial!
		var map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		var walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.x -= 123;
		walls.y -= 10;
		add(walls);
		
		// Use FlxBitmapText for crisper edges on large text
		var titleText = new LargeText(0, 16, "DUNGEON\nCRAWLER");
		titleText.alignment = CENTER;
		titleText.setBorderStyle(OUTLINE, 0xFF3f2631);
		titleText.screenCenter(X);
		add(titleText);
		
		// TUTORIAL VERSION:
		// var titleText = new FlxText(0, 16, 0, "DUNGEON\nCRAWLER", 32);
		// titleText.alignment = CENTER;
		// titleText.screenCenter(X);
		// add(titleText);

		var playButton = new FlxButton(0, 0, "Play", clickPlay);
		playButton.loadGraphic(AssetPaths.button__png, true, 80, 20);
		playButton.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		playButton.x = (FlxG.width / 2) - 10 - playButton.width;
		playButton.y = FlxG.height - playButton.height - 10;
		add(playButton);

		var optionsButton = new FlxButton(0, 0, "Options", clickOptions);
		optionsButton.loadGraphic(AssetPaths.button__png, true, 80, 20);
		optionsButton.x = (FlxG.width / 2) + 10;
		optionsButton.y = FlxG.height - optionsButton.height - 10;
		add(optionsButton);

		#if desktop
		var exitButton = new FlxButton(FlxG.width - 28, 8, "X", clickExit);
		exitButton.loadGraphic(AssetPaths.small_button__png, true, 20, 20);
		add(exitButton);
		#end

		if (FlxG.sound.music == null) // don't restart the music if it's already playing
		{
			initSound();
		}

		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

		super.create();
	}
	
	function initSound()
	{
		var volumes:{ music:Float, sound:Float } = null;
		if (FlxG.save.data.volumes != null)
			volumes = FlxG.save.data.volumes;
		else
			volumes = { music:0.5, sound:1.0 };
		
		FlxG.sound.defaultMusicGroup.volume = volumes.music;
		FlxG.sound.defaultSoundGroup.volume = volumes.sound;
		
		#if flash
		FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__mp3, 1.0, true);
		#else
		FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__ogg, 1.0, true);
		#end
	}

	function clickPlay()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		{
			FlxG.switchState(PlayState.new);
		});
	}

	function clickOptions()
	{
		openSubState(new OptionsSubState());
		// FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		// {
		// 	FlxG.switchState(OptionsState.new);
		// });
	}

	#if desktop
	function clickExit()
	{
		Sys.exit(0);
	}
	#end
}
