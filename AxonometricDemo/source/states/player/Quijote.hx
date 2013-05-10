package states.player;
import org.flixel.plugin.axonometricLib.axonometricSpriteBuilder.AxonometricSprite;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxObject;

/**
 * ...
 * @author ??, Jimmy Delas (Haxe port)
 */
class Quijote extends AxonometricSprite
{		
	//some variables to control the logic of control of the sprite, the library is indiependant of the game logic
	public var stillx:Bool;
	public var stilly:Bool;
	public var speed:Float ;
	public var jumpFrames        :Int;
	public var countjumpframes   :Bool;
	public var jumpOrder          :Bool;		
	public var jumpwithThisPower :Float;

	
	//initializes some variables
	public function new(){ 
		super();			
		offset.x = 39;
		offset.y = 74;											
		scale              = new FlxPoint(1, 1);
		loadGraphic("img_quijote", true, true, 80, 80);
		addAnimation("lance_walk",      [37,38,39,40]                         , 10   ,true  );
		addAnimation("lance_idle",      [37]                                  , 25   , true  );
		stillx = true;
		stilly = true;
		speed = 180;
		// these variables are flixel implemented physics engine
		// they are specified to the shadow, because its the one in charge of movement
		shadow.drag.x = speed*50;
		shadow.drag.y = speed*50;
		shadow.maxVelocity.x = speed;
		shadow.maxVelocity.y = speed;
		jumpFrames = 0;
		jumpOrder 		   = false;

		
	} 		
	
	public function isMovementKeysStill():Bool {
		return stillx && stilly;
	}


	override public function animate():Void {
		//keyboardAnim((x > FlxG.mouse.x), "jump", "lance_idle", "lance_walk");
		mouseAnim((x > FlxG.mouse.x), "jump", "lance_idle", "lance_walk");
	}
	
	public function mouseAnim(facingLeft:Bool,jumpanim:String,idleanim:String,moveanim:String):Void {
		facingLeft  ?  facing = FlxObject.LEFT : facing = FlxObject.RIGHT;
		
		if (jumping) {
			play(jumpanim);
		}else if (FlxG.mouse.pressed()) {
			play(moveanim);
		}else {
			play(idleanim);
		}
		
	}
	
	
	
	public function keyboardAnim(facingLeft:Bool,jumpanim:String,idleanim:String,moveanim:String):Void{
		facingLeft  ?  facing = FlxObject.LEFT : facing = FlxObject.RIGHT;
		if (jumping) {
			play(jumpanim);
		}else{
			if (isMovementKeysStill()) {
				play(idleanim);						
			}else {
				play(moveanim);
			}
		}
	}
	
	override public function moveOrder():Void {
		//movementformkeyboard();
		moovementformmouse();
		
		if (jumpOrder && !jumping) { jump_now(jumpwithThisPower, 320); }
		jumpOrder = false;			
		if(FlxG.keys.justPressed("SPACE") ){ countjumpframes = true ;}
		if (FlxG.keys.justReleased("SPACE")) { countjumpframes = false; setjump(jumpFrames > 20) ; jumpFrames = 0; }
		if (countjumpframes) {
			jumpFrames++;
		}
	}
	
	
	public function moovementformmouse():Void{
		var clickpoint:FlxPoint= new FlxPoint();
		var player:FlxPoint= new FlxPoint();
		var dir:FlxPoint = new FlxPoint();
		var angle:Float;
		
		if (FlxG.mouse.pressed()) {
							
			dir = new FlxPoint(
			FlxG.mouse.x-x
			,
			FlxG.mouse.y-y);
			
			angle = Math.atan2(dir.y, dir.x);
			
			shadow.velocity .x = Math.cos(angle) * speed;
			shadow.velocity .y = Math.sin(angle) * speed;
		}
	}
	
	public function movementformkeyboard():Void {
		stillx = true;
		stilly = true;			
		if (FlxG.keys.S ) { stillx = false; shadow.velocity.x += -speed; }
		if (FlxG.keys.F ) { stillx = false; shadow.velocity.x += speed; }
		if (FlxG.keys.E ) { stilly = false; shadow.velocity.y += -speed; }
		if (FlxG.keys.D ) { stilly = false; shadow.velocity.y += speed; }
	}
	
	public function setjump(superJump:Bool = false):Void
	{
		if(!jumping){
			jumpOrder = true;
			if (superJump) {
				jumpwithThisPower = 240;					
			}else {
				jumpwithThisPower = 180;					
			}
		}
	}
	
}