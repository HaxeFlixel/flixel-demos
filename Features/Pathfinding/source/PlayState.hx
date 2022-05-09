package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.path.FlxPath;
import flixel.path.FlxPathfinder;
import flixel.text.FlxText;
import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDirectionFlags;
import openfl.Assets;

class PlayState extends FlxState
{
	/**
	 * Unit move speed
	 */
	static inline var MOVE_SPEED:Int = 50;

	static inline var INSTRUCTIONS = "Click in map to place or remove a tile.";
	static inline var NO_PATH_FOUND = "No path found!";
	static inline var MOVE_TO_GOAL = "Move To Goal";
	static inline var STOP_UNIT = "Stop unit";

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
	var immovableButton:FlxButton;

	/**
	 * Button to set the path simlifier
	 */
	var simplifyButton:FlxButton;

	/**
	 * Button to set the path simlifier
	 */
	var clearButton:FlxButton;

	/**
	 * Button to set the unit's size
	 */
	var sizeButton:FlxButton;

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
		startStopButton = new FlxButton(buttonX, uiY, MOVE_TO_GOAL, startStopPress);
		add(startStopButton);
		uiY += 20;

		// Add button reset unit to PlayState
		resetUnitButton = new FlxButton(buttonX, uiY, "Reset Unit", resetUnit);
		add(resetUnitButton);
		uiY += 20;

		inline function updateImmovableLabel()
		{
			immovableButton.text = "Immovable:" + (unit.path.immovable ? "ON" : "OFF");
		}

		// Add button reset unit to PlayState
		immovableButton = new FlxButton(buttonX, uiY, "Immovable",
			function toggleImmovable()
			{
				unit.path.immovable = !unit.path.immovable;
				updateImmovableLabel();
			}
		);
		updateImmovableLabel();
		add(immovableButton);
		uiY += 20;

		function updateSimplifyLabel()
		{
			simplifyButton.text = "Simplify:" + switch (simplify)
			{
				case NONE         : "NONE";
				case LINE         : "LINE";
				case RAY          : "RAY";
				case RAY_STEP(_)  : "STEP";
				case RAY_BOX(_, _): "BOX";
				default: throw "Invalid simplify";
			}
		}

		// Add button reset unit to PlayState
		simplifyButton = new FlxButton(buttonX, uiY, "Simplify",
			function toggleSimplify()
			{
				simplify = switch (simplify)
				{
					case NONE         : LINE;
					case LINE         : RAY;
					case RAY          : RAY_BOX(unit.width, unit.height);
					case RAY_BOX(_, _): NONE;
					default: throw "Invalid simplify";
				};

				redrawPath();

				updateSimplifyLabel();
			}
		);
		updateSimplifyLabel();
		add(simplifyButton);
		uiY += 20;

		function updateSize()
		{
			sizeButton.text = "Unit Size:" + switch (size)
			{
				case S1_1: "1x1";
				case S1_2: "1x2";
				case S2_1: "2x1";
				case S2_2: "2x2";
			};

			// set unit size
			unit.scale.x = goal.scale.x = pathfinder.widthInTiles;
			unit.scale.y = goal.scale.y = pathfinder.heightInTiles;
			unit.updateHitbox();
			goal.updateHitbox();

			if (simplify.match(RAY_BOX(_, _)))
				simplify = RAY_BOX(unit.width, unit.height);
		}

		// Add button reset unit to PlayState

		sizeButton = new FlxButton(buttonX, uiY, "Unit Size",
			function toggleSize()
			{
				switch (size)
				{
					case S1_1:
						size = S1_2;
						pathfinder.widthInTiles = 1;
						pathfinder.heightInTiles = 2;
					case S1_2:
						size = S2_1;
						pathfinder.widthInTiles = 2;
						pathfinder.heightInTiles = 1;
					case S2_1:
						size = S2_2;
						pathfinder.widthInTiles = 2;
						pathfinder.heightInTiles = 2;
					case S2_2:
						size = S1_1;
						pathfinder.widthInTiles = 1;
						pathfinder.heightInTiles = 1;
					default:
						throw "Invalid size";
				};

				updateSize();
				redrawPath();
			}
		);
		updateSize();
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

	function startStopPress()
	{
		switch (action)
		{
			case IDLE:
				moveToGoal();
			case GO:
				stopUnit();
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
			startStopButton.text = STOP_UNIT;
		}
		else
		{
			instructions.text = INSTRUCTIONS + "\n\n" + NO_PATH_FOUND;
		}
	}

	function stopUnit():Void
	{
		startStopButton.text = MOVE_TO_GOAL;
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

enum abstract Action(Int)
{
	var IDLE = 0;
	var GO = 1;
}

class BigMoverPathfinder extends FlxDiagonalPathfinder
{
	public var widthInTiles:Int;
	public var heightInTiles:Int;

	public function new(widthInTiles:Int, heightInTiles:Int, diagonalPolicy:FlxTilemapDiagonalPolicy = NONE)
	{
		this.widthInTiles = widthInTiles;
		this.heightInTiles = heightInTiles;
		super(diagonalPolicy);
	}

	override function findPath(map:FlxBaseTilemap<FlxObject>, start:FlxPoint, end:FlxPoint, simplify:FlxPathSimplifier = LINE):Null<Array<FlxPoint>>
	{
		final offset = FlxPoint.get(
			(widthInTiles  - 1) / 2 * map.width  / map.widthInTiles,
			(heightInTiles - 1) / 2 * map.height / map.heightInTiles
		);
		// offset to center of top-left tile
		var startIndex = map.getTileIndexByCoords(FlxPoint.weak(start.x - offset.x, start.y - offset.y));
		var endIndex   = map.getTileIndexByCoords(FlxPoint.weak(end.x   - offset.x, end.y   - offset.y));

		var data = createData(map, startIndex, endIndex);
		var indices = findPathIndicesHelper(data);
		if (indices == null)
			return null;

		var path = getPathPointsFromIndices(data, indices);

		// Reset the start and end points to be exact
		path[0].copyFrom(start);
		path[path.length - 1].copyFrom(end);

		// Some simple path cleanup options
		simplifyPath(data, path, simplify);

		start.putWeak();
		end.putWeak();
		offset.put();

		return path;
	}

	override function getPathPointsFromIndices(data:FlxPathfinderData, indices:Array<Int>):Array<FlxPoint>
	{
		var path = super.getPathPointsFromIndices(data, indices);
		final offset = FlxPoint.get(
			(widthInTiles  - 1) / 2 * data.map.width  / data.map.widthInTiles,
			(heightInTiles - 1) / 2 * data.map.height / data.map.heightInTiles
		);

		for (p in path)
			p.addPoint(offset);

		offset.put();

		return path;
	}

	override function getInBoundDirections(data:FlxPathfinderData, from:Int)
	{
		var x = data.getX(from);
		var y = data.getY(from);
		return FlxDirectionFlags.fromBools
		(
			x > 0,
			x < data.map.widthInTiles - widthInTiles,
			y > 0,
			y < data.map.heightInTiles - heightInTiles
		);
	}

	override function canGo(data:FlxPathfinderData, to:Int, dir:FlxDirectionFlags = ANY)
	{
		final cols = data.map.widthInTiles;

		for (x in 0...widthInTiles)
		{
			for (y in 0...heightInTiles)
			{
				if (!super.canGo(data, to + x + (y * cols), dir))
					return false;
			}
		}

		return true;
	}

	override function hasValidInitialData(data:FlxPathfinderData):Bool
	{
		final cols = data.map.widthInTiles;
		final maxX = data.map.widthInTiles - widthInTiles;
		final maxY = data.map.heightInTiles - heightInTiles;
		return data.hasValidStartEnd()
			&& data.getX(data.startIndex) <= maxX
			&& data.getY(data.startIndex) <= maxY
			&& data.getX(data.endIndex) <= maxX
			&& data.getY(data.endIndex) <= maxY
			&& canGo(data, data.startIndex)
			&& canGo(data, data.endIndex);
	}
}

enum abstract Size(Int)
{
	var S1_1 = 0;
	var S1_2 = 1;
	var S2_1 = 2;
	var S2_2 = 3;
}
