package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.path.FlxPath;
import flixel.path.FlxPathfinder;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
// import openfl.Assets;

class PlayState extends FlxState
{
	/**
	 * Unit move speed
	 */
	static inline var MOVE_SPEED:Int = 50;

	static inline var INSTRUCTIONS = "Click in map to place or remove a tile.";

	/**
	 * Map
	 */
	var map:Tilemap;

	/**
	 * Goal sprite
	 */
	var goal:FlxSprite;

	/**
	 * Unit sprite
	 */
	var unit:FlxSprite;

	/**
	 * Unit action
	 */
	var action:Action = IDLE;

	// pathfinder settings
	var pathfinder = new BigMoverPathfinder(1, 1, WIDE);
	var diagonalPolicy:FlxTilemapDiagonalPolicy = WIDE;
	var simplify = FlxPathSimplifier.LINE;
	var size = Size.S1_1;

	/**
	 * Button to move unit to Goal
	 */
	var startStopButton:FlxButton;

	/**
	 * Button to reset unit to start point
	 */
	var resetUnitButton:FlxButton;

	/**
	 * Button to set the unit to immovable
	 */
	var immovableButton:ImmovableButton;

	/**
	 * Button to set the path simlifier
	 */
	var simplifyButton:SimplifyButton;

	/**
	 * Button to set the path simlifier
	 */
	var clearButton:FlxButton;

	/**
	 * Button to set the unit's size
	 */
	var sizeButton:SizeButton;

	/**
	 * Instructions
	 */
	var instructions:FlxText;

	/**
	 * Whether the user is adding tiles or removing them
	 */
	var isPlacing = false;

	override public function create():Void
	{
		// FlxG.camera.bgColor = 0xFF639bff;

		// Load the map data to map and add to PlayState
		map = new Tilemap("assets/map2.png");
		add(map);

		// Add a visual seperation between map and GUI
		var seperator:FlxSprite = new FlxSprite(map.width, 0);
		seperator.makeGraphic(Std.int(FlxG.width - seperator.width), FlxG.height, FlxColor.GRAY);
		add(seperator);

		// Set goal coordinate and add goal to PlayState
		goal = new FlxSprite();
		goal.makeGraphic(map.tileSize, map.tileSize, 0xffffff00);
		goal.x = map.width - map.tileSize * 2;
		goal.y = map.height - map.tileSize * 2;
		add(goal);

		// Set and add unit to PlayState
		unit = new FlxSprite(0, 0);
		unit.makeGraphic(map.tileSize, map.tileSize, 0xffff0000);
		action = IDLE;
		unit.path = new FlxPath();
		unit.path.immovable = false;
		add(unit);

		var buttonX = FlxG.width - 90;
		var uiY = 10;

		// Add button move to goal to PlayState
		startStopButton = new FlxButton(buttonX, uiY, "Move To Goal", 
			function startStopPress()
			{
				switch (action)
				{
					case IDLE: moveToGoal();
					case GO  : stopUnit();
				}
				
				startStopButton.text = switch (action)
				{
					case IDLE: "Move To Goal";
					case GO  : "Stop Unit";
				}
			}
		);
		add(startStopButton);
		uiY += 20;

		// Add button reset unit to PlayState
		resetUnitButton = new FlxButton(buttonX, uiY, "Reset Unit", resetUnit);
		add(resetUnitButton);
		uiY += 20;

		// Add button reset unit to PlayState
		immovableButton = new ImmovableButton(buttonX, uiY, unit.path.immovable,
			function toggleImmovable(immovable)
			{
				unit.path.immovable = immovable;
			}
		);
		add(immovableButton);
		uiY += 20;

		// Add button reset unit to PlayState
		simplifyButton = new SimplifyButton(buttonX, uiY, simplify,
			function onSimplifyChange(simplify)
			{
				this.simplify = switch (simplify)
				{
					case RAY_BOX(_, _): RAY_BOX(unit.width, unit.height);
					default: simplify;
				}

				redrawPath();
			}
		);
		add(simplifyButton);
		uiY += 20;

		// Add button reset unit to PlayState

		sizeButton = new SizeButton(buttonX, uiY, size,
			function onSizeChange(size:Size)
			{
				this.size = size;
				pathfinder.widthInTiles = size.widthInTiles;
				pathfinder.heightInTiles = size.heightInTiles;

				// set unit size
				unit.scale.x = goal.scale.x = size.widthInTiles;
				unit.scale.y = goal.scale.y = size.heightInTiles;
				unit.updateHitbox();
				goal.updateHitbox();

				if (simplify.match(RAY_BOX(_, _)))
					simplify = RAY_BOX(unit.width, unit.height);

				redrawPath();
			}
		);
		add(sizeButton);
		uiY += 20;

		// Add button reset unit to PlayState
		clearButton = new FlxButton(buttonX, uiY, "Clear Map",
			function clearMap()
			{
				for (i in 0...map.totalTiles)
					map.setTileByIndex(i, 0);
				
				redrawPath();
			}
		);
		add(clearButton);
		uiY += 20;

		// Add some texts
		var textWidth:Int = 85;
		var textX:Int = FlxG.width - textWidth - 5;
		uiY += 20; // gap between buttons and text

		instructions = new FlxText(textX, uiY, textWidth, INSTRUCTIONS);
		add(instructions);
		uiY += 20;

		var legends:FlxText = new FlxText(textX, 0, textWidth, "Legends:\nRed: Unit\nYellow: Goal\nGreen: Wall\nWhite: Path");
		legends.y = FlxG.height - legends.height - 8;
		add(legends);
	}

	override public function destroy():Void
	{
		super.destroy();

		map = null;
		goal = null;
		unit = null;
		startStopButton = null;
		resetUnitButton = null;
		instructions = null;
	}

	override public function draw():Void
	{
		super.draw();

		// To draw path
		if (unit.path != null && !unit.path.finished)
		{
			unit.drawDebug();
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Set unit to collide with map
		FlxG.collide(unit, map);

		var mapChanged = false;

		// Check mouse pressed and unit action
		if (FlxG.mouse.pressed)
		{
			var index = map.getTileIndexByCoords(FlxG.mouse.getWorldPosition());
			if (index != -1)
			{
				var tileEmpty = map.getTileByIndex(index) == 0;
				if (FlxG.mouse.justPressed)
				{
					// start toggle tiles
					isPlacing = tileEmpty;
					map.setTileByIndex(index, isPlacing ? 1 : 0, true);

					mapChanged = true;
				}
				else if (tileEmpty == isPlacing)
				{
					// continue toggling tiles on mouse drag
					map.setTileByIndex(index, isPlacing ? 1 : 0, true);

					mapChanged = true;
				}
			}
		}

		if (action == GO)
		{
			// Check if reach goal
			if (unit.path.finished)
				resetUnit();
			// update the path when the map changes
			else if (mapChanged)
				redrawPath();
		}
	}

	function redrawPath()
	{
		if (action == GO)
		{
			stopUnit();
			moveToGoal();
		}
	}

	function moveToGoal():Void
	{
		// Find path to goal from unit to goal
		pathfinder.diagonalPolicy = diagonalPolicy;
		var pathPoints:Array<FlxPoint> = pathfinder.findPath(
			cast map,
			FlxPoint.get(unit.x + unit.width / 2, unit.y + unit.height / 2),
			FlxPoint.get(goal.x + goal.width / 2, goal.y + goal.height / 2),
			simplify
		);

		// Tell unit to follow path
		if (pathPoints != null)
		{
			unit.path.start(pathPoints);
			action = GO;
			instructions.text = INSTRUCTIONS;
		}
		else
		{
			instructions.text = INSTRUCTIONS + "\n\nNo path found!";
		}
	}

	function stopUnit():Void
	{
		// Stop unit and destroy unit path
		action = IDLE;
		unit.path.cancel();
		unit.velocity.x = unit.velocity.y = 0;
	}

	function resetUnit():Void
	{
		// Reset unit position
		unit.x = 0;
		unit.y = 0;

		// Stop unit
		if (action == GO)
		{
			stopUnit();
		}
	}
}


private enum abstract Action(Int)
{
	var IDLE = 0;
	var GO = 1;
}

private enum abstract Size(Int)
{
	var S1_1 = 0;//Bx00
	var S1_2 = 1;//Bx01
	var S2_1 = 2;//Bx10
	var S2_2 = 3;//Bx11

	/**
	 * The width of the size, in tiles
	 */
	public var widthInTiles(get, never):Int;
	inline function get_widthInTiles()
	{
		return (this & 1) + 1;
	}

	/**
	 * The height of the size, in tiles
	 */
	public var heightInTiles(get, never):Int;
	inline function get_heightInTiles()
	{
		return ((this & 2) >> 1) + 1;
	}
}

@:forward
private abstract Tilemap(FlxTilemap) from FlxTilemap to FlxTilemap
{
	/**
	 * Tile width and height
	 */
	static inline var TILE_SIZE:Int = 16;

	public var tileSize(get, never):Int;

	inline function get_tileSize()
	{
		return TILE_SIZE;
	}

	inline public function new(mapData:String)
	{
		this = new FlxTilemap();
		this.loadMapFromGraphic(
			mapData,
			false, // invert
			1, // scale
			null, // colorMap
			FlxGraphic.fromClass(GraphicAutoFull),
			TILE_SIZE, // tile_width
			TILE_SIZE, // tile_height
			FULL, // autoTile
			0, // startingIndex
			1 // drawIndex
		);
	}
}

/**
 * Helper button that enumerates certain `FlxPathSimplifier` values and updates the
 * label to show the currently selected value.
 */
private abstract ImmovableButton(FlxButton) to FlxButton
{
	public function new(x:Float, y:Float, immovable:Bool, ?callback:(Bool)->Void)
	{
		this = null;
		function updateLabel()
		{
			this.text = immovable ? "Immovable" : "Colliding";
		}
		
		function onClick()
		{
			immovable = !immovable;

			updateLabel();

			if (callback != null)
				callback(immovable);
		}
		
		this = new FlxButton(x, y, "", onClick);
		updateLabel();
	}
}

/**
 * Helper button that enumerates certain `FlxPathSimplifier` values and updates the
 * label to show the currently selected value.
 */
private abstract SimplifyButton(FlxButton) to FlxButton
{
	public function new(x:Float, y:Float, simplify:FlxPathSimplifier, ?callback:(FlxPathSimplifier)->Void)
	{
		this = null;
		function updateLabel()
		{
			this.text = "Simplify:" + switch (simplify)
			{
				case NONE         : "NONE";
				case LINE         : "LINE";
				case RAY          : "RAY";
				case RAY_STEP(_)  : "STEP";
				case RAY_BOX(_, _): "BOX";
				default: throw "Invalid simplify";
			};
		}
		
		function onClick()
		{
			simplify = switch (simplify)
			{
				case NONE         : LINE;
				case LINE         : RAY;
				case RAY          : RAY_BOX(0, 0);
				case RAY_BOX(_, _): NONE;
				default: throw "Invalid simplify";
			};

			updateLabel();

			if (callback != null)
				callback(simplify);
		}
		
		this = new FlxButton(x, y, "", onClick);
		updateLabel();
	}
}

/**
 * Helper button that enumerates all possible size values and updates the
 * label to show the currently selected value.
 */
private abstract SizeButton(FlxButton) to FlxButton
{
	public function new (x:Float, y:Float, size:Size, ?callback:(Size)->Void)
	{
		this = null;
		function updateLabel()
		{
			this.text = "Unit Size:" + switch (size)
			{
				case S1_1: "1x1";
				case S1_2: "1x2";
				case S2_1: "2x1";
				case S2_2: "2x2";
			};
		}
		
		function onClick()
		{
			size = switch (size)
			{
				case S1_1: S1_2;
				case S1_2: S2_1;
				case S2_1: S2_2;
				case S2_2: S1_1;
			};

			updateLabel();

			if (callback != null)
				callback(size);
		}
		
		this = new FlxButton(x, y, "", onClick);
		updateLabel();
	}
}
