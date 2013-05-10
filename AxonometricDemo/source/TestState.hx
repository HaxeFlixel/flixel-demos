package;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;
import org.flixel.plugin.axonometricLib.AxonometricManager;
import org.flixel.FlxGroup;
import states.player.Quijote;

class TestState extends FlxState
{
	public var masterLayer:FlxGroup;
	public var tilemaps:FlxGroup;
	public var map:AxonometricManager;
	
	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff801c1b;
		#else
		FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		masterLayer = new FlxGroup();
		tilemaps = new  FlxGroup();
		map = new AxonometricManager(200, 300, Assets.getText("topography"));
		map.SetAsObliqueYX(120  * 2 * Math.PI / 360,true);
		FlxG.state.add(map);
		var quijote:Quijote = new Quijote();
		map.AddElement(4, 2, quijote);
		
		
		FlxG.camera.follow(quijote);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}	
}