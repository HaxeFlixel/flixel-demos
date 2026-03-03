package;

import flixel.math.FlxMath;
import flash.Lib;
import flixel.addons.ui.FlxSlider;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTileblock;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import shaders.*;

/**
 * @author Zaphod
 */
class PlayState extends FlxState
{
	public static var complex:Bool = false;
	public static var offScreen:Bool = false;
	public static var useShaders:Bool = false;
	public static var allowRotation:Bool = true;

	var _changeAmount:Int = 1000;
	var _times:Array<Float>;
	var _collisions:Bool = false;
	var _uiState:UIState = VISIBLE;

	var _background:FlxSprite;
	var _bunnies:FlxTypedGroup<Bunny>;
	var _uiOverlay:FlxSpriteGroup;
	var _complexityButton:FlxButton;
	var _collisionButton:FlxButton;
	var _timestepButton:FlxButton;
	var _offScreenButton:FlxButton;
	var _backgroundButton:FlxButton;
	var _rotationButton:FlxButton;
	var _bunnyCounter:FlxText;
	var _fpsCounter:FlxText;

	#if shaders_supported
	var _shaderButton:FlxButton;

	var floodFill = new FloodFill();
	var invert = new Invert();
	#end

	override public function create():Void
	{
		// The grass background
		var bgSize:Int = 32;
		var bgWidth:Int = Math.ceil(FlxG.width / bgSize) * bgSize;
		var bgHeight:Int = Math.ceil(FlxG.height / bgSize) * bgSize;

		var useAnimatedBackground = !FlxG.renderBlit;

		if (useAnimatedBackground)
		{
			_background = new Background();
			add(_background);
		}
		else
		{
			_background = new FlxTileblock(0, 0, bgWidth, bgHeight).loadTiles("assets/grass.png");
			add(_background);
		}

		var initialAmount = _changeAmount;
		var define = haxe.macro.Compiler.getDefine("bunnies");
		if (define != null)
			initialAmount = Std.parseInt(define);

		// Create the bunnies
		_bunnies = new FlxTypedGroup<Bunny>();
		changeBunnyNumber(true, initialAmount);
		add(_bunnies);

		// All the GUI stuff
		_uiOverlay = createOverlay();
		add(_uiOverlay);

		_times = [];
	}

	function createOverlay():FlxSpriteGroup
	{
		var overlay = new FlxSpriteGroup();

		var uiBackground = new FlxSprite();
		uiBackground.makeGraphic(FlxG.width, 105, FlxColor.WHITE);
		uiBackground.alpha = 0.7;
		overlay.add(uiBackground);

		// Left UI
		var amountSlider = new FlxSlider(this, "_changeAmount", 40, 5, 1, _changeAmount * 2);
		amountSlider.nameLabel.text = "Change amount by:";
		amountSlider.decimals = 0;
		overlay.add(amountSlider);

		overlay.add(new FlxButton(15, 65, "Remove", function() changeBunnyNumber(false, _changeAmount)));
		overlay.add(new FlxButton(100, 65, "Add", function() changeBunnyNumber(true, _changeAmount)));

		// Right UI
		// Column2 1
		var rightButtonX:Float = FlxG.width - 100;

		_complexityButton = new FlxButton(rightButtonX, 5, "Simple", onComplexityToggle);
		overlay.add(_complexityButton);

		_collisionButton = new FlxButton(rightButtonX, 30, "Collisons: Off", onCollisionToggle);
		overlay.add(_collisionButton);

		_rotationButton = new FlxButton(rightButtonX, 55, "Rotation: On", onRotationToggle);
		overlay.add(_rotationButton);

		// Column2
		rightButtonX -= 100;

		_timestepButton = new FlxButton(rightButtonX, 5, "Step: Fixed", onTimestepToggle);
		overlay.add(_timestepButton);

		_offScreenButton = new FlxButton(rightButtonX, 30, "On-Screen", onOffScreenToggle);
		overlay.add(_offScreenButton);

		#if shaders_supported
		_shaderButton = new FlxButton(rightButtonX, 55, "Shaders: Off", onShaderToggle);
		overlay.add(_shaderButton);
		#end

		_backgroundButton = new FlxButton(rightButtonX, 80, "BG: On", onBackgroundToggle);
		overlay.add(_backgroundButton);

		// The texts
		_bunnyCounter = new FlxText(0, 10, FlxG.width, "Bunnies: " + _bunnies.length);
		_bunnyCounter.setFormat(null, 22, FlxColor.BLACK, CENTER);
		overlay.add(_bunnyCounter);

		_fpsCounter = new FlxText(0, _bunnyCounter.y + _bunnyCounter.height + 20, FlxG.width, "FPS: " + 30);
		_fpsCounter.setFormat(null, 22, FlxColor.BLACK, CENTER);
		overlay.add(_fpsCounter);

		return overlay;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var time = FlxG.game.ticks;

		#if shaders_supported
		if (useShaders)
		{
			var floodFillY = 0.5 * (1.0 + Math.sin(time / 1000));
			floodFill.uFloodFillY.value = [floodFillY];
		}
		#end

		if (_collisions)
			FlxG.collide(_bunnies, _bunnies);

		var now:Float = time / 1000;
		_times.push(now);

		while (_times[0] < now - 1)
			_times.shift();

		_fpsCounter.text = "FPS: " + _times.length + "/" + Lib.current.stage.frameRate;

		#if FLX_KEYBOARD
		if (FlxG.keys.justPressed.SPACE)
			updateUIState();
		#end
	}

	function changeBunnyNumber(add:Bool, amount:Int):Void
	{
		for (i in 0...amount)
		{
			if (add)
			{
				var shader = null;
				#if shaders_supported
				shader = (i < _changeAmount / 2) ? floodFill : invert;
				#end

				// It's much slower to recycle objects, but keeps runtime costs of garbage collection low
				var bunny = new Bunny().init(offScreen, useShaders, shader, allowRotation);

				// Modify the members array directly to avoid lag with many bunnies due to searching for duplicates
				_bunnies.members.push(bunny);
				_bunnies.length++;
			}
			else
			{
				var bunny:Bunny = _bunnies.getFirstAlive();
				if (bunny != null)
				{
					// Modify the members array directly to avoid lag with many bunnies due to searching for duplicates
					_bunnies.members.remove(bunny);
					_bunnies.length--;
				}
			}
		}

		if (_bunnyCounter != null)
		{
			var bunnyAmount:Int = _bunnies.countLiving();
			if (bunnyAmount == -1)
				bunnyAmount = 0;
			_bunnyCounter.text = "Bunnies: " + bunnyAmount;
		}
	}

	function updateUIState():Void
	{
		_uiState = FlxMath.wrap(_uiState + 1, VISIBLE, HIDDEN);

		switch (_uiState)
		{
			case VISIBLE:
				_uiOverlay.exists = true;
				_fpsCounter.y = _bunnyCounter.y + _bunnyCounter.height + 20;
				_fpsCounter.setBorderStyle(NONE);

			case FPS_ONLY:
				for (ui in _uiOverlay)
				{
					if (ui == _fpsCounter)
						continue;

					ui.exists = false;
				}

				_fpsCounter.setBorderStyle(OUTLINE, FlxColor.WHITE, 2);
				_fpsCounter.y = 10;

			case HIDDEN:
				_uiOverlay.exists = false;
		}
	}

	function onComplexityToggle():Void
	{
		complex = !complex;
		toggleLabel(_complexityButton, "Complex", "Simple");

		for (bunny in _bunnies)
			if (bunny != null)
				bunny.complex = complex;
	}

	function onCollisionToggle():Void
	{
		_collisions = !_collisions;
		toggleLabel(_collisionButton, "Collisions: Off", "Collisions: On");
	}

	function onTimestepToggle():Void
	{
		FlxG.fixedTimestep = !FlxG.fixedTimestep;
		toggleLabel(_timestepButton, "Step: Fixed", "Step: Variable");
	}

	function onOffScreenToggle():Void
	{
		offScreen = !offScreen;
		toggleLabel(_offScreenButton, "On-Screen", "Off-Screen");

		for (bunny in _bunnies)
			if (bunny != null)
				bunny.init(offScreen, useShaders, null, allowRotation);
	}

	#if shaders_supported
	function onShaderToggle():Void
	{
		useShaders = !useShaders;
		toggleLabel(_shaderButton, "Shaders: Off", "Shaders: On");

		for (bunny in _bunnies)
			if (bunny != null)
				bunny.useShader = useShaders;
	}
	#end

	function onBackgroundToggle():Void
	{
		_background.exists = !_background.exists;
		toggleLabel(_backgroundButton, "BG: Off", "BG: On");
	}

	function onRotationToggle():Void
	{
		allowRotation = !allowRotation;
		toggleLabel(_rotationButton, "Rotation: Off", "Rotation: On");

		for (bunny in _bunnies)
			if (bunny != null)
				bunny.allowRotation = allowRotation;
	}

	function toggleLabel(button:FlxButton, text1:String, text2:String):Void
	{
		button.label.text = if (button.label.text == text1) text2 else text1;
	}
}

enum abstract UIState(Int) from Int to Int
{
	var VISIBLE = 0;
	var FPS_ONLY = 1;
	var HIDDEN = 2;
}
