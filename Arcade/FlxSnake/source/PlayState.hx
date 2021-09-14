package;

import flixel.util.FlxDirection;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * FlxSnake for Flixel 2.23 - 19th March 2010
 * Ported to HaxeFlixel
 *
 * Cursor keys to move. Red squares are fruit. Snake can wrap around screen edges.
 * @author Richard Davey, Photon Storm <rich@photonstorm.com>
 *
 * Largely rewritten by @author Gama11
 */
class PlayState extends FlxState
{
	static inline var MIN_INTERVAL:Float = 2;
	static inline var BLOCK_SIZE:Int = 8;

	var _scoreText:FlxText;
	var _fruit:FlxSprite;
	var _snakeHead:FlxSprite;
	var _snakeBody:FlxSpriteGroup;

	var _headPositions:Array<FlxPoint>;
	var _movementInterval:Float = 8;
	var _score:Int = 0;

	var _currentDirection = FlxDirection.LEFT;
	var _nextDirection = FlxDirection.LEFT;

	override public function create():Void
	{
		FlxG.mouse.visible = false;

		// Get the head piece from the body For easy later reference, and also visually change the colour a little
		var screenMiddleX:Int = Math.floor(FlxG.width / 2);
		var screenMiddleY:Int = Math.floor(FlxG.height / 2);

		// Start by creating the head of the snake
		_snakeHead = new FlxSprite(screenMiddleX - BLOCK_SIZE * 2, screenMiddleY);
		_snakeHead.makeGraphic(BLOCK_SIZE - 2, BLOCK_SIZE - 2, FlxColor.LIME);
		offestSprite(_snakeHead);

		// This array stores the recent head positions to update the segment positions step by step
		_headPositions = [FlxPoint.get(_snakeHead.x, _snakeHead.y)];

		// The group holding the body segments
		_snakeBody = new FlxSpriteGroup();
		add(_snakeBody);

		// Add 3 body segments to start off
		for (i in 0...3)
		{
			addSegment();
			// Move the snake to attach the segment to the head
			moveSnake();
		}

		// Add the snake's head last so it's on top
		add(_snakeHead);

		// Something to eat. We only ever need one fruit, we can just reposition it.
		_fruit = new FlxSprite();
		_fruit.makeGraphic(BLOCK_SIZE - 2, BLOCK_SIZE - 2, FlxColor.RED);
		randomizeFruitPosition();
		offestSprite(_fruit);
		add(_fruit);

		// Simple score
		_scoreText = new FlxText(0, 0, 200, "Score: " + _score);
		add(_scoreText);

		// Setup the movement timer
		resetTimer();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Just a little fading effect for the score text
		if (_scoreText.alpha < 1)
		{
			_scoreText.alpha += 0.1;
		}

		// Only continue if we're still alive
		if (!_snakeHead.alive)
		{
			if (FlxG.keys.anyJustReleased([SPACE, R]))
			{
				FlxG.resetState();
			}

			return;
		}

		// Did we eat the fruit?
		FlxG.overlap(_snakeHead, _fruit, collectFruit);

		// Did we hit ourself? If so, game over! :(
		FlxG.overlap(_snakeHead, _snakeBody, gameOver);

		// WASD / arrow keys to control the snake
		// Also make sure you can't travel in the opposite direction,
		// because that causes quick and frustrating deaths!
		if (FlxG.keys.anyPressed([UP, W]) && _currentDirection != DOWN)
		{
			_nextDirection = UP;
		}
		else if (FlxG.keys.anyPressed([DOWN, S]) && _currentDirection != UP)
		{
			_nextDirection = DOWN;
		}
		else if (FlxG.keys.anyPressed([LEFT, A]) && _currentDirection != RIGHT)
		{
			_nextDirection = LEFT;
		}
		else if (FlxG.keys.anyPressed([RIGHT, D]) && _currentDirection != LEFT)
		{
			_nextDirection = RIGHT;
		}
	}

	/**
	 * To get a nice little 2px gap between the tiles
	 */
	function offestSprite(Sprite:FlxSprite):Void
	{
		Sprite.offset.set(1, 1);
		Sprite.centerOffsets();
	}

	function updateText(NewText:String):Void
	{
		_scoreText.text = NewText;
		_scoreText.alpha = 0;
	}

	function collectFruit(Object1:FlxObject, Object2:FlxObject):Void
	{
		// Update the score
		_score += 10;
		updateText("Score: " + _score);

		randomizeFruitPosition();

		// Our reward - a new segment! :)
		addSegment();
		FlxG.sound.load(FlxAssets.getSound("flixel/sounds/beep")).play();

		// Become faster each pickup - set a max speed though!
		if (_movementInterval >= MIN_INTERVAL)
		{
			_movementInterval -= 0.25;
		}
	}

	function randomizeFruitPosition(?Object1:FlxObject, ?Object2:FlxObject):Void
	{
		// Pick a random place to put the fruit down
		_fruit.x = FlxG.random.int(0, Math.floor(FlxG.width / 8) - 1) * 8;
		_fruit.y = FlxG.random.int(0, Math.floor(FlxG.height / 8) - 1) * 8;

		// Check that the coordinates we picked aren't already covering the snake, if they are then run this function again
		FlxG.overlap(_fruit, _snakeBody, randomizeFruitPosition);
	}

	function gameOver(Object1:FlxObject, Object2:FlxObject):Void
	{
		_snakeHead.alive = false;
		updateText("Game Over - Space to restart!");
		FlxG.sound.play("assets/flixel.wav");
	}

	function addSegment():Void
	{
		// Spawn the new segment outside of the screen
		// It'll be attached to the snake end in the next moveSnake() call
		var segment:FlxSprite = new FlxSprite(-20, -20);
		segment.makeGraphic(BLOCK_SIZE - 2, BLOCK_SIZE - 2, FlxColor.GREEN);
		_snakeBody.add(segment);
	}

	function resetTimer(?Timer:FlxTimer):Void
	{
		// Stop the movement cycle if we're dead
		if (!_snakeHead.alive && Timer != null)
		{
			Timer.destroy();
			return;
		}

		new FlxTimer().start(_movementInterval / FlxG.updateFramerate, resetTimer);
		moveSnake();
	}

	function moveSnake():Void
	{
		_headPositions.unshift(FlxPoint.get(_snakeHead.x, _snakeHead.y));

		if (_headPositions.length > _snakeBody.members.length)
		{
			_headPositions.pop();
		}

		// Update the position of the head
		switch (_nextDirection)
		{
			case LEFT:
				_snakeHead.x -= BLOCK_SIZE;
			case RIGHT:
				_snakeHead.x += BLOCK_SIZE;
			case UP:
				_snakeHead.y -= BLOCK_SIZE;
			case DOWN:
				_snakeHead.y += BLOCK_SIZE;
		}
		_currentDirection = _nextDirection;

		FlxSpriteUtil.screenWrap(_snakeHead);

		for (i in 0..._headPositions.length)
		{
			_snakeBody.members[i].setPosition(_headPositions[i].x, _headPositions[i].y);
		}
	}
}
