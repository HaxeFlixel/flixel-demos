package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxRadialGauge;
import flixel.input.mouse.FlxMouseEvent;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;

using flixel.addons.display.FlxPieDial.FlxPieDialUtils;
/**
 * Demo for the soon to be added feature, FlxRadialGauge. Will replace FlxPieDial and this demo
 */
class GaugeEditorState extends flixel.FlxState
{
	final circleGauge:ShapeGaugeEditor;
	final squareGauge:DoubleGauge;
	final imageGauge:DoubleGauge;
	
	public function new ()
	{
		super();
		
		circleGauge = new ShapeGaugeEditor(FlxG.width * 0.5, FlxG.height * 0.5, CIRCLE, 100, 75, -225, 45);
		squareGauge = new DoubleGauge();
		squareGauge.makeShapeGraphic(SQUARE, 100, 75);
		squareGauge.color = FlxColor.LIME;
		squareGauge.back.color = FlxColor.BLACK;
		circleGauge.onRedraw.add(function ()
		{
			squareGauge.makeShapeGraphic(SQUARE, Math.round(circleGauge.radius), Math.round(circleGauge.innerRadius));
		});
		
		drawLogo();
		imageGauge = new DoubleGauge(FlxG.width * 0.5, FlxG.height * 0.5, "logo-200x200");
		imageGauge.x -= imageGauge.width;
		imageGauge.y -= imageGauge.height * 0.5;
		imageGauge.back.color = 0xFF909090;
	}
	
	function drawLogo()
	{
		final image = FlxG.bitmap.create(200, 200, 0x0, false, "logo-200x200");
		final logo = new openfl.display.Shape();
		flixel.system.FlxAssets.drawLogo(logo.graphics);
		final mat = new flixel.math.FlxMatrix();
		mat.scale(image.width / logo.width, image.height / logo.height);
		image.bitmap.draw(logo, mat);
	}
	
	override function create()
	{
		super.create();
		bgColor = FlxColor.GRAY;
		
		add(circleGauge);
		add(squareGauge);
		add(imageGauge);
	}
	
	override function draw()
	{
		squareGauge.amount = imageGauge.amount = circleGauge.getAmount();
		squareGauge.start = imageGauge.start = circleGauge.getStart();
		squareGauge.end = imageGauge.end = circleGauge.getEnd();
		final scale = 2 * circleGauge.radius / imageGauge.frameWidth;
		imageGauge.scale.set(scale, scale);
		imageGauge.updateHitbox();
		
		squareGauge.x = circleGauge.x - circleGauge.radius * 3 - 10;
		imageGauge.x = circleGauge.x + circleGauge.radius + 10;
		imageGauge.y = squareGauge.y = circleGauge.y - circleGauge.radius;
		
		super.draw();
	}
}

class DoubleGauge extends FlxRadialGauge
{
	public final back:FlxRadialGauge;
	public function new (x = 0.0, y = 0.0, ?graphic)
	{
		back = new FlxRadialGauge(x, y, graphic);
		
		super(x, y, graphic);
	}
	
	override function draw()
	{
		back.x = x;
		back.y = y;
		back.frames = frames;
		back.start = start;
		back.end = end;
		back.scale.copyFrom(scale);
		back.updateHitbox();
		back.draw();
		super.draw();
	}
}


/**
 * A visual editor for a FlxRadialGauge, has draggable objects that determine the gauge's properties
 */
class ShapeGaugeEditor extends flixel.group.FlxSpriteGroup
{
	public var shape:FlxRadialGaugeShape;
	public var radius = 0.0;
	public var innerRadius = 0.0;
	public var onRedraw = new FlxSignal();
	
	final gauge:DoubleGauge;
	final radiusHandle:DragHandle;
	final innerRadiusHandle:DragHandle;
	
	public function new (x = 0.0, y = 0.0, shape = CIRCLE, radius:Int, innerRadius:Int, start:Float, end:Float)
	{
		this.shape = shape;
		this.radius = radius;
		this.innerRadius = innerRadius;
		super(0, 0);
		
		add(gauge = new DoubleGauge(-radius, -radius));
		gauge.back.color = FlxColor.BLACK;
		gauge.color = FlxColor.LIME;
		
		// Helper point
		final pos = FlxPoint.get();
		pos.setPolarDegrees(radius, start);
		add(radiusHandle = new DragHandle(pos.x, pos.y, onRadiusChange));
		pos.setPolarDegrees(innerRadius, end);
		add(innerRadiusHandle = new DragHandle(pos.x, pos.y, onInnerRadiusChange));
		
		redraw();
		gauge.setOrientation(start, end);
		
		
		FlxTween.num(-0.1, 1.1, 2.0, {type: PINGPONG}, function (n)
		{
			final n = Math.min(1.0, Math.max(0.0, n));
			gauge.amount = n;
		});
		
		// Setting position after everything is added makes it easier to use relative positioning
		this.x = x;
		this.y = y;
		pos.put();
		
		#if debug
		FlxG.watch.addFunction("radius", ()->radius);
		FlxG.watch.addFunction("innerRadius", ()->innerRadius);
		FlxG.watch.addFunction("start", ()->gauge.start);
		FlxG.watch.addFunction("end", ()->gauge.end);
		FlxG.watch.addFunction("amount", ()->gauge.amount);
		#end
	}
	
	inline function redraw()
	{
		gauge.makeShapeGraphic(shape, Math.round(radius), Math.round(innerRadius));
		onRedraw.dispatch();
	}
	
	function onRadiusChange()
	{
		final dis = FlxPoint.get(radiusHandle.x - x, radiusHandle.y - y);
		radius = dis.length;
		redraw();
		gauge.x = x - radius;
		gauge.y = y - radius;
		gauge.start = validateAngle(dis.degrees);
		dis.put();
	}
	
	function onInnerRadiusChange()
	{
		final dis = FlxPoint.get(innerRadiusHandle.x - x, innerRadiusHandle.y - y);
		innerRadius = dis.length;
		redraw();
		gauge.end = validateAngle(dis.degrees);
		dis.put();
	}
	
	/** Convert angles so that the wrap point is directly down */
	inline function validateAngle(degrees:Float):Float
	{
		return ((degrees + 270) % 360) - 270;
	}
	
	inline public function getStart()
	{
		return gauge.start;
	}
	
	inline public function getEnd()
	{
		return gauge.end;
	}
	
	inline public function getAmount()
	{
		return gauge.amount;
	}
}

class DragHandle extends FlxSprite
{
	static inline final RADIUS = 10;
	static inline final OUTLINE = 2;
	static inline final KEY = 'drag-handle-$RADIUS';
	static inline final OVER_COLOR = FlxColor.WHITE;
	static inline final OUT_COLOR = 0xFFeeeeee;
	
	static function getGraphic()
	{
		// Use existing graphic, if it exists
		final graphic = FlxG.bitmap.get(KEY);
		if (graphic != null)
			return graphic;
		
		// Generate graphic
		final graphic =  FlxG.bitmap.create(RADIUS * 2, RADIUS * 2, 0x0, false, KEY);
		graphic.bitmap.drawCircle(RADIUS, FlxColor.BLACK);
		graphic.bitmap.drawCircle(RADIUS - OUTLINE, FlxColor.WHITE);
		return graphic;
	}
	
	/** Called whenever the handle moves */
	public var onChange:()->Void;
	
	/** Whether this is currently being dragged */
	public var dragging(default, null):Bool = false;
	
	public function new (x = 0.0, y = 0.0, onChange:()->Void)
	{
		this.onChange = onChange;
		super(x, y, getGraphic());
		offset.set(RADIUS, RADIUS);
		color = OUT_COLOR;
		
		/* 
		 * Track mouse dragging via FlxMouseEvent, as it prevents the user from
		 * being able to select more than one, with a single click
		 */
		FlxMouseEvent.add(this,
			(_)->dragging = true, // onMouseDown
			null, // onMouseUp: handled via update
			(_)->color = OVER_COLOR, // onMouseOver
			(_)->color = OUT_COLOR, // onMouseOver
			false, // moueChildren: Whether other objects overlapped by this will still receive mouse events
			true, // mouseEnabled: Whether this object will receive mouse events
			true // pixelPerfect: Whether to ignore the graphic's alpha pixels
		);
		
		#if debug
		ignoreDrawDebug = true;
		#end
	}
	
	function moveToMouse()
	{
		x = FlxG.mouse.x;
		y = FlxG.mouse.y;
		onChange();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (dragging)
		{
			// Stop dragging
			if (FlxG.mouse.justReleased)
				dragging = false;
			
			if (FlxG.mouse.justMoved)
				moveToMouse();
		}
	}
}