package states;
import flash.display.Graphics;
import flash.geom.Rectangle;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.system.layer.frames.FlxFrame;
import flixel.text.FlxText;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Shape;

/**
 * ...
 * @author TiagoLr (~~~ ProG4mr ~~~)
 * @link https://github.com/ProG4mr
 */
class Balloons extends FlxNapeState
{
	private inline static var WIRE_MAX_LENGTH = 200;
	private inline static var NUM_BALLOONS = 7;
	private inline static var NUM_SEGMENTS = 10;
	public static var CB_BALLOON:CbType = new CbType();
	
	
	var listBalloons:Array<Balloon>;
	private var shooter:Shooter;
	var wiresSprite:FlxSprite; // Sprite that shows the wires graphics.
	var wires:Array<Wire>;
	var box:FlxNapeSprite;
	
	override public function create():Void 
	{
		super.create();
		
		add(new FlxSprite(0, 0, "assets/BalloonsBground.jpg"));
		
		// Sets gravity.
		FlxNapeState.space.gravity.setxy(0, 500);
		napeDebugEnabled = false;
		
		createWalls();
		
		createBalloons();
		createBox();
		createWires();
		
		shooter = new Shooter();
		shooter.setDensity(0.3);
		add(shooter);
		
		FlxNapeState.space.listeners.add(new InteractionListener(CbEvent.BEGIN, 
													 InteractionType.COLLISION, 
													 Shooter.CB_BULLET,
													 Balloons.CB_BALLOON,
													 onBulletColides));
	 
		shooter.registerPhysSprite(box);
		
		for (b in listBalloons)
		{
			shooter.registerPhysSprite(b);
		}
		
		var txt:FlxText;
		txt = new FlxText( -10, 5, 640, "      'R' - reset state, 'G' - toggle physics graphics");
		add(txt);
		txt = new FlxText( -10, 20, 640, "      'LEFT' & 'RIGHT' - switch demo");
		add(txt);
	}
	
	function onBulletColides(i:InteractionCallback) 
	{
		var b:Balloon = cast(i.int2, Body).userData.data;
		b.onCollide();
		listBalloons.remove(b);
	}
	
	function createBalloons() 
	{
		wiresSprite = new FlxSprite();
		wiresSprite.makeGraphic(640, 480, 0x0);
		add(wiresSprite);
		
		listBalloons = new Array<Balloon>();
		for (i in 0...NUM_BALLOONS)
		{
			var b:Balloon = new Balloon(Std.int(FlxG.width * 0.5 - 50 * 2.5 + 50 * i - 25), 300);
			listBalloons.push(b);
			add(b);
		}
	}
	
	function createBox() 
	{
		box = new FlxNapeSprite(FlxG.width * 0.5 - 27, 480 - 27, "assets/box.png");
		box.antialiasing = true;
		box.setBodyMaterial(1, .2, .4, .5);
		add(box);
	}
	
	// Wires are distance joints between balloons and box.
	function createWires()
	{
		wires = new Array<Wire>();
		
		for (b in listBalloons)
		{
			var yOffsetBox:Vec2 = new Vec2(0, -25);
			var yOffsetB:Vec2 = new Vec2(0, 25);
		
			var wire:Wire = new Wire(box.body, b.body, yOffsetBox.add(box.body.localCOM), yOffsetB.add(b.body.localCOM), WIRE_MAX_LENGTH, NUM_SEGMENTS);
			wires.push(wire);
			
		}
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		for (b in listBalloons)
		{
			b.body.applyImpulse(new Vec2(0, -25));
		}
		
		for (wire in wires)
		{
			wire.draw();
		}

		var gfx:Graphics = FlxSpriteUtil.flashGfxSprite.graphics;
		gfx.clear();
		for (wire in wires)
		{
			wire.draw();
		}
		
		// Copies generated graphics to flxSprite.
		wiresSprite.pixels.fillRect(new Rectangle(0, 0, 640, 480), 0x0);
		FlxSpriteUtil.updateSpriteGraphic(wiresSprite);
		
		// Input handling
		if (FlxG.keys.justPressed.G)
			napeDebugEnabled = !napeDebugEnabled;
			
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
			
		if (FlxG.keys.justPressed.LEFT)
			FlxPhysicsDemo.prevState();
		if (FlxG.keys.justPressed.RIGHT)
			FlxPhysicsDemo.nextState();
			
		if (FlxG.keys.pressed.W)
			box.body.position.y -= 10;
		if (FlxG.keys.pressed.A)
			box.body.position.x -= 10;
		if (FlxG.keys.pressed.S)
			box.body.position.y += 10;
		if (FlxG.keys.pressed.D)
			box.body.position.x += 10;
		// end 
	}
	
}

// Set of connected bodies to form a rope.
class Wire
{
	
	public var joints:Array<DistanceJoint>; 		// Used to draw the wire.
	
	public function new(body1:Body, body2:Body, anchor1:Vec2, anchor2:Vec2, maxDist:Float, segments:Int)
	{	
		joints = new Array<DistanceJoint>();
		
		var circle:Body;
		var startPos:Vec2;
		var distX:Float;
		var distY:Float;
		var distJoint:DistanceJoint;
		
		if (segments < 2) segments = 2;
		if (maxDist < 10) maxDist = 10;
		
		distX = body2.position.x - body1.position.x;
		distY = body2.position.y - body2.position.y;
		
		for (i in 1...segments)
		{
			startPos = new Vec2(body1.position.x + distX / (i + 1), body1.position.y + distY / (i + 1)); 		// defines starting position.
			
			circle = new Body(BodyType.DYNAMIC, startPos);
			circle.shapes.add(new Circle(5));
			circle.space = FlxNapeState.space;
			circle.shapes.at(0).filter.collisionGroup = 2; 					// Belongs to group 2.
			circle.shapes.at(0).filter.collisionMask = ~2; 					// Ignores group 2.
			
			distJoint = new DistanceJoint(body1, circle, anchor1, circle.localCOM, 0, maxDist / segments);
			distJoint.frequency = 5;
			distJoint.space = FlxNapeState.space;
			
			body1 = circle;
			anchor1 = body1.localCOM;
			joints.push(distJoint);
		}
		
		distJoint = new DistanceJoint(body1, body2, body1.localCOM, anchor2, 0, maxDist / segments); 		// body1 is the last circle at this point
		distJoint.frequency = 5;
		distJoint.space = FlxNapeState.space;
		joints.push(distJoint);
		
	}
	
	public function draw()
	{
		var from:Vec2;
		var to:Vec2;
		var gfx:Graphics = FlxSpriteUtil.flashGfxSprite.graphics;
		gfx.lineStyle(1, 0x0);
		
		
		for (joint in joints)
		{
			from = joint.body1.localPointToWorld(joint.anchor1);
			to = joint.body2.localPointToWorld(joint.anchor2);
			gfx.moveTo(from.x, from.y); 
			gfx.lineTo(to.x, to.y);
		}
		
	}
}

class Balloon extends FlxNapeSprite
{
	public function new(X:Int, Y:Int)
	{
		super(X, Y);
		loadGraphic("assets/Balloon.png", true, false, 68, 68);
		
		this.animation.frameIndex = FlxRandom.intRanged(0, 6);
		
		antialiasing = true;
		createCircularBody(25);
		var circle = new Circle(5);
		circle.translate(new Vec2(0, 25));
		circle.material = new Material(0.2, 1.0, 1.4, 0.1, 0.01);
		circle.filter.collisionGroup = 256;
		
		body.shapes.add(circle);
		body.cbTypes.add(Balloons.CB_BALLOON);
		body.userData.data = this;
		
		body.shapes.at(0).material.density = .5;
		body.shapes.at(0).material.dynamicFriction = 0;
	}
	
	public function onCollide() 
	{
		body.shapes.pop();
		this.animation.frameIndex += 7;
	}
}