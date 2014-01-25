package; 

import flash.system.System;
import flixel.effects.FlxTrailArea;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxAssets;
import flixel.system.resolution.RelativeResolutionPolicy;
import flixel.text.FlxText;
import flash.display.BitmapData;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import openfl.display.FPS;

using StringTools;	// so we can use String.replace() easily, yay!
using flixel.util.FlxSpriteUtil;

/**
 * @author azrafe7
 */
class PlayState extends FlxState
{	
	// how many aliens are created initially
	inline static var NUM_ALIENS:Int = 75;
	
	// How fast the player moves
	inline static var PLAYER_SPEED:Int = 75;
	
	inline static var INFO:String = "Collisions: |hits|\n" + 
									"FPS: |fps| \n\n" + 
									"[W/S]           Objects: |objects|\n" +
									"[A/D]           Alpha tolerance: |alpha|\n" +
									"[ARROWS]    Move\n" +
									"[R]               Randomize\n" +
									"[SPACE]       Toggle rotations";
	
	// group holding the player and the aliens
	var aliens:FlxTypedGroup<FlxSprite>;
	
	// the player ship
	var player:Player;
	
	// number of collisions at any given time
	var numCollisions:Int = 0;
	
	// setting this to 255 means two object will collide only if totally opaque
	var alphaTolerance:Int = 1;
	
	// info text to show in the bottom-left corner of the screen
	var infoText:FlxText;
	
	// to track fps
	var fps:FPS;
	
	// wether the objects should rotate
	var rotate(default, set):Bool = true;
	
	override public function create():Void
	{	
		super.create();
		
		// the group containing all the objects
		add(aliens = new FlxTypedGroup<FlxSprite>());
		
		// create the player
		add(player = new Player());
		
		// add objects for more interstellar fun!
		for (i in 1...NUM_ALIENS) addAlien();
		
		// add in some text so we know what's happening
		infoText = new FlxText(2, 0, 400, INFO);
		infoText.y = FlxG.height - infoText.height;
		infoText.setBorderStyle(FlxText.BORDER_OUTLINE);
		add(infoText);
		
		// just need this to get the fps, so we display it outside view range
		FlxG.addChildBelowMouse(fps = new FPS(-100));
		
		// makes low fps less noticable
		FlxG.fixedTimestep = false;
		
		// don't need the cursor
		FlxG.mouse.visible = false;
		
		FlxG.watch.add(FlxG, "width");
		FlxG.watch.add(FlxG, "height");
	}
	
	/**
	 * Create and add a new alien.
	 */
	function addAlien():FlxSprite 
	{
		var alien = aliens.recycle(FlxSprite);
		alien.loadGraphic("assets/alien.png", true); // load graphics from asset
		alien.animation.add("dance", [0, 1, 0, 2], FlxRandom.intRanged(6, 10));	// set dance dance interstellar animation
		alien.animation.play("dance");	// dance!
		randomize(alien);	// set position, angle and alpha to random values
		
		return aliens.add(alien);
	}
	
	/**
	 * Randomize position, angle and alpha of `obj`.
	 */
	function randomize(obj:FlxSprite):FlxSprite
	{
		// The start position of the alien is offscreen on a circle
		var point = getRandomCirclePos();
		obj.setPosition(point.x, point.y);
		
		var destX = FlxRandom.intRanged(0, Std.int(FlxG.width - obj.width));
		var destY = FlxRandom.intRanged(0, Std.int(FlxG.height - obj.height));
		obj.alpha = FlxRandom.floatRanged(0.3, 1.0);
		
		// Neat tweening effect for new aliens appearing
		FlxTween.multiVar(obj, { x: destX, y:destY }, 2, { ease: FlxEase.expoOut } );
		
		if (rotate) {
			randomizeRotation(obj);
		}
		
		return obj;
	}
	
	/**
	 * Here's where the fun happens! \o/.
	 */
	override public function update():Void
	{			
		super.update();
		
		handleInput();
		checkCollisions();
		updateInfo();
		
		player.screenWrap(); // make sure the player can't go offscreen
	}	
	
	function handleInput():Void 
	{
		// Reset velocity to (0,0)
		player.velocity.set();
		
		// player movement
		if (FlxG.keys.pressed.LEFT)  {
			player.velocity.x = - PLAYER_SPEED;
		}
		if (FlxG.keys.pressed.RIGHT) {
			player.velocity.x =   PLAYER_SPEED;
		}
		if (FlxG.keys.pressed.UP)    {
			player.velocity.y = - PLAYER_SPEED;
		}
		if (FlxG.keys.pressed.DOWN)  {
			player.velocity.y =   PLAYER_SPEED;
		}
		
		// toggle rotation
		if (FlxG.keys.justReleased.SPACE) 
		{
			rotate = !rotate;
			(rotate) ? randomizeRotation(player) : resetRotation(player);
		}
		
		// randomize
		if (FlxG.keys.justReleased.R) 
		{
			for (obj in aliens) 
			{
				// Don't randomize the player's position
				if (obj != player)
				{
					randomize(obj);
				}
			}
		}
		
		// increment/decrement number of objects
		if (FlxG.keys.justReleased.W) {
			for (i in 0...3) addAlien();
		}
		if (FlxG.keys.justReleased.S) {
			for (i in 0...3) aliens.getFirstAlive().kill();
		}
		
		// increment/decrement alpha tolerance
		if (FlxG.keys.pressed.D) {
			alphaTolerance = Std.int(Math.min(alphaTolerance + 3, 255));
		}
		if (FlxG.keys.pressed.A) {
			alphaTolerance = Std.int(Math.max(alphaTolerance - 3, 1));
		}
		
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
		numCollisions = 0;
		player.color = FlxColor.GREEN;
		
		for (i in 0...aliens.length) 
		{
			var obj1 = aliens.members[i];
			var collides = false;
			
			for (j in 0...aliens.length) 
			{
				// Don't collide an object with itself
				if (i == j) continue;
				
				var obj2 = aliens.members[j];
				// this is how we check if obj1 and obj2 are colliding
				if (FlxCollision.pixelPerfectCheck(obj1, obj2, alphaTolerance)) 
				{	
					collides = true;
					numCollisions++;
					break;
				}
			}
			
			// We check collisions with the player seperately, since he's not in the group
			if (FlxCollision.pixelPerfectCheck(obj1, player, alphaTolerance))
			{
				collides = true;
				numCollisions++;
				player.color = FlxColor.RED;
			}
			
			obj1.color = collides ? FlxColor.RED : FlxColor.WHITE;	
		}
	}
	
	function updateInfo():Void 
	{
		infoText.text = INFO.replace("|objects|", Std.string(aliens.countLiving()))
							.replace("|alpha|", Std.string(alphaTolerance))
							.replace("|hits|", Std.string(numCollisions))
							.replace("|fps|", Std.string(fps.text.substr(5)));
	}
	
	function set_rotate(Value:Bool):Bool
	{
		if (Value) {
			aliens.forEach(randomizeRotation);
		}
		else {
			aliens.forEach(resetRotation);
		}
		return rotate = Value;
	}
	
	function randomizeRotation(obj:FlxSprite):Void
	{
		obj.angle = FlxRandom.float() * 360;
		obj.angularVelocity = 100;
	}
	
	function resetRotation(obj:FlxSprite):Void
	{
		obj.angle = 0;
		obj.angularVelocity = 0;
	}
	
	/**
	 * Returns a random position on an offscreen circle to tween the aliens from / to
	 */ 
	function getRandomCirclePos():FlxPoint
	{
		var startAngle = FlxRandom.intRanged(1, 360);
		var startRadius = (FlxG.height > FlxG.width) ? (FlxG.height + 200) : (FlxG.width + 200);
		
		return FlxAngle.getCartesianCoords(startRadius, startAngle);
	}
}

class Player extends FlxSprite
{
	public function new()
	{
		super();
		loadGraphic("assets/ship.png");
		screenCenter();
		angularVelocity = 50;
	}
}