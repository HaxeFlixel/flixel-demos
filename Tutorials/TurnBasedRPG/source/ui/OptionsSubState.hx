package ui;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.display.FlxSliceSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * A SubState that pauses the main menu to show the options UI
 */
class OptionsSubState extends flixel.FlxSubState
{
	public function new ()
	{
		super();
		
		// black-out the main menu
		var back = new FlxSprite();
		back.makeGraphic(1, 1, 0x80000000);
		back.setGraphicSize(FlxG.width, FlxG.height);
		back.updateHitbox();
		add(back);
		
		// add the UI
		var ui = new OptionsUI(()->close());
		add(ui);
	}
}

/**
 * The UI that controls options, extends `FlxSpriteGroup` which changes its members
 * when certain properties are changed, namely `x`, `y`, `alpha` and `scrollFactor`.
 */
class OptionsUI extends FlxGroup
{
	
	// define our screen elements
	var musicBar:VolumeBar;
	var soundBar:VolumeBar;
	var fullscreenButton:FlxButton;
	
	public function new (onClose:()->Void)
	{
		super();
		
		if (FlxG.save.data.volumes == null)
			initSave();
		
		// Make a background to visially separate the ui from the game underneath
		var bg = new FlxSliceSprite(AssetPaths.uiback__png, new FlxRect(16, 16, 16, 16), 200, 160);
		// Stretch the sections rather than tiling them for better performance
		bg.stretchTop
			= bg.stretchRight
			= bg.stretchLeft
			= bg.stretchBottom
			= bg.stretchCenter
			= true;
		bg.screenCenter(XY);
		add(bg);
		
		// place the group in the screen center, this will move the bg, and anything added later
		
		var titleText = new LargeText(bg.x, bg.y + 4, "Options", 2);
		titleText.screenCenter(X);
		add(titleText);
		
		var gap = 8;
		var barX = bg.x + gap;
		var barY = titleText.y + titleText.height + gap;
		var barWidth = bg.width - gap * 2;
		
		musicBar = new VolumeBar(barX, barY, barWidth, "Music", FlxG.sound.defaultMusicGroup.volume, updateMusic);
		add(musicBar);
		barY += musicBar.height + gap;
		
		soundBar = new VolumeBar(barX, barY, barWidth, "Sound", FlxG.sound.defaultSoundGroup.volume, updateSound);
		add(soundBar);
		// barY += soundBar.height + gap;
		
		fullscreenButton = new Button(0, soundBar.y + soundBar.height + 8, FlxG.fullscreen ? "Windowed" : "Fullscreen", clickFullscreen);
		fullscreenButton.screenCenter(X);
		add(fullscreenButton);
		
		var clearDataButton = new Button(bg.x + 10, 0, "Clear Data", clickClearData);
		clearDataButton.y = bg.y + bg.height - clearDataButton.height - 10;
		add(clearDataButton);
		
		var backButton = new Button(0, clearDataButton.y, "Back", onClose);
		backButton.x = bg.x + bg.width - backButton.width - 10;
		add(backButton);
	}
	
	function clickFullscreen()
	{
		fullscreenButton.text = FlxG.fullscreen ? "Windowed" : "Fullscreen";
		FlxG.fullscreen = !FlxG.fullscreen;
		FlxG.save.data.fullscreen = FlxG.fullscreen;
		FlxG.save.flush();
	}
	
	function initSave()
	{
		FlxG.save.data.volumes =
		{
			music: FlxG.sound.defaultMusicGroup.volume,
			sound: FlxG.sound.defaultSoundGroup.volume
		};
		FlxG.sound.muted = false;
		FlxG.sound.volume = 1.0;
		FlxG.save.data.fullscreen = FlxG.fullscreen;
		FlxG.save.flush();
		trace(FlxG.save.data);
	}
	
	/**
	 * The user wants to clear the saved data - we just call erase on our save object and then reset the volume to .5
	 */
	function clickClearData()
	{
		FlxG.save.erase();
		initSave();
		musicBar.setVolume(0.5, true);
		soundBar.setVolume(1.0, true);
	}
	
	/**
	 * Whenever we want to show the value of volume, we call this to change the bar and the amount text
	 */
	function updateMusic(volume:Float)
	{
		FlxG.sound.defaultMusicGroup.volume = volume;
		FlxG.save.data.volumes.music = volume;
		FlxG.save.flush();
	}
	
	/**
	 * Whenever we want to show the value of volume, we call this to change the bar and the amount text
	 */
	function updateSound(volume:Float)
	{
		FlxG.sound.defaultSoundGroup.volume = volume;
		FlxG.save.data.volumes.sound = volume;
		FlxG.save.flush();
	}
}

class VolumeBar extends FlxSpriteGroup
{
	var bar:FlxBar;
	var amountText:FlxText;
	var label:String;
	var onChange:(amount:Float)->Void;
	
	/**
	 * 
	 * @param   x 
	 * @param   y 
	 * @param   width 
	 * @param   label 
	 * @param   onChange 
	 * @return  
	 */
	public function new (x:Float, y:Float, width:Float, label:String, volume:Float, onChange:(amount:Float)->Void)
	{
		this.label = label;
		this.onChange = onChange;
		super();
		
		// var label = new FlxText(0, 0, 0, label, 8);
		// label.x = (width - label.width) / 2;
		// add(label);
		
		// the volume buttons will be smaller than 'default' buttons
		var downButton = new SmallButton(0, 0, "-", clickDown);
		add(downButton);
		
		var upButton = new SmallButton(0, downButton.y, "+", clickUp);
		upButton.x = width - upButton.width;
		add(upButton);
		
		var barWidth = Std.int(width - (4 + upButton.width) * 2);
		var barHeight = Std.int(upButton.height);
		bar = new FlxBar(downButton.x + downButton.width + 4, downButton.y, LEFT_TO_RIGHT, barWidth, barHeight);
		bar.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		add(bar);
		
		amountText = new FlxText(0, 0, 200, "100%", 8);
		amountText.alignment = CENTER;
		amountText.setBorderStyle(OUTLINE, 0xff464646);
		amountText.x = bar.x + (bar.width - amountText.width) / 2;
		amountText.y = bar.y + (bar.height - amountText.height) / 2;
		add(amountText);
		
		//
		this.x = x;
		this.y = y;
		setVolume(volume);
	}
	
	function clickDown()
	{
		setVolumeHelper(bar.value - 10);
	}
	
	function clickUp()
	{
		setVolumeHelper(bar.value + 10);
	}
	
	function setVolumeHelper(volume:Float, dispatch = true)
	{
		bar.value = Math.round(volume); // Note: bar.value is automatically clamped between 0 and 100
		amountText.text = label + " " + bar.value + "%";
		
		if (dispatch)
			onChange(bar.value / 100);
	}
	
	public function setVolume(volume:Float, dispatch = false)
	{
		setVolumeHelper(volume * 100, dispatch);
	}
	
	override function destroy()
	{
		// remove references but do not destroy
		bar = null;
		amountText = null;
		onChange = null;
		
		// this will actually destroy them
		super.destroy();
	}
}

/**
 * Helper class for creating an 80x20 button
 */
class Button extends FlxButton
{
	public function new (x, y, label, onClick)
	{
		super(x, y, label, onClick);
		
		loadGraphic(AssetPaths.button__png, true, 80, 20);
		onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
	}
}

/**
 * Helper class for creating small 20x20 buttons
 */
class SmallButton extends FlxButton
{
	public function new (x, y, label, onClick)
	{
		super(x, y, label, onClick);
		
		loadGraphic(AssetPaths.small_button__png, true, 20, 20);
		onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
	}
}