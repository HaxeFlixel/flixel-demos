package;

import flixel.addons.util.FlxAsyncLoop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColorUtil;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;


/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	// initializing some things we'll need
	private var _grpProgress:FlxGroup;
	private var _grpFinished:FlxGroup;
	private var _loopOne:FlxAsyncLoop;
	private var _maxItems:Int = 5000;
	private var _bar:FlxBar;
	private var _barText:FlxText;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		// set up our groups - one will show a progress bar, the other will hold all the things we're loading
		_grpProgress = new FlxGroup();
		_grpFinished = new FlxGroup(_maxItems);
		
		// setup our loop
		_loopOne = new FlxAsyncLoop(_maxItems, addItem, 100);
		
		// create a fancy progress bar
		_bar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, FlxG.width - 50, 50, null, "", 0, 100, true);
		_bar.currentValue = 0;
		FlxSpriteUtil.screenCenter(_bar);
		_grpProgress.add(_bar);
		
		// some text for the bar
		_barText = new FlxText(0, 0, FlxG.width, "Loading... 0 / " + _maxItems);
		_barText.setFormat(null, 28, 0xffffff, "center", FlxText.BORDER_OUTLINE, 0x000000);
		FlxSpriteUtil.screenCenter(_barText);
		_grpProgress.add(_barText);
		
		// only our progress bar group should be getting draw() and update() called on it until the loop is done...
		_grpFinished.visible = false;
		_grpFinished.active = false;
		
		add(_grpProgress);
		add(_grpFinished);
		
		// add our loop, so that it gets updated
		add(_loopOne);
		
		super.create();
	}
	
	public function addItem():Void
	{	
		// each iteration of our loop, we just create a 10x10 FlxSprite in a random x, y position and random color
		_grpFinished.add(new FlxSprite(FlxRandom.intRanged(0, FlxG.width), FlxRandom.intRanged(0, FlxG.height)).makeGraphic(10, 10, FlxColorUtil.getRandomColor(0, 255, 255)));
		// then we update our progress bar and progress bar text
		_bar.currentValue = (_grpFinished.members.length / _maxItems) * 100;
		_barText.text = "Loading... " + _grpFinished.members.length + " / " + _maxItems;
		FlxSpriteUtil.screenCenter(_barText);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		// If my loop hasn't started yet, start it
		if (!_loopOne.started)
		{
			_loopOne.start();
		}
		else
		{
			// if the loop has been started, and is finished, then we swich which groups are active
			if (_loopOne.finished)
			{
				_grpFinished.visible = true;
				_grpProgress.visible = false;
				_grpFinished.active = true;
				_grpProgress.active = false;
				
				//clean up our loop
				_loopOne.kill();
				_loopOne.destroy(); 
			}
		}
		
		super.update();
	}
	
}