#if nme

import Main;
import nme.Assets;
import nme.events.Event;


class ApplicationMain {
	
	static var mPreloader:NMEPreloader;

	public static function main () {
		
		var call_real = true;
		
		
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		
		nme.Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
		nme.Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		
		if (loaded < total || true) /* Always wait for event */ {
			
			call_real = false;
			mPreloader = new org.flixel.system.FlxPreloader();
			nme.Lib.current.addChild(mPreloader);
			mPreloader.onInit();
			mPreloader.onUpdate(loaded,total);
			nme.Lib.current.addEventListener (nme.events.Event.ENTER_FRAME, onEnter);
			
		}
		
		
		#if !fdb
		haxe.Log.trace = flashTrace;
		#end
		
		if (call_real)
			begin ();
	}

	#if !fdb
	private static function flashTrace( v : Dynamic, ?pos : haxe.PosInfos ) {
		var className = pos.className.substr(pos.className.lastIndexOf('.') + 1);
		var message = className+"::"+pos.methodName+":"+pos.lineNumber+": " + v;
		
        if (flash.external.ExternalInterface.available)
			flash.external.ExternalInterface.call("console.log", message);
		else untyped flash.Boot.__trace(v, pos);
    }
	#end
	
	private static function begin () {
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields(Main))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}
		
		if (hasMain)
		{
			Reflect.callMethod (Main, Reflect.field (Main, "main"), []);
		}
		else
		{
			var instance = Type.createInstance(Main, []);
			if (Std.is (instance, nme.display.DisplayObject)) {
				nme.Lib.current.addChild(cast instance);
			}	
		}
		
	}

	static function onEnter (_) {
		
		var loaded = nme.Lib.current.loaderInfo.bytesLoaded;
		var total = nme.Lib.current.loaderInfo.bytesTotal;
		mPreloader.onUpdate(loaded,total);
		
		if (loaded >= total) {
			
			nme.Lib.current.removeEventListener(nme.events.Event.ENTER_FRAME, onEnter);
			mPreloader.addEventListener (Event.COMPLETE, preloader_onComplete);
			mPreloader.onLoaded();
			
		}
		
	}

	public static function getAsset (inName:String):Dynamic {
		
		
		if (inName=="Beep")
			 
            return Assets.getSound ("Beep");
         
		
		if (inName=="assets/axonometricLib/axonometricLibInclude.nmml")
			 
			 return Assets.getText ("assets/axonometricLib/axonometricLibInclude.nmml");
         
		
		if (inName=="assets/axonometricLib/grounddirt.png")
			 
            return Assets.getBitmapData ("assets/axonometricLib/grounddirt.png");
         
		
		if (inName=="assets/axonometricLib/oval_shadow_anim.png")
			 
            return Assets.getBitmapData ("assets/axonometricLib/oval_shadow_anim.png");
         
		
		if (inName=="assets/axonometricLib/tile_town.png")
			 
            return Assets.getBitmapData ("assets/axonometricLib/tile_town.png");
         
		
		if (inName=="assets/data/autotiles.png")
			 
            return Assets.getBitmapData ("assets/data/autotiles.png");
         
		
		if (inName=="assets/data/autotiles_alt.png")
			 
            return Assets.getBitmapData ("assets/data/autotiles_alt.png");
         
		
		if (inName=="assets/data/base.png")
			 
            return Assets.getBitmapData ("assets/data/base.png");
         
		
		if (inName=="assets/data/beep.mp3")
			 
            return Assets.getSound ("assets/data/beep.mp3");
		 
		
		if (inName=="assets/data/button.png")
			 
            return Assets.getBitmapData ("assets/data/button.png");
         
		
		if (inName=="assets/data/button_a.png")
			 
            return Assets.getBitmapData ("assets/data/button_a.png");
         
		
		if (inName=="assets/data/button_b.png")
			 
            return Assets.getBitmapData ("assets/data/button_b.png");
         
		
		if (inName=="assets/data/button_c.png")
			 
            return Assets.getBitmapData ("assets/data/button_c.png");
         
		
		if (inName=="assets/data/button_down.png")
			 
            return Assets.getBitmapData ("assets/data/button_down.png");
         
		
		if (inName=="assets/data/button_left.png")
			 
            return Assets.getBitmapData ("assets/data/button_left.png");
         
		
		if (inName=="assets/data/button_right.png")
			 
            return Assets.getBitmapData ("assets/data/button_right.png");
         
		
		if (inName=="assets/data/button_up.png")
			 
            return Assets.getBitmapData ("assets/data/button_up.png");
         
		
		if (inName=="assets/data/button_x.png")
			 
            return Assets.getBitmapData ("assets/data/button_x.png");
         
		
		if (inName=="assets/data/button_y.png")
			 
            return Assets.getBitmapData ("assets/data/button_y.png");
         
		
		if (inName=="assets/data/courier.ttf")
			 
			 return Assets.getFont ("assets/data/courier.ttf");
		 
		
		if (inName=="assets/data/cursor.png")
			 
            return Assets.getBitmapData ("assets/data/cursor.png");
         
		
		if (inName=="assets/data/default.png")
			 
            return Assets.getBitmapData ("assets/data/default.png");
         
		
		if (inName=="assets/data/fontData10pt.png")
			 
            return Assets.getBitmapData ("assets/data/fontData10pt.png");
         
		
		if (inName=="assets/data/fontData11pt.png")
			 
            return Assets.getBitmapData ("assets/data/fontData11pt.png");
         
		
		if (inName=="assets/data/handle.png")
			 
            return Assets.getBitmapData ("assets/data/handle.png");
         
		
		if (inName=="assets/data/logo.png")
			 
            return Assets.getBitmapData ("assets/data/logo.png");
         
		
		if (inName=="assets/data/logo_corners.png")
			 
            return Assets.getBitmapData ("assets/data/logo_corners.png");
         
		
		if (inName=="assets/data/logo_light.png")
			 
            return Assets.getBitmapData ("assets/data/logo_light.png");
         
		
		if (inName=="assets/data/nokiafc22.ttf")
			 
			 return Assets.getFont ("assets/data/nokiafc22.ttf");
		 
		
		if (inName=="assets/data/stick.png")
			 
            return Assets.getBitmapData ("assets/data/stick.png");
         
		
		if (inName=="assets/data/vcr/flixel.png")
			 
            return Assets.getBitmapData ("assets/data/vcr/flixel.png");
         
		
		if (inName=="assets/data/vcr/open.png")
			 
            return Assets.getBitmapData ("assets/data/vcr/open.png");
         
		
		if (inName=="assets/data/vcr/pause.png")
			 
            return Assets.getBitmapData ("assets/data/vcr/pause.png");
         
		
		if (inName=="assets/data/vcr/play.png")
			 
            return Assets.getBitmapData ("assets/data/vcr/play.png");
         
		
		if (inName=="assets/data/vcr/record_off.png")
			 
            return Assets.getBitmapData ("assets/data/vcr/record_off.png");
         
		
		if (inName=="assets/data/vcr/record_on.png")
			 
            return Assets.getBitmapData ("assets/data/vcr/record_on.png");
         
		
		if (inName=="assets/data/vcr/restart.png")
			 
            return Assets.getBitmapData ("assets/data/vcr/restart.png");
         
		
		if (inName=="assets/data/vcr/step.png")
			 
            return Assets.getBitmapData ("assets/data/vcr/step.png");
         
		
		if (inName=="assets/data/vcr/stop.png")
			 
            return Assets.getBitmapData ("assets/data/vcr/stop.png");
         
		
		if (inName=="assets/data/vis/bounds.png")
			 
            return Assets.getBitmapData ("assets/data/vis/bounds.png");
         
		
		if (inName=="assets/Geography.csv")
			 
			 return Assets.getText ("assets/Geography.csv");
         
		
		if (inName=="assets/HaxeFlixel.svg")
			 
			 return Assets.getText ("assets/HaxeFlixel.svg");
         
		
		if (inName=="assets/Sprite/Character/bot.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Character/bot.png");
         
		
		if (inName=="assets/Sprite/Character/claws.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Character/claws.png");
         
		
		if (inName=="assets/Sprite/Character/pre_quijote.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Character/pre_quijote.png");
         
		
		if (inName=="assets/Sprite/Character/quijote.jpg")
			 
            return Assets.getBitmapData ("assets/Sprite/Character/quijote.jpg");
         
		
		if (inName=="assets/Sprite/Character/quijote.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Character/quijote.png");
         
		
		if (inName=="assets/Sprite/Character/save_pre_quijote.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Character/save_pre_quijote.png");
         
		
		if (inName=="assets/Sprite/Character/spaceman.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Character/spaceman.png");
         
		
		if (inName=="assets/Sprite/Explotion/punch.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Explotion/punch.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/arrow_game.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/arrow_game.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/bot_bullet.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/bot_bullet.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/bullet.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/bullet.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/coin.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/coin.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/door.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/door.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/gibs.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/gibs.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/Grape_icon.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/Grape_icon.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/jet.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/jet.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/lock.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/lock.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/oval_shadow.jpg")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/oval_shadow.jpg");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/oval_shadow.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/oval_shadow.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/SHADOW.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/SHADOW.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/SHADOW_32.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/SHADOW_32.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/spawner.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/spawner.png");
         
		
		if (inName=="assets/Sprite/Items/Dynamic/spawner_gibs.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Dynamic/spawner_gibs.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Background/Avatars.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Background/Avatars.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Background/background_chat.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Background/background_chat.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Background/moon_background.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Background/moon_background.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Background/scroll_page.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Background/scroll_page.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/5.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/5.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/6.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/6.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/7.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/7.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/8.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/8.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/book.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/book.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/Crafting_anvil.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/Crafting_anvil.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/miniframe.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/miniframe.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/rock1.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/rock1.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/rock2.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/rock2.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/t0.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/t0.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/t1.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/t1.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/t2.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/t2.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/t3.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/t3.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/t4.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/t4.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/tre1.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/tre1.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/tree2.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/tree2.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Ornament/trees.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Ornament/trees.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Texture/bgtiles.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Texture/bgtiles.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Texture/black.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Texture/black.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Texture/dirt.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Texture/dirt.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Texture/dirt_top.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Texture/dirt_top.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Texture/grounddirt.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Texture/grounddirt.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Texture/rocks.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Texture/rocks.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Texture/tech_tiles.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Texture/tech_tiles.png");
         
		
		if (inName=="assets/Sprite/Items/Static/Texture/tile_town.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Items/Static/Texture/tile_town.png");
         
		
		if (inName=="assets/Sprite/Mouse/cursor.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Mouse/cursor.png");
         
		
		if (inName=="assets/Sprite/Trigger/big purple.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/big purple.png");
         
		
		if (inName=="assets/Sprite/Trigger/biggray.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/biggray.png");
         
		
		if (inName=="assets/Sprite/Trigger/blue.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/blue.png");
         
		
		if (inName=="assets/Sprite/Trigger/brawl.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/brawl.png");
         
		
		if (inName=="assets/Sprite/Trigger/chat.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/chat.png");
         
		
		if (inName=="assets/Sprite/Trigger/Empty.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/Empty.png");
         
		
		if (inName=="assets/Sprite/Trigger/emptyTrigger.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/emptyTrigger.png");
         
		
		if (inName=="assets/Sprite/Trigger/end_level.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/end_level.png");
         
		
		if (inName=="assets/Sprite/Trigger/green.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/green.png");
         
		
		if (inName=="assets/Sprite/Trigger/limit DEBUG.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/limit DEBUG.png");
         
		
		if (inName=="assets/Sprite/Trigger/limit.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/limit.png");
         
		
		if (inName=="assets/Sprite/Trigger/red.png")
			 
            return Assets.getBitmapData ("assets/Sprite/Trigger/red.png");
         
		
		if (inName=="assets/Topography.csv")
			 
			 return Assets.getText ("assets/Topography.csv");
         
		
		if (inName=="axonometric_grounddirt")
			 
            return Assets.getBitmapData ("axonometric_grounddirt");
         
		
		if (inName=="axonometric_tile_town")
			 
            return Assets.getBitmapData ("axonometric_tile_town");
         
		
		if (inName=="axonometric_oval_shadow_anim")
			 
            return Assets.getBitmapData ("axonometric_oval_shadow_anim");
         
		
		if (inName=="img_quijote")
			 
            return Assets.getBitmapData ("img_quijote");
         
		
		if (inName=="topography")
			 
			 return Assets.getText ("topography");
         
		
		if (inName=="geography")
			 
			 return Assets.getText ("geography");
         
		
		
		return null;
		
	}
	
	
	private static function preloader_onComplete (event:Event):Void {
		
		mPreloader.removeEventListener (Event.COMPLETE, preloader_onComplete);
		
		nme.Lib.current.removeChild(mPreloader);
		mPreloader = null;
		
		begin ();
		
	}
	
}

class NME_assets_data_beep_mp3 extends nme.media.Sound { }
class NME_assets_axonometriclib_axonometriclibinclude_nmml extends nme.utils.ByteArray { }
class NME_assets_axonometriclib_grounddirt_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_axonometriclib_oval_shadow_anim_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_axonometriclib_tile_town_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_autotiles_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_autotiles_alt_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_base_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_beep_mp4 extends nme.media.Sound { }
class NME_assets_data_button_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_button_a_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_button_b_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_button_c_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_button_down_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_button_left_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_button_right_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_button_up_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_button_x_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_button_y_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_courier_ttf extends nme.text.Font { }
class NME_assets_data_cursor_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_default_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_fontdata10pt_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_fontdata11pt_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_handle_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_logo_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_logo_corners_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_logo_light_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_nokiafc22_ttf extends nme.text.Font { }
class NME_assets_data_stick_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vcr_flixel_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vcr_open_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vcr_pause_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vcr_play_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vcr_record_off_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vcr_record_on_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vcr_restart_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vcr_step_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vcr_stop_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_data_vis_bounds_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_geography_csv extends nme.utils.ByteArray { }
class NME_assets_haxeflixel_svg extends nme.utils.ByteArray { }
class NME_assets_sprite_character_bot_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_character_claws_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_character_pre_quijote_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_character_quijote_jpg extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_character_quijote_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_character_save_pre_quijote_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_character_spaceman_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_explotion_punch_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_arrow_game_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_bot_bullet_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_bullet_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_coin_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_door_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_gibs_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_grape_icon_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_jet_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_lock_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_oval_shadow_jpg extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_oval_shadow_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_shadow_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_shadow_32_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_spawner_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_dynamic_spawner_gibs_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_background_avatars_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_background_background_chat_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_background_moon_background_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_background_scroll_page_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_5_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_6_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_7_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_8_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_book_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_crafting_anvil_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_miniframe_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_rock1_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_rock2_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_t0_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_t1_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_t2_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_t3_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_t4_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_tre1_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_tree2_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_ornament_trees_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_texture_bgtiles_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_texture_black_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_texture_dirt_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_texture_dirt_top_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_texture_grounddirt_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_texture_rocks_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_texture_tech_tiles_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_items_static_texture_tile_town_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_mouse_cursor_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_big_purple_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_biggray_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_blue_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_brawl_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_chat_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_empty_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_emptytrigger_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_end_level_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_green_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_limit_debug_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_limit_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_trigger_red_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_topography_csv extends nme.utils.ByteArray { }
class NME_assets_axonometriclib_grounddirt_png1 extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_axonometriclib_tile_town_png1 extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_axonometriclib_oval_shadow_anim_png1 extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_sprite_character__quijote_png extends nme.display.BitmapData { public function new () { super (0, 0); } }
class NME_assets_topography_csv1 extends nme.utils.ByteArray { }
class NME_assets_geography_csv1 extends nme.utils.ByteArray { }


#else

import Main;

class ApplicationMain {
	
	public static function main () {
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields(Main))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}
		
		if (hasMain)
		{
			Reflect.callMethod (Main, Reflect.field (Main, "main"), []);
		}
		else
		{
			var instance = Type.createInstance(Main, []);
			if (Std.is (instance, flash.display.DisplayObject)) {
				flash.Lib.current.addChild(cast instance);
			}
		}
		
	}

}

#end
