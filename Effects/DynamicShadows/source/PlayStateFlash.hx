package;

import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeTilemap;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import nape.geom.Vec2;
import nape.geom.Vec2List;
import nape.phys.Body;
import openfl.display.BlendMode;
import openfl.display.FPS;

using flixel.util.FlxSpriteUtil;

/**
 * The old version of dynamic shadows, where the shadows are drawn via openfl.display.graphics.
 * kept for no good reason other than posterity
 */
class PlayStateFlash extends PlayState
{
	public static inline var TILE_SIZE:Int = PlayState.TILE_SIZE;

	static inline var SHADOW_COLOR = 0xff2a2963;
	static inline var OVERLAY_COLOR = 0xff887fff;

	/**
	 * Camera containing the casted shadows
	 */
	var shadowCam:FlxCamera;

	/**
	 * The sprite that shadows will be drawn to
	 */
	var shadowCanvas:FlxSprite;

	/**
	 * The sprite that the actual darkness and the gem's flare-like effect will be drawn to
	 */
	var shadowOverlay:FlxSprite;

	/**
	 * If there's a small gap between something (could be two tiles,
	 * even if they're right next to each other), this should cover it up for us
	 */
	var lineStyle:LineStyle = {color: SHADOW_COLOR, thickness: 1};
	
	override function createCams()
	{
		// Note: The tilemap used in this demo was drawn with 'Tiled' (http://www.mapeditor.org/),
		// but the level data was picked from the .tmx file and put into two separate
		// .txt files for simplicity. If you wish to learn how to use Tiled with your project,
		// have a look at this demo: http://haxeflixel.com/demos/TiledEditor/

		// If we add the shadows *before* all of the foreground elements (stage included)
		// they will only cover the background, which is usually what you'd want I'd guess :)
		shadowCanvas = new FlxSprite();
		shadowCanvas.blend = BlendMode.MULTIPLY;
		shadowCanvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		var index = members.indexOf(foreground);
		// place behind foreground
		insert(index, shadowCanvas);

		shadowOverlay = new FlxSprite();
		shadowOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		shadowOverlay.blend = BlendMode.MULTIPLY;
		add(shadowOverlay);
		
		// FlxG.camera draws the actual world. In this case, that means everything except infoText
		FlxG.camera.bgColor = 0x5a81ad;
		gem.camera = FlxG.camera;
		background.camera = FlxG.camera;
		
		// places the casted shadows above the foreground and below the ui
		// shadowCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		// FlxG.cameras.add(shadowCam, false);
		// shadowCam.bgColor = 0x0;
		// shadowCanvas.camera = shadowCam;
		// shadowOverlay.camera = shadowCam;
		
		// draws anything above the sahdows, in this case infoText
		uiCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(uiCam, false);
		uiCam.bgColor = 0x0;
		infoText.camera = uiCam;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		processShadows();
	}

	public function processShadows():Void
	{
		shadowCanvas.fill(FlxColor.TRANSPARENT);
		shadowOverlay.fill(OVERLAY_COLOR);

		shadowOverlay.drawCircle( // outer red circle
			gem.body.position.x + FlxG.random.float(-.6, .6), gem.body.position.y + FlxG.random.float(-.6, .6),
			(FlxG.random.bool(5) ? 16 : 16.5), 0xffff5f5f);

		shadowOverlay.drawCircle( // inner red circle
			gem.body.position.x + FlxG.random.float(-.25, .25), gem.body.position.y + FlxG.random.float(-.25, .25),
			(FlxG.random.bool(5) ? 13 : 13.5), 0xffff7070);

		for (body in FlxNapeSpace.space.bodies)
		{
			// We don't want to draw any shadows around the gem, since it's the light source
			if (body.userData.type != "Gem")
				processBodyShapes(body);
		}
	}

	function processBodyShapes(body:Body)
	{
		for (shape in body.shapes)
		{
			var verts:Vec2List = shape.castPolygon.worldVerts;

			for (i in 0...verts.length)
			{
				var startVertex:Vec2 = (i == 0) ? verts.at(verts.length - 1) : verts.at(i - 1);
				processShapeVertex(startVertex, verts.at(i));
			}
		}
	}

	function processShapeVertex(startVertex:Vec2, endVertex:Vec2):Void
	{
		var tempLightOrigin:Vec2 = Vec2.get(gem.body.position.x + FlxG.random.float(-.3, 3), gem.body.position.y + FlxG.random.float(-.3, .3));

		if (doesEdgeCastShadow(startVertex, endVertex, tempLightOrigin))
		{
			var projectedPoint:Vec2 = projectPoint(startVertex, tempLightOrigin);
			var prevProjectedPt:Vec2 = projectPoint(endVertex, tempLightOrigin);
			var vts:Array<FlxPoint> = [
				FlxPoint.weak(startVertex.x, startVertex.y),
				FlxPoint.weak(projectedPoint.x, projectedPoint.y),
				FlxPoint.weak(prevProjectedPt.x, prevProjectedPt.y),
				FlxPoint.weak(endVertex.x, endVertex.y)
			];

			shadowCanvas.drawPolygon(vts, SHADOW_COLOR, lineStyle);
		}
	}

	function projectPoint(point:Vec2, light:Vec2):Vec2
	{
		var lightToPoint:Vec2 = point.copy();
		lightToPoint.subeq(light);

		var projectedPoint:Vec2 = point.copy();
		return projectedPoint.addeq(lightToPoint.muleq(.45));
	}

	function doesEdgeCastShadow(start:Vec2, end:Vec2, light:Vec2):Bool
	{
		var startToEnd:Vec2 = end.copy();
		startToEnd.subeq(start);

		var normal:Vec2 = new Vec2(startToEnd.y, -1 * startToEnd.x);

		var lightToStart:Vec2 = start.copy();
		lightToStart.subeq(light);

		return normal.dot(lightToStart) > 0;
	}
}
