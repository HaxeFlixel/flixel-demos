package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import openfl.display.FPS;

using StringTools;
using flixel.util.FlxSpriteUtil;

/**
 * @author azrafe7
 */
class PlayState extends FlxState
{
	// how many aliens are created initially
	inline static var NUM_ALIENS:Int = 50;

	inline static var INFO_FULL:String
		= "Collisions: |hits|\n"
		#if debug + "Checks: |checks|\n" #end
		+ "FPS: |fps|\n\n"
		+ "[W/S]           Objects: |objects|\n"
		+ "[A/D]           Alpha tolerance: |alpha|\n"
		+ "[ARROWS]    Move\n"
		+ "[R]               Randomize\n"
		+ "[SPACE]       |rotate| rotation\n"
		+ "[T]               |scale| scale\n"
		+ "[H]               Toggle instructions\n"
		+ "[Q]               |quadTrees| QuadTrees";

	inline static var INFO_MIN:String
		= "Objects: |objects|\n"
		#if debug + "Checks: |checks|\n" #end
		+ "Collisions: |hits|\n"
		+ "FPS: |fps|";

	// group holding the player and the aliens
	var group:FlxTypedGroup<DemoSprite>;

	// the player ship
	var player:Player;

	// number of collisions at any given time
	var numCollisions:Int = 0;

	// number of collisions at any given time
	var numChecks:Int = 0;

	// setting this to 255 means two object will collide only if totally opaque
	var alphaTolerance:Int = 1;

	// info text to show in the bottom-left corner of the screen
	var infoText:FlxText;

	// to track fps
	var fps:FPS;

	// whether the objects should rotate
	var rotate:Bool = false;
	// whether the objects should be scaled
	var scale:Bool = false;
	// whether the key instructions will show
	var showFullInfo = true;
	
	var useQuadTrees = true;

	override public function create():Void
	{
		super.create();
		FlxG.camera.bgColor = FlxG.stage.color;

		// the group containing all the objects
		add(group = new FlxTypedGroup<DemoSprite>());

		// create the player
		group.add(player = new Player());
		FlxG.camera.follow(player);
		FlxG.camera.setScrollBounds(0, FlxG.width * 10, 0, FlxG.height);
		FlxG.worldBounds.set(-10, -10, FlxG.camera.maxScrollX + 20, FlxG.camera.maxScrollY + 20);
		
		updateSpriteAngles();
		updateSpriteScales();

		// add objects for more interstellar fun!
		for (i in 1...NUM_ALIENS)
			addAlien();
		

		// add in some text so we know what's happening
		infoText = new FlxText(2, 0, 400, INFO_FULL);
		infoText.y = FlxG.height - infoText.height;
		infoText.setBorderStyle(OUTLINE, FlxColor.BLACK);
		infoText.scrollFactor.x = 0;
		add(infoText);

		// just need this to get the fps, so we display it outside view range
		FlxG.addChildBelowMouse(fps = new FPS(-100));

		// makes low fps less noticable
		FlxG.fixedTimestep = false;
	}

	/**
	 * Create and add a new alien.
	 */
	function addAlien():FlxSprite
	{
		var alien:Alien = cast group.recycle(Alien);
		alien.randomize();
		
		if (rotate)
			alien.randomAngle();
		else
			alien.resetAngle();
		
		if (scale)
			alien.randomScale();
		else
			alien.resetScale();
		
		return alien;
	}

	/**
	 * Here's where the fun happens! \o/.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		handleInput();
		checkCollisions();
		updateInfo();
	}

	function handleInput():Void
	{
		if (FlxG.keys.justReleased.Q)
			useQuadTrees = !useQuadTrees;
		
		// toggle rotation
		if (FlxG.keys.justReleased.SPACE)
		{
			rotate = !rotate;
			updateSpriteAngles();
		}
		
		// toggle scale
		if (FlxG.keys.justReleased.T)
		{
			scale = !scale;
			updateSpriteScales();
		}

		// randomize
		if (FlxG.keys.justReleased.R)
		{
			for (obj in group)
			{
				if (obj is Alien)
					Std.downcast(obj, Alien).randomize();
			}
		}

		// increment/decrement number of objects
		if (FlxG.keys.justReleased.W)
		{
			for (i in 0...3)
				addAlien();
		}
		
		if (FlxG.keys.justReleased.S)
		{
			if (group.length >= 4)
			{
				for (i in 0...3)
				{
					final alien = group.getFirst((obj)->obj.alive && obj is Alien);
					if (alien != null)
						alien.kill();
				}
			}
		}
		
		if (FlxG.keys.justReleased.H)
		{
			showFullInfo = !showFullInfo;
			updateInfo();
			infoText.y = FlxG.height - infoText.height;
		}

		// increment/decrement alpha tolerance
		if (FlxG.keys.pressed.D)
			alphaTolerance = Std.int(Math.min(alphaTolerance + 3, 255));
		if (FlxG.keys.pressed.A)
			alphaTolerance = Std.int(Math.max(alphaTolerance - 3, 1));

		// quit on ESC
		if (FlxG.keys.justReleased.ESCAPE)
		{
			#if (flash || js)
			System.exit(0);
			#else
			Sys.exit(0);
			#end
		}
	}

	/**
	 * Pixel perfect collision check between all objects
	 */
	function checkCollisions():Void
	{
		numChecks = 0;
		numCollisions = 0;
		
		function pixelPerfectCheck(a:DemoSprite, b:DemoSprite)
		{
			if (a.isOverlapping && b.isOverlapping)
				return false;
			
			numChecks++;
			final overlapping = FlxCollision.pixelPerfectCheck(a, b, alphaTolerance);
			if (overlapping)
				numCollisions++;
			
			return overlapping;
		}

		for (alien in group)
			alien.cameraWrap(WALL);
		
		if (useQuadTrees)
		{
			for (obj in group)
				obj.isOverlapping = false;
			
			FlxG.overlap(group, group,
				function onOverlap(a, b)
				{
					a.isOverlapping = true;
					b.isOverlapping = true;
				},
				pixelPerfectCheck
			);
		}
		else
		{
			for (obj in group)
				obj.isOverlapping = false;
			
			for (obj1 in group)
			{
				// Only collide alive members
				if (!obj1.alive)// || obj1.isOverlapping)
					continue;
				
				// We check collisions with the player seperately, since he's not in the group
				for (obj2 in group)
				{
					// Only collide alive members and don't collide an object with itself
					if (!obj1.alive || obj1 == obj2)
						continue;
					
					// this is how we check if obj1 and obj2 are colliding
					if (pixelPerfectCheck(obj1, obj2))
					{
						obj1.isOverlapping = true;
						obj2.isOverlapping = true;
						break;
					}
				}
				
				// obj1.setCollides(collides);
			}
		}
	}
	
	function updateSpriteAngles()
	{
		if (rotate)
		{
			for (obj in group)
				obj.randomAngle();
		}
		else
		{
			for (obj in group)
				obj.resetAngle();
		}
	}
	
	function updateSpriteScales()
	{
		if (scale)
		{
			for (obj in group)
			{
				if (obj is Alien)
					Std.downcast(obj, Alien).randomScale();
			}
		}
		else
		{
			for (obj in group)
			{
				if (obj is Alien)
					Std.downcast(obj, Alien).resetScale();
			}
		}
	}

	function updateInfo():Void
	{
		infoText.text = (showFullInfo ? INFO_FULL : INFO_MIN)
			.replace("|checks|", Std.string(numChecks))
			.replace("|hits|", Std.string(numCollisions))
			.replace("|fps|", Std.string(fps.currentFPS))
			.replace("|objects|", Std.string(group.countLiving()))
			.replace("|alpha|", Std.string(alphaTolerance))
			.replace("|rotate|", rotate ? "Disable" : "Enable")
			.replace("|scale|", scale ? "Disable" : "Enable")
			.replace("|quadTrees|", useQuadTrees ? "Disable" : "Enable");
		
	}
}
