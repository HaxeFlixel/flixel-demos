package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalIFlxInput;
import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalKeyboard;
import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalGamepad;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;

/**
 * ...
 * @author .:BuzzJeux:.
 */
enum MoveDirection
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

class Player extends FlxSprite
{
	/**
	 * How big the tiles of the tilemap are.
	 */
	private static inline var TILE_SIZE:Int = 16;
	/**
	 * How many pixels to move each frame. Has to be a divider of TILE_SIZE 
	 * to work as expected (move one block at a time), because we use the
	 * modulo-operator to check whether the next block has been reached.
	 */
	private static inline var MOVEMENT_SPEED:Int = 2;
	
	/**
	 * Flag used to check if char is moving.
	 */ 
	public var moveToNextTile:Bool;
	/**
	 * Var used to hold moving direction.
	 */ 
	private var moveDirection:MoveDirection;
	
	private var up:FlxActionDigital;
	private var down:FlxActionDigital;
	private var left:FlxActionDigital;
	private var right:FlxActionDigital;
	
	private var _virtualPad:FlxVirtualPad;
	
	public function new(X:Int, Y:Int)
	{
		// X,Y: Starting coordinates
		super(X, Y);
		
		// Make the player graphic.
		makeGraphic(TILE_SIZE, TILE_SIZE, 0xffc04040);
		
		addInputs();
	}
	
	private function addInputs():Void
	{
		_virtualPad = new FlxVirtualPad(FULL, NONE);
		_virtualPad.alpha = 0.5;
		FlxG.state.add(_virtualPad);
		
		up    = new FlxActionDigital("up");
		down  = new FlxActionDigital("down");
		left  = new FlxActionDigital("left");
		right = new FlxActionDigital("right");
		
		//Add keyboard inputs
		up.addInput   (new FlxActionInputDigitalKeyboard(FlxKey.UP,    JUST_PRESSED));
		up.addInput   (new FlxActionInputDigitalKeyboard(FlxKey.W,     JUST_PRESSED));
		down.addInput (new FlxActionInputDigitalKeyboard(FlxKey.DOWN,  JUST_PRESSED));
		down.addInput (new FlxActionInputDigitalKeyboard(FlxKey.S,     JUST_PRESSED));
		left.addInput (new FlxActionInputDigitalKeyboard(FlxKey.LEFT,  JUST_PRESSED));
		left.addInput (new FlxActionInputDigitalKeyboard(FlxKey.A,     JUST_PRESSED));
		right.addInput(new FlxActionInputDigitalKeyboard(FlxKey.RIGHT, JUST_PRESSED));
		right.addInput(new FlxActionInputDigitalKeyboard(FlxKey.D,     JUST_PRESSED));
		
		//Add virtual pad (on-screen button) inputs
		up.addInput   (new FlxActionInputDigitalIFlxInput(_virtualPad.buttonUp,    JUST_PRESSED));
		down.addInput (new FlxActionInputDigitalIFlxInput(_virtualPad.buttonDown,  JUST_PRESSED));
		left.addInput (new FlxActionInputDigitalIFlxInput(_virtualPad.buttonLeft,  JUST_PRESSED));
		right.addInput(new FlxActionInputDigitalIFlxInput(_virtualPad.buttonRight, JUST_PRESSED));
		
		//Add gamepad DPAD inputs
		up.addInput   (new FlxActionInputDigitalGamepad(FlxGamepadInputID.DPAD_UP,    JUST_PRESSED));
		down.addInput (new FlxActionInputDigitalGamepad(FlxGamepadInputID.DPAD_DOWN,  JUST_PRESSED));
		left.addInput (new FlxActionInputDigitalGamepad(FlxGamepadInputID.DPAD_LEFT,  JUST_PRESSED));
		right.addInput(new FlxActionInputDigitalGamepad(FlxGamepadInputID.DPAD_RIGHT, JUST_PRESSED));
		
		//Add gamepad analog stick (as simulated DPAD) inputs
		up.addInput   (new FlxActionInputDigitalGamepad(FlxGamepadInputID.LEFT_STICK_DIGITAL_UP,     JUST_PRESSED));
		down.addInput (new FlxActionInputDigitalGamepad(FlxGamepadInputID.LEFT_STICK_DIGITAL_DOWN,   JUST_PRESSED));
		left.addInput (new FlxActionInputDigitalGamepad(FlxGamepadInputID.LEFT_STICK_DIGITAL_LEFT,   JUST_PRESSED));
		right.addInput(new FlxActionInputDigitalGamepad(FlxGamepadInputID.LEFT_STICK_DIGITAL_RIGHT,  JUST_PRESSED));
		up.addInput   (new FlxActionInputDigitalGamepad(FlxGamepadInputID.RIGHT_STICK_DIGITAL_UP,    JUST_PRESSED));
		down.addInput (new FlxActionInputDigitalGamepad(FlxGamepadInputID.RIGHT_STICK_DIGITAL_DOWN,  JUST_PRESSED));
		left.addInput (new FlxActionInputDigitalGamepad(FlxGamepadInputID.RIGHT_STICK_DIGITAL_LEFT,  JUST_PRESSED));
		right.addInput(new FlxActionInputDigitalGamepad(FlxGamepadInputID.RIGHT_STICK_DIGITAL_RIGHT, JUST_PRESSED));
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);  
		
		// Move the player to the next block
		if (moveToNextTile)
		{
			switch (moveDirection)
			{
				case UP:
					y -= MOVEMENT_SPEED;
				case DOWN:
					y += MOVEMENT_SPEED;
				case LEFT:
					x -= MOVEMENT_SPEED;
				case RIGHT:
					x += MOVEMENT_SPEED;
			}
		}
		
		// Check if the player has now reached the next block
		if ((x % TILE_SIZE == 0) && (y % TILE_SIZE == 0))
		{
			moveToNextTile = false;
		}
		
		if (down.check())
		{
			moveTo(MoveDirection.DOWN);
		}
		else if (up.check())
		{
			moveTo(MoveDirection.UP);
		}
		else if (left.check())
		{
			moveTo(MoveDirection.LEFT);
		}
		else if (right.check())
		{
			moveTo(MoveDirection.RIGHT);
		}
		
		/*
		if (_virtualPad.buttonDown.pressed)
		{
			moveTo(MoveDirection.DOWN);
		}
		else if (_virtualPad.buttonUp.pressed)
		{
			moveTo(MoveDirection.UP);
		}
		else if (_virtualPad.buttonLeft.pressed)
		{
			moveTo(MoveDirection.LEFT);
		}
		else if (_virtualPad.buttonRight.pressed)
		{
			moveTo(MoveDirection.RIGHT);
		}
		*/
		
		/*
		// Check for WASD or arrow key presses and move accordingly
		if (FlxG.keys.anyPressed([DOWN, S]))
		{
			moveTo(MoveDirection.DOWN);
		}
		else if (FlxG.keys.anyPressed([UP, W]))
		{
			moveTo(MoveDirection.UP);
		}
		else if (FlxG.keys.anyPressed([LEFT, A]))
		{
			moveTo(MoveDirection.LEFT);
		}
		else if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			moveTo(MoveDirection.RIGHT);
		}
		#end
		*/
	}
	
	public function moveTo(Direction:MoveDirection):Void
	{
		// Only change direction if not already moving
		if (!moveToNextTile)
		{
			moveDirection = Direction;
			moveToNextTile = true;
		}
	}
}
