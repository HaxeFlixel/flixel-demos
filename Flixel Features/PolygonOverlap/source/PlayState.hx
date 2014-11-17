package;

import flash.geom.Matrix;
import flixel.addons.plugin.FlxMouseControl;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMatrix;
import flixel.overlap.FlxCircle;
import flixel.overlap.FlxHitboxList;
import flixel.overlap.FlxOverlap;
import flixel.overlap.FlxOverlap2D;
import flixel.overlap.FlxPolygon;
import flixel.overlap.FlxRay;
import flixel.overlap.FlxRayData;
import flixel.overlap.IFlxHitbox;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.addons.display.FlxExtendedSprite;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var sprite1 : FlxExtendedSprite;
	var sprite2 : FlxExtendedSprite;
	var sprite3 : FlxExtendedSprite;
	var sprite4 : FlxExtendedSprite;
	var bounds : FlxSprite;
	
	var lightSource : FlxExtendedSprite;
	var light : FlxSprite;
	var lightVertices : Array<FlxPoint>;
	
	var group : FlxGroup;
	var lightGroup : FlxGroup;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.plugins.add(new FlxMouseControl());
		
		//Create a circle
		sprite1 = new FlxExtendedSprite(100, 100);
		sprite1.makeGraphic(100, 100, 0x0);
		FlxSpriteUtil.drawCircle(sprite1, 50, 50, 50);
		sprite1.origin.set(15, 15);
		sprite1.hitbox = new FlxCircle(sprite1, 50, 50, 50);
		sprite1.enableMouseDrag();
		sprite1.angularVelocity = 5;
		add(sprite1);
		
		//Create a triangle
		sprite2 = new FlxExtendedSprite(200, 200);
		sprite2.makeGraphic(150, 150, 0x0);
		sprite2.angularVelocity = -10;
		var vertices1 = new Array<FlxPoint>();
		vertices1[0] = FlxPoint.get(0, 0);
		vertices1[1] = FlxPoint.get(150, 150);
		vertices1[2] = FlxPoint.get(0, 150);
		sprite2.scale.set(0.5, 0.5);
		sprite2.x = sprite2.y = 200;
		FlxSpriteUtil.drawPolygon(sprite2, vertices1);
		sprite2.origin.set(10, 30);
		sprite2.hitbox = new FlxPolygon(sprite2, vertices1);
		sprite2.enableMouseDrag();
		add(sprite2);
		
		//Create a random convex polygon
		sprite3 = new FlxExtendedSprite(350, 350);
		sprite3.makeGraphic(140, 140, 0x0);
		sprite3.angularVelocity = 15;
		var vertices2 = new Array<FlxPoint>();
		vertices2.push(FlxPoint.get(0, 0));
		vertices2.push(FlxPoint.get(120, 20));
		vertices2.push(FlxPoint.get(140, 80));
		vertices2.push(FlxPoint.get(120, 140));
		vertices2.push(FlxPoint.get(70, 90));
		vertices2.push(FlxPoint.get(20, 50));
		sprite3.enableMouseDrag();
		FlxSpriteUtil.drawPolygon(sprite3, vertices2);
		sprite3.origin.set(120, 100);
		sprite3.hitbox = new FlxPolygon(sprite3, vertices2);
		add(sprite3);
		
		//Create a concave polygon, using two convex polygon
		sprite4 = new FlxExtendedSprite(250, 100);
		sprite4.makeGraphic(80, 80, 0x0);
		var hitboxes = new Array<IFlxHitbox>();
		var triangle = new Array<FlxPoint>();
		triangle.push(FlxPoint.get(40, 0));
		triangle.push(FlxPoint.get(0, 80));
		triangle.push(FlxPoint.get(40, 40));
		FlxSpriteUtil.drawPolygon(sprite4, triangle);
		hitboxes.push(new FlxPolygon(sprite4, triangle));
		triangle[1].set(80, 80);
		FlxSpriteUtil.drawPolygon(sprite4, triangle);
		hitboxes.push(new FlxPolygon(sprite4, triangle));
		sprite4.hitbox = new FlxHitboxList(sprite4, hitboxes);
		add(sprite4);
		sprite4.enableMouseDrag();
		
		
		//Create the bounds for the rays (not necessary, but makes it easier)
		bounds = new FlxSprite();
		var hitboxes = new Array<IFlxHitbox>();
		var vertices = new Array<FlxPoint>();
		vertices.push(FlxPoint.get(0, 0));
		vertices.push(FlxPoint.get(FlxG.width, 0));
		vertices.push(FlxPoint.get(0, -10));
		hitboxes.push(new FlxPolygon(bounds, vertices));
		vertices[1].set(0, FlxG.height);
		vertices[2].set( -10, FlxG.height);
		hitboxes.push(new FlxPolygon(bounds, vertices));
		vertices[0].set(FlxG.width,0);
		vertices[1].set(FlxG.width,FlxG.height);
		vertices[2].set(FlxG.width + 10, FlxG.height);
		hitboxes.push(new FlxPolygon(bounds, vertices));
		vertices[0].set(0, FlxG.height);
		vertices[2].set(FlxG.width, FlxG.height + 10);
		hitboxes.push(new FlxPolygon(bounds, vertices));
		bounds.hitbox = new FlxHitboxList(bounds, hitboxes);
		
		light = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x0);
		add(light);
		
		lightSource = new FlxExtendedSprite(FlxG.width / 2, FlxG.height / 2);
		lightSource.makeGraphic(10, 10, FlxColor.YELLOW);
		lightSource.enableMouseDrag();
		add(lightSource);
		
		lightVertices = new Array<FlxPoint>();
		for (i in 0...101)
			lightVertices[i] = FlxPoint.get();
		
		group = new FlxGroup();
		group.add(sprite1);
		group.add(sprite2);
		group.add(sprite3);
		group.add(sprite4);
		
		lightGroup = new FlxGroup();
		lightGroup.add(sprite1);
		lightGroup.add(sprite2);
		lightGroup.add(sprite3);
		lightGroup.add(sprite4);
		lightGroup.add(bounds);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed : Float):Void
	{
		lightSource.velocity.set(0, 0);
		if (FlxG.keys.pressed.W)
			lightSource.velocity.set(0, -100);
		if (FlxG.keys.pressed.S)
			lightSource.velocity.set(0, 100);
		if (FlxG.keys.pressed.A)
			lightSource.velocity.set(-100, 0);
		if (FlxG.keys.pressed.D)
			lightSource.velocity.set(100, 0);
		
		sprite1.color = sprite2.color = sprite3.color = sprite4.color = FlxColor.WHITE;
		
		FlxOverlap.hitboxOverlap(group, null, function(overlapData) { overlapData.hitbox1.parent.color = overlapData.hitbox2.parent.color = 0xff0000; } );
		createLight();
		
		super.update(elapsed);
	}
	
	//In this function, we update the light sprite's bitmap. For this, we cast 50 rays from the lightsource in the direction to the mouse +-22.5 degrees. We put every intersection point into
	//a vertices array, and then draw a polygon out from it.
	private function createLight()
	{
		var lightSourceVector = FlxVector.get(lightSource.x, lightSource.y);
		var directionPoint = FlxG.mouse.getWorldPosition().subtractPoint(FlxPoint.weak(lightSource.x,lightSource.y));
		var directionVector = FlxVector.get(directionPoint.x, directionPoint.y).normalize();
		var rayData = new FlxRayData();
		directionVector.rotateByDegrees( -22.5);
		for (i in 0...100)
		{
			directionVector.rotateByDegrees(0.45);
			var ray = new FlxRay(lightSourceVector, lightSourceVector.addNew(directionVector), true);
			if (FlxOverlap.castRay(ray, lightGroup, rayData)) //Note that this will always return true in our case, since we have the boundary at the sides of the game window
				lightVertices[i].set(directionVector.x * rayData.start + lightSource.x, directionVector.y * rayData.start + lightSource.y);
		}
		lightVertices[100].set(lightSourceVector.x, lightSourceVector.y);
		FlxSpriteUtil.fill(light, 0x0);
		FlxSpriteUtil.drawPolygon(light, lightVertices, 0x4FFFFF00);
		
		directionVector.put();
	}
}