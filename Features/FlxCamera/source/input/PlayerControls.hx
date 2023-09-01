package input;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.ui.FlxVirtualPad;

class PlayerControls
{
	/**
	 * Maps input types to their corresponding keyboard button
	 */
	static public var keyMap:Map<Input, Array<FlxKey>> =
	[
		Input.LEFT  => [FlxKey.A, FlxKey.LEFT ],
		Input.DOWN  => [FlxKey.S, FlxKey.DOWN ],
		Input.RIGHT => [FlxKey.D, FlxKey.RIGHT],
		Input.UP    => [FlxKey.W, FlxKey.UP   ]
	];
	
	#if FLX_GAMEPAD
	/**
	 * Maps input types to their corresponding gamepad dpad button
	 */
	static public var buttonMap:Map<Input, {dpad:FlxGamepadInputID, analog:FlxGamepadInputID}> =
	[
		Input.LEFT  => { dpad:DPAD_LEFT , analog:LEFT_STICK_DIGITAL_LEFT  },
		Input.DOWN  => { dpad:DPAD_DOWN , analog:LEFT_STICK_DIGITAL_DOWN  },
		Input.RIGHT => { dpad:DPAD_RIGHT, analog:LEFT_STICK_DIGITAL_RIGHT },
		Input.UP    => { dpad:DPAD_UP   , analog:LEFT_STICK_DIGITAL_UP    }
	];
	#end
	
	/**
	 * Reference to the gamepad controlling this orb
	 */
	public var virtualPad:VirtualPad = null;
	
	public function new()
	{
		// create a virtual pad to play on mobile devices
		final useVirtualPad = #if html5 FlxG.html5.onMobile #elseif mobile true #else false #end;
		if (useVirtualPad)
			virtualPad = new VirtualPad();
	}
	
	public function isGamepadConnected()
	{
		#if FLX_GAMEPAD
		return FlxG.gamepads.numActiveGamepads > 0;
		#else
		return false;
		#end
	}
	
	/**
	 * Helper to detect keyboard or virtual pad presses
	 */
	inline public function inputPressed(input:Input)
	{
		return keyPressed(input) || virtualPadPressed(input) || gamePadPressed(input);
	}
	
	/**
	 * Helper to detect keyboard presses
	 */
	inline function keyPressed(input:Input)
	{
		return FlxG.keys.anyPressed(keyMap[input]);
	}
	
	/**
	 * Helper to detect virtual pad presses
	 */
	inline function virtualPadPressed(input:Input)
	{
		return virtualPad != null && virtualPad.pressed(input);
	}
	
	/**
	 * Helper to detect gamepad presses
	 */
	inline function gamePadPressed(input:Input)
	{
		#if FLX_GAMEPAD
		final buttons = buttonMap[input];
		return FlxG.gamepads.anyPressed(buttons.dpad) || FlxG.gamepads.anyPressed(buttons.analog);
		#else
		return false;
		#end
	}
}

/**
 * Simplified virtual pad that takes an Input and returns whether the corresponding button is pressed
 */
abstract VirtualPad(FlxVirtualPad) from FlxVirtualPad to FlxVirtualPad
{
	inline public function new()
	{
		this = new FlxVirtualPad(FULL, NONE);
	}
	
	public function pressed(input:Input)
	{
		return switch(input)
		{
			case Input.LEFT : this.buttonLeft.pressed;
			case Input.RIGHT: this.buttonRight.pressed;
			case Input.UP   : this.buttonUp.pressed;
			case Input.DOWN : this.buttonDown.pressed;
			default: false;
		}
	}
}

enum Input
{
	LEFT;
	RIGHT;
	UP;
	DOWN;
}