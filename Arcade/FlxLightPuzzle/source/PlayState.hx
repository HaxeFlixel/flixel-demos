package;

import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxVector;
import flixel.tweens.FlxTween;
import openfl.Assets;

/**
 * The main gameplay state.
 * @author MSGhero
 */
class PlayState extends FlxState
{
	var lights:Array<Segment>;
	
	var player:FlxSprite;
	var playerPosition:FlxVector;
	
	var game:GameLayer;
	var ui:UILayer;
	
	var numLevels:Int = 10;
	var currLevel:Template;
	var currLevelIndex:Int;
	
	override public function create():Void
	{
		super.create();
		
		FlxG.cameras.bgColor = 0xff666666;
		
		FlxG.autoPause = false;
		
		// we want the game playing during the menu state for a cool effect
		persistentUpdate = true;
		
		game = new GameLayer();
		ui = new UILayer(resetLevel);
		
		// the player is a high-tech triangle
		player = new FlxSprite(75, 144);
		player.makeGraphic(26, 26, FlxColor.TRANSPARENT, true);
		FlxSpriteUtil.drawTriangle(player, 0, 0, 26, FlxColor.WHITE);
		player.offset.set(13, 13);
		player.pixelPerfectRender = false;
		player.antialiasing = true;
		
		playerPosition = FlxVector.get(75, 144);
		
		currLevelIndex = -1;
		
		add(game);
		add(ui); // we want the UI on top of the game
		
		game.add(player); // and we want the player added during the menu
		
		// the original file was edited to have a 44100 Hz sampling frequency, since Flash cannot use 48000 Hz
		// this is really easy to change using a free program like Audacity
		FlxG.sound.playMusic(AssetPaths.Waltzon_edit__mp3, 0.5);
		
		// the main menu is going to be a substate here:
		// this lets us do the neat trick of having the menu feel like the first level
		var sub = new MenuState();
		sub.closeCallback = nextLevel;
		openSubState(sub);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.mouse.justReleased && FlxG.mouse.x >= ui.width && subState == null)
		{
			if (currLevel.colors.length > 0) shineLight();
			else resetLevel(); // automatically reset if the player clicks when no more light is left
		}
		
		if (FlxG.keys.justPressed.R) resetLevel();
		
		if (FlxG.keys.justPressed.F) FlxG.fullscreen = !FlxG.fullscreen;
		
		// helpful debug keys to quickly view levels without playing through them, only in debug mode
		#if debug
		if (FlxG.keys.justPressed.LEFT && currLevelIndex > 0)
		{
			currLevelIndex -= 2; // go back a level (go back two levels then go forward one)
			nextLevel();
		}
		
		if (FlxG.keys.justPressed.RIGHT)
		{
			nextLevel(); // go forward a level
		}
		#end
		
		if (FlxG.mouse.justMoved)
		{
			// the player sprite rotates as the mouse moves
			player.angle = Math.atan2(FlxG.mouse.y - player.y, FlxG.mouse.x - player.x) / Math.PI * 180 + 90;
		}
	}
	
	function resetLevel():Void
	{
		if (currLevelIndex == -1) return; // in case someone presses reset from the menu state, which shouldn't do anything
		
		FlxTween.globalManager.clear();
		
		game.remove(player);
		for (item in game) item.destroy();
		
		game.clear();
		currLevel.reset();
		
		// resetting the final level resets the game, start back at level 0
		if (currLevelIndex >= numLevels)
		{
			ui.unforceMenuExpand(); // reset the side panel menu to its normal behavior
			
			currLevelIndex = -1;
			nextLevel();
			
			return;
		}
		
		lights = [];
		
		game.add(player);
		
		// skip drawing the border, which is the first 4 mirrors in the list
		for (i in 4...currLevel.mirrors.length)
		{
			game.drawSegment(currLevel.mirrors[i], 0);
		}
		
		for (target in currLevel.targets)
		{
			game.drawCircle(target, 0);
		}
		
		ui.setAmmo(currLevel.colors);
	}
	
	function nextLevel():Void
	{
		++currLevelIndex;
		
		if (currLevelIndex >= numLevels)
		{
			// win the game
			var endCircle = new Circle(FlxVector.get(300, 144), 350, Color.WHITE);
			game.drawCircle(endCircle, 1);
			
			openSubState(new WinState());
			
			new FlxTimer().start(1, ui.forceMenuExpand); // force-expand the side panel menu to show the clickable options
			
			return;
		}
		
		currLevel = new Template(Assets.getText("assets/data/lv" + currLevelIndex + ".txt")); // gets the level data from the assets folder
		
		resetLevel();
	}
	
	function shineLight():Void
	{
		// get the path that the light follows as individual segments
		var path = Optics.getLightPath(new Segment(playerPosition, FlxVector.get(FlxG.mouse.x - playerPosition.x, FlxG.mouse.y - playerPosition.y), currLevel.colors[0]), currLevel.mirrors);
		// edit the path based on any colors that get combined
		Optics.combineColors(path, lights);
		
		// now to draw the new path
		// and check if it touches any targets
		var lightDelay = 0.0;
		for (segment in path)
		{
			game.drawSegment(segment, lightDelay);
			
			var i = 0;
			while (i < currLevel.targets.length)
			{
				var target = currLevel.targets[i];
				
				if (segment.color == target.color)
				{
					var tempIntersection = target.intersectingSegment(segment);
					
					if (tempIntersection.isValid())
					{
						// target hit
						var targetDelay = lightDelay + tempIntersection.subtractNew(segment.start).length / Optics.SPEED_OF_LIGHT;
						game.eraseCircle(target, targetDelay);
						currLevel.targets.remove(target);
						
						--i; // this is so we don't skip over the next element, which has gone down an index after the removal
						
						if (currLevel.targets.length == 0)
						{
							// if the level is complete, move on to the next one
							new FlxTimer().start(lightDelay + .54, checkLevelFinish);
						}
					}
					
					tempIntersection.put();
				}
				
				++i;
			}
			
			lightDelay += segment.vector.length / Optics.SPEED_OF_LIGHT; // delay the drawing of the next segment by time (equals distance divided by speed)
		}
		
		// add the path to the existing lights
		for (segment in path) lights.push(segment);
		
		// remove this color and move on to the next one
		currLevel.colors.shift();
		ui.setAmmo(currLevel.colors);
	}
	
	function checkLevelFinish(_):Void
	{
		if (currLevel.targets.length == 0) nextLevel();
		
		else if (currLevel.colors.length == 0)
		{
			// prompt reset level?
		}
	}
}