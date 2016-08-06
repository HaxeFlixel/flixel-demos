package states.player;
import org.flixel.FlxPoint;
import org.flixel.FlxG;
import org.flixel.FlxU;

/**
 * ...
 * @author ??, Jimmy Delas (Haxe port)
 */
class MouseGestureDetect
{
	public static var _NORMAL             :Int=0;
	public static var _UP                 :Int=4;
	public static var _DOWN               :Int=5;
	public static var _LEFT               :Int=6;
	public static var _RIGHT              :Int=7;
	public static var _CHARGED            :Int=8;

	private var mouseGesture       :Int;
	public var prev_mouseGesture  :Int;
	public var MouseGestureRadius :Int=30;		
	public var MouseHoldThreshHold:Int= 20;
	public var framesMouseHolded  :Int;
	public var MouseAngle         :Int=0;
	public var MousebeforePoint   :FlxPoint;
	public var MouseafterPoint    :FlxPoint;
	public var new_gesture        :Bool;

	public function clean_vars():Void{
		prev_mouseGesture  = mouseGesture;
		mouseGesture       = -1;
		new_gesture        = false;
	}

	public function get_actual_mousegesture():Int {
		clean_vars();
		return prev_mouseGesture;
	}
	
	
	public function MouseGestureDetect() {
		new_gesture = false;
		mouseGesture   = -1; 
		MousebeforePoint  = new FlxPoint(0, 0);
		MouseafterPoint   = new FlxPoint(0, 0);	
	}
	
	public function getmousegesture():Void {
		if (FlxG.mouse.justPressed()) {
			framesMouseHolded = 0;
			MousebeforePoint.x = FlxG.mouse.screenX;
			MousebeforePoint.y = FlxG.mouse.screenY;
		}
		if (FlxG.mouse.pressed()) {
			framesMouseHolded++;
		}
		if (FlxG.mouse.justReleased()) {
			if (
				(
				(MousebeforePoint.x - FlxG.mouse.screenX) * (MousebeforePoint.x - FlxG.mouse.screenX)
				+
				(MousebeforePoint.y - FlxG.mouse.screenY) * (MousebeforePoint.y - FlxG.mouse.screenY) 
				)
				>
				(MouseGestureRadius*MouseGestureRadius)
			) {//Se obtiene el gesto selecionado
				MouseafterPoint.x  = FlxG.mouse.screenX;
				MouseafterPoint.y  = FlxG.mouse.screenY;					
				MouseAngle = FlxU.getAngle(MouseafterPoint, MousebeforePoint);
				
				 if      (  MouseAngle >  -135 && MouseAngle <= -45 ) {//Derecha
					mouseGesture=  _RIGHT;
				}else if (  MouseAngle >  -45  && MouseAngle <=  45 ) {//Abajo
					mouseGesture=  _DOWN;
				}else if (  MouseAngle >   45  && MouseAngle <=  135) {//Izquierda
					mouseGesture=  _LEFT;
				}else {                                                //Arriba
					mouseGesture=  _UP;
				}
			}else {//son los ataques normales
				if (framesMouseHolded > MouseHoldThreshHold) {         //Cargado
					mouseGesture=  _CHARGED;
				}else {
					mouseGesture=  _NORMAL;                            //Normal
				}
			}
			new_gesture = true;
		}
	}

	
}