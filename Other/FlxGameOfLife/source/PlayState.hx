package;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class PlayState extends FlxState
{
	// our colors
	public static inline var COLOR_BACK:FlxColor = 0xff000000;
	public static inline var COLOR_GRID:FlxColor = 0xff111111;
	public static inline var COLOR_ALIVE:FlxColor = 0xff33ff99;

	// our presets
	public static var PRESETS:Array<String> = [
		"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010001100001100000010000001100010000110000110001100011100100010000011000010010000011001010010010010010010100000001000000100001100100100000000001000011000010100010000000000000011000011000100000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000010000000000000000000000000000000000000000000000001101111011000000000000000000000000000000000000000000000000100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001110001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000101000010000000000000000000000000000000000000000000100001010000100000000000000000000000000000000000000000001000010100001000000000000000000000000000000000000000000000111000111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011100011100000000000000000000000000000000000000000000010000101000010000000000000000000000000000000000000000000100001010000100000000000000000000000000000000000000000001000010100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001110001110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		"1000000000100000000000000000000000000000000000000000000001100000000110000000000000000000000000000000000000000000110000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000110000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000001100000000000000000000000000000000000000000000000110000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101100000000000000000000000000000000000000000000000000100000100000000000000000000000000000000000000000000000001000000100110000000000000000000000000000000000000000000011100010001100000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000111000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	];

	// how big in tiles our map is
	public static inline var MAP_SIZE:Int = 56;

	// how big our tiles are
	public static inline var TILE_SIZE:Int = 8;

	// our map of life
	public var lifeMap:FlxTilemap;

	// which mode the mouse is in
	public var mouseMode:MouseMode = MouseMode.NONE;

	// the speed of the simulation
	public var speed:Int = 0;

	// whether the simulation is paused
	public var paused:Bool = false;

	// the different speeds we can use, in seconds
	public static var SPEEDS:Array<Float> = [1, .75, .25];

	// the text showing the current speed
	public static var SPEED_TEXT:Array<String> = ["||", ">", ">>", ">>>"];

	// text object that shows the current speed
	public var txtSpeed:FlxBitmapText;

	// the pause button (so we can change the label)
	public var btnPause:FlxButton;

	// the step button (so we can enable/disable)
	public var btnStep:FlxButton;

	// the last time we updated the simulation
	public var lastUpdate:Float = 0;

	override public function create()
	{
		FlxG.autoPause = false;
		
		bgColor = COLOR_BACK;

		initMouse();

		createMap();
		createHUD();
		makeGrid();

		setSpeed(1);

		super.create();
	}

	// initialize the mouse cursor
	private function initMouse():Void
	{
		FlxG.mouse.useSystemCursor = true;
	}

	// create our empty life map
	private function createMap():Void
	{
		var tiles:BitmapData = new BitmapData(Std.int(TILE_SIZE * 2), TILE_SIZE, false, COLOR_BACK);
		tiles.fillRect(new Rectangle(TILE_SIZE, 0, TILE_SIZE, TILE_SIZE), COLOR_ALIVE);

		add(lifeMap = new FlxTilemap());
		lifeMap.loadMapFromArray([for (i in 0...(MAP_SIZE * MAP_SIZE)) 0], MAP_SIZE, MAP_SIZE, tiles, TILE_SIZE, TILE_SIZE, FlxTilemapAutoTiling.OFF, 0, 0, 0);

		lifeMap.x = 8;
		lifeMap.y = 8;
	}

	// this function just draws gridlines for our tilemap
	private function makeGrid():Void
	{
		var bmpGrid:BitmapData = new BitmapData(MAP_SIZE * TILE_SIZE + 4, MAP_SIZE * TILE_SIZE + 4, true, 0x0);

		bmpGrid.lock();

		var fRect:Rectangle = new Rectangle(0, 0, bmpGrid.width, 1);

		bmpGrid.fillRect(fRect, COLOR_GRID);

		fRect = new Rectangle(0, 0, 1, bmpGrid.height);

		bmpGrid.fillRect(fRect, COLOR_GRID);

		fRect = new Rectangle(0, bmpGrid.height - 1, bmpGrid.width, 1);

		bmpGrid.fillRect(fRect, COLOR_GRID);

		fRect = new Rectangle(bmpGrid.width - 1, 0, 1, bmpGrid.height);

		bmpGrid.fillRect(fRect, COLOR_GRID);

		for (x in 0...MAP_SIZE + 1)
		{
			// draw horizontal line

			fRect = new Rectangle(0, 1 + (TILE_SIZE * x), bmpGrid.width, 2);
			bmpGrid.fillRect(fRect, COLOR_GRID);
			// draw vertical line
			fRect = new Rectangle(1 + (TILE_SIZE * x), 0, 2, bmpGrid.height);
			bmpGrid.fillRect(fRect, COLOR_GRID);
		}

		bmpGrid.unlock();

		var gridLines:FlxSprite = new FlxSprite(6, 6, bmpGrid);

		add(gridLines);
	}

	// create the hud with all our options and buttons, etc
	private function createHUD():Void
	{
		var startX:Int = Std.int(lifeMap.width + 16);
		var endX:Int = Std.int(FlxG.width - 8);
		var midX:Int = Std.int((endX - startX) / 2);
		var yPos:Float = 8;

		var txt:FlxBitmapText = new FlxBitmapText(startX, yPos, "SPEED");
		txt.scale.set(2, 2);
		txt.updateHitbox();
		txt.alignment = FlxTextAlign.CENTER;
		txt.x = startX + midX - (txt.width / 2);
		add(txt);

		yPos += txt.height + 4;

		// speed down button
		var btn:FlxButton = new FlxButton(0, yPos, "-", () ->
		{
			setSpeed(speed - 1);
		});
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 4;

		// current speed
		txt = new FlxBitmapText(startX, yPos, SPEED_TEXT[0]);
		txt.scale.set(2, 2);
		txt.updateHitbox();
		txt.alignment = FlxTextAlign.CENTER;
		txt.x = startX + midX - (txt.width / 2);
		add(txt);

		txtSpeed = txt;

		yPos += txt.height + 4;

		// speed up button
		btn = new FlxButton(startX, yPos, "+", () ->
		{
			setSpeed(speed + 1);
		});
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 4;

		// pause button
		btn = new FlxButton(startX, yPos, "PAUSE", pauseGame);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);
		btnPause = btn;

		yPos += btn.height + 4;

		// step button
		btn = new FlxButton(startX, yPos, "STEP", () -> updateSimulation(true));
		btn.x = startX + midX - (btn.width / 2);
		add(btn);
		btnStep = btn;
		btnStep.visible = false;

		yPos += btn.height + 16;

		// preset 1 button
		btn = new FlxButton(startX, yPos, "PRESET 1", selectPreset.bind(0));
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 4;

		// preset 2 button
		btn = new FlxButton(startX, yPos, "PRESET 2", selectPreset.bind(1));
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 4;

		// preset 3 button

		btn = new FlxButton(startX, yPos, "PRESET 3", selectPreset.bind(2));
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 16;

		// clear button
		btn = new FlxButton(startX, yPos, "CLEAR", clearMap);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 16;

		// show rules button
		btn = new FlxButton(startX, yPos, "RULES", showRules);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		// yPos += btn.height + 16;

		// export button
		// btn = new FlxButton(startX, yPos, "EXPORT", () ->
		// {
		// 	var str:String = "";
		// 	for (y in 0...MAP_SIZE)
		// 	{
		// 		for (x in 0...MAP_SIZE)
		// 		{
		// 			str += lifeMap.getTile(x, y);
		// 		}
		// 	}
		// 	trace(str);
		// });
		// btn.x = startX + midX - (btn.width / 2);
		// add(btn);
	}

	/**
	 * sets the speed of the simulation
	 * @param Value	the speed to set it to 
	 */
	private function setSpeed(Value:Int):Void
	{
		if (Value <= 0 || Value > SPEEDS.length || paused)
		{
			return;
		}
		speed = Value;

		showSpeedAmount();
	}

	/**
	 * updates the text showing the current speed
	 */
	private function showSpeedAmount()
	{
		if (paused)
			txtSpeed.text = SPEED_TEXT[0];
		else
			txtSpeed.text = SPEED_TEXT[speed];
	}

	/**
	 * clears the map
	 */
	private function clearMap():Void
	{
		for (i in 0...(MAP_SIZE * MAP_SIZE))
		{
			lifeMap.setTile(i % MAP_SIZE, Std.int(i / MAP_SIZE), 0);
		}
	}

	/**
	 * toggles the paused state of the game
	 */
	private function pauseGame():Void
	{
		paused = !paused;
		btnPause.label.text = paused ? "UNPAUSE" : "PAUSE";
		btnStep.visible = paused;
		showSpeedAmount();
	}

	/**
	 * replaces the current map with a preset
	 * @param preset which preset to use
	 */
	private function selectPreset(preset:Int):Void
	{
		if (preset < 0 || preset >= PRESETS.length)
			return;

		var str:String = PRESETS[preset];

		for (i in 0...str.length)
		{
			lifeMap.setTile(i % MAP_SIZE, Std.int(i / MAP_SIZE), Std.parseInt(str.charAt(i)));
		}
		lastUpdate = FlxG.game.ticks;
	}

	/**
	 * shows the rules of the game of life
	 */
	private function showRules():Void
	{
		openSubState(new RulesState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		updateMouse();

		updateSimulation();
	}

	/**
	 * update the simulation by 1 step - if enough time has passed
	 */
	private function updateSimulation(?Force:Bool = false):Void
	{
		if ((paused || lastUpdate + (SPEEDS[speed] * 1000) > FlxG.game.ticks) && !Force)
			return;

		lastUpdate = FlxG.game.ticks;

		// run the simulation

		var newGen:Array<Int> = []; // initialize a new array for the next generation

		// loop through each tile in the map
		for (y in 0...MAP_SIZE)
		{
			for (x in 0...MAP_SIZE)
			{
				var count:Int = 0;

				for (yy in -1...2)
				{
					for (xx in -1...2)
					{
						if (xx == 0 && yy == 0)
							continue;

						var nx:Int = x + xx;
						var ny:Int = y + yy;

						if (nx < 0 || ny < 0 || nx >= MAP_SIZE || ny >= MAP_SIZE)
							continue;

						// count all the living neighbors of this tile
						if (lifeMap.getTile(nx, ny) == 1)
							count++;
					}
				}

				var tile:Int = lifeMap.getTile(x, y);

				if (tile == 1) // if this tile is alive
				{
					if (count < 2 || count > 3) // and has too few or too many neighbors
						tile = 0; // it will not be alive in the next generation
				}
				else if (count == 3) // if it is not alive and has exactly 3 neighbors
					tile = 1; // it becomes alive in the next generation

				newGen.push(tile); // add this tile to the next generation
			}
		}

		// now loop through the new generation and replace the old generation with it
		for (i in 0...newGen.length)
		{
			lifeMap.setTile(i % MAP_SIZE, Std.int(i / MAP_SIZE), newGen[i]);
		}
	}

	var mPosOffPrev:FlxPoint;

	/**
	 * check on what the player is doing with the mouse
	 */
	private function updateMouse():Void
	{
		final mPos:FlxPoint = FlxG.mouse.getWorldPosition();
		if (mPos.x >= lifeMap.x && mPos.y >= lifeMap.y && mPos.x < lifeMap.x + lifeMap.width && mPos.y < lifeMap.y + lifeMap.height)
		{
			// if the mouse is over the lifeMap, get the tile it is over
			final mPosOff = FlxPoint.get((mPos.x - lifeMap.x) / TILE_SIZE, (mPos.y - lifeMap.y) / TILE_SIZE);

			// if the player just pressed the mouse, set the mouse mode to paint or erase mode, depending on the tile they clicked on
			if (FlxG.mouse.justPressed)
			{
				mouseMode = lifeMap.getTile(Std.int(mPosOff.x), Std.int(mPosOff.y)) == 0 ? PAINT : ERASE;
			}
			else if (FlxG.mouse.pressed) // if the player is pressing the mouse, paint or erase the tile they are over, based on their mode
			{
				lifeMap.setTile(Std.int(mPosOff.x), Std.int(mPosOff.y), mouseMode == PAINT ? 1 : 0);

				if (mPosOffPrev != null)
				{
					// if the player is dragging the mouse, paint or erase all the tiles between the last tile they were over and the current tile

					for (points in getLine(Std.int(mPosOffPrev.x), Std.int(mPosOffPrev.y), Std.int(mPosOff.x), Std.int(mPosOff.y)))
						lifeMap.setTile(points.x, points.y, mouseMode == PAINT ? 1 : 0);
				}
				else
					mPosOffPrev = FlxPoint.get();
				
				mPosOffPrev.copyFrom(mPosOff);
			}
			else if (FlxG.mouse.released)
			{
				// if the player released the mouse, set the mode to none
				mouseMode = NONE;
				mPosOffPrev = FlxDestroyUtil.put(mPosOffPrev);
			} 
			updateMouseCursor(true);
			mPosOff.put();
		}
		else
		{
			mouseMode = NONE;
			updateMouseCursor(false);
		}
		mPos.put();
	}

	/**
	 * Implementation of Bresenham algorithm
	 * From deepknight! https://deepnight.net/tutorial/bresenham-magic-raycasting-line-of-sight-pathfinding/
	 */
	function getLine(x0:Int, y0:Int, x1:Int, y1:Int):Array<{x:Int, y:Int}> {
		var pts = [];
		var swapXY = Math.abs( y1 - y0 ) > Math.abs( x1 - x0 );
		var tmp : Int;
		if ( swapXY ) {
			// swap x and y
			tmp = x0; x0 = y0; y0 = tmp; // swap x0 and y0
			tmp = x1; x1 = y1; y1 = tmp; // swap x1 and y1
		}
	
		if ( x0 > x1 ) {
			// make sure x0 < x1
			tmp = x0; x0 = x1; x1 = tmp; // swap x0 and x1
			tmp = y0; y0 = y1; y1 = tmp; // swap y0 and y1
		}
	
		var deltax = x1 - x0;
		var deltay = Math.floor( Math.abs( y1 - y0 ) );
		var error = Math.floor( deltax / 2 );
		var y = y0;
		var ystep = if ( y0 < y1 ) 1 else -1;
		if( swapXY )
			// Y / X
			for ( x in x0 ... x1+1 ) {
				pts.push({x:y, y:x});
				error -= deltay;
				if ( error < 0 ) {
					y = y + ystep;
					error = error + deltax;
				}
			}
		else
			// X / Y
			for ( x in x0 ... x1+1 ) {
				pts.push({x:x, y:y});
				error -= deltay;
				if ( error < 0 ) {
					y = y + ystep;
					error = error + deltax;
				}
			}
		return pts;
	
	} 

	/**
	 * updates the mouse cursor based on the mode
	 * @param OverMap whether the mouse is over the map or not
	 */
	private function updateMouseCursor(OverMap:Bool):Void
	{
		Mouse.cursor = OverMap ? lime.ui.MouseCursor.CROSSHAIR : MouseCursor.AUTO;
	}
}

enum MouseMode
{
	NONE;
	PAINT;
	ERASE;
}

class RulesState extends FlxSubState
{
	// the rules!
	public static var RULES:Array<String> = [
		"Every 'step', all the cells in the grid are checked to see if they should be alive or dead in the next generation using the following criteria:",
		" - Any live cell with fewer than two live neighbours dies",
		" + Any live cell with two or three live neighbours lives on",
		" - Any live cell with more than three live neighbours dies",
		" + Any dead cell with exactly three live neighbours becomes a live cell"
	];

	override public function create()
	{
		bgColor = 0x99000000;

		var back:FlxSprite = new FlxSprite();
		back.makeGraphic(FlxG.width - 68, FlxG.height - 68, FlxColor.WHITE);
		back.pixels.fillRect(new Rectangle(4, 4, back.width - 8, back.height - 8), FlxColor.BLACK);
		back.screenCenter();

		add(back);

		var txt:FlxBitmapText = new FlxBitmapText(0, back.y + 20, "CONWAY'S GAME OF LIFE");
		txt.alignment = FlxTextAlign.CENTER;
		txt.scale.set(4, 4);
		txt.updateHitbox();
		txt.screenCenter(FlxAxes.X);
		add(txt);

		txt = new FlxBitmapText(0, txt.y + txt.height + 8, "-+- RULES -+-");
		txt.alignment = FlxTextAlign.CENTER;
		txt.scale.set(3, 3);
		txt.updateHitbox();
		txt.screenCenter(FlxAxes.X);
		add(txt);


		var yPos:Float = txt.y + txt.height + 8;

		for (rule in RULES)
		{
			txt = new FlxBitmapText(back.x + 20, yPos, rule);
			txt.alignment = FlxTextAlign.LEFT;
			txt.fieldWidth = Std.int((back.width - 40) / 2.5);
			txt.wrap = WORD(LINE_WIDTH);
			txt.autoSize = false;

			txt.scale.set(2.5, 2.5);
			txt.updateHitbox();

			add(txt);

			yPos += txt.height + 4;
		}

		var btn:FlxButton = new FlxButton(0, 0, "CLOSE", close);
		btn.x = back.x + back.width - btn.width - 20;
		btn.y = back.y + back.height - btn.height - 20;
		add(btn);

		super.create();
	}
}
