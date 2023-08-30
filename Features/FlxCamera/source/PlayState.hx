package;

import haxe.EnumTools;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.nape.FlxNapeSpace;
import flixel.math.FlxMath;
import nape.phys.Material;
import props.BorderSlice;
import props.Orb;
import props.OtherOrb;
import props.PlayerOrb;
import ui.DeadzoneOverlay;
import ui.HUD;

using flixel.util.FlxSpriteUtil;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */
class PlayState extends FlxState
{
	static var followStyles = EnumTools.createAll(FlxCameraFollowStyle);
	
	var player:PlayerOrb;
	var hud:HUD;
	var deadzoneOverlay:DeadzoneOverlay;

	override public function create():Void
	{
		FlxNapeSpace.init();

		// final levelMinX = -FlxG.stage.stageWidth;
		// final levelMaxX = FlxG.stage.stageWidth;
		// final levelMinY = -FlxG.stage.stageHeight;
		// final levelMaxY = FlxG.stage.stageHeight;
		final levelMinX = 0;
		final levelMaxX = FlxG.stage.stageWidth * 2;
		final levelMinY = 0;
		final levelMaxY = FlxG.stage.stageHeight * 2;
		final levelWidth = levelMaxX - levelMinX;
		final levelHeight = levelMaxY - levelMinY;

		super.create();

		FlxNapeSpace.velocityIterations = 5;
		FlxNapeSpace.positionIterations = 5;

		// repeating backdrop
		final backdrop = new FlxBackdrop("assets/FloorTexture.png");
		#if debug
		backdrop.ignoreDrawDebug = true;
		#end
		add(backdrop);
		
		// create nape wall colliders
		final border = 10;
		FlxNapeSpace.createWalls(levelMinX + border, levelMinY + border, levelMaxX - border, levelMaxY - border, border, new Material(1.0, 0.0, 0.0, 1));
		
		// Walls border sprite
		final borderSprite = new BorderSlice(levelMinX, levelMinY, levelWidth, levelHeight);
		add(borderSprite);

		// Player orb
		player = new PlayerOrb(levelMinX + levelWidth / 2, levelMinY + levelHeight / 2);
		add(player);
		// if the player is using a virtual pad, add it to the state
		if (player.controls.virtualPad != null)
			add(player.controls.virtualPad);
		
		// Other orbs
		for (i in 0...5)
		{
			final orb = new OtherOrb(0, 0, i);
			add(orb);
			orb.randomizeVelocity();
			
			// randomize spawn position until it's far enough from the player, up to 20 times
			var tries = 20;
			do orb.randomizePosition(levelMinX, levelMaxX, levelMinY, levelMaxY)
			while (Math.abs(orb.x - player.x) < 200 && Math.abs(orb.y - player.y) < 200 && tries-- > 0);
		}
		
		hud = new HUD();
		add(hud);
		
		// Camera Overlay
		deadzoneOverlay = new DeadzoneOverlay();
		add(deadzoneOverlay);
		
		FlxG.camera.pixelPerfectRender = false;
		FlxG.camera.setScrollBounds(levelMinX, levelMaxX, levelMinY, levelMaxY);
		FlxG.worldBounds.set(levelMinX, levelMinY, levelWidth, levelHeight);
		FlxG.camera.follow(player, followStyles[0], 1);
		deadzoneOverlay.redraw(FlxG.camera); // now that deadzone is present
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		final justPressed = FlxG.keys.justPressed;
		
		if (justPressed.Y) setStyle(1);
		if (justPressed.H) setStyle(-1);
		
		if (justPressed.U) setLerp(.1);
		if (justPressed.J) setLerp(-.1);
		
		if (justPressed.I) setLead(.5);
		if (justPressed.K) setLead(-.5);
		
		if (justPressed.O) setZoom(.1);
		if (justPressed.L) setZoom(-.1);
		
		if (justPressed.M) FlxG.camera.shake();
	}
	
	public function setZoom(delta:Float)
	{
		final newZoom = FlxG.camera.zoom + delta;
		FlxG.camera.zoom = FlxMath.bound(Math.round(newZoom * 10) / 10, 0.5, 4);
		hud.updateZoom(FlxG.camera.zoom);
	}
	
	function setLead(delta:Float)
	{
		var cam = FlxG.camera;
		cam.followLead.x += delta;
		cam.followLead.y += delta;
		
		if (cam.followLead.x < 0)
		{
			cam.followLead.x = 0;
			cam.followLead.y = 0;
		}
		
		hud.updateCamLead(cam.followLead.x);
	}
	
	function setLerp(delta:Float)
	{
		var cam = FlxG.camera;
		cam.followLerp += delta;
		cam.followLerp = Math.round(10 * cam.followLerp) / 10; // adding or subtracting .1 causes roundoff errors
		hud.updateCamLerp(cam.followLerp);
	}
	
	function setStyle(delta:Int)
	{
		final nextStyleIndex = (followStyles.indexOf(FlxG.camera.style) + delta) % followStyles.length;
		FlxG.camera.follow(player, followStyles[nextStyleIndex], FlxG.camera.followLerp);
		
		deadzoneOverlay.redraw(FlxG.camera);
		
		hud.updateStyle(FlxG.camera.style);
	}
}
