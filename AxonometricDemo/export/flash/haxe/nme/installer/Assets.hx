package nme.installer;


import format.display.MovieClip;
import haxe.Unserializer;
import nme.display.BitmapData;
import nme.media.Sound;
import nme.net.URLRequest;
import nme.text.Font;
import nme.utils.ByteArray;
import ApplicationMain;

#if swf
import format.SWF;
#end

#if xfl
import format.XFL;
#end


/**
 * ...
 * @author Joshua Granick
 */

class Assets {

	
	public static var cachedBitmapData:Hash<BitmapData> = new Hash<BitmapData>();
	#if swf private static var cachedSWFLibraries:Hash <SWF> = new Hash <SWF> (); #end
	#if xfl private static var cachedXFLLibraries:Hash <XFL> = new Hash <XFL> (); #end
	
	private static var initialized:Bool = false;
	private static var libraryTypes:Hash <String> = new Hash <String> ();
	private static var resourceClasses:Hash <Dynamic> = new Hash <Dynamic> ();
	private static var resourceTypes:Hash <String> = new Hash <String> ();
	
	
	private static function initialize ():Void {
		
		if (!initialized) {
			
			resourceClasses.set ("Beep", NME_assets_data_beep_mp3);
			resourceTypes.set ("Beep", "sound");
			resourceClasses.set ("assets/axonometricLib/axonometricLibInclude.nmml", NME_assets_axonometriclib_axonometriclibinclude_nmml);
			resourceTypes.set ("assets/axonometricLib/axonometricLibInclude.nmml", "text");
			resourceClasses.set ("assets/axonometricLib/grounddirt.png", NME_assets_axonometriclib_grounddirt_png);
			resourceTypes.set ("assets/axonometricLib/grounddirt.png", "image");
			resourceClasses.set ("assets/axonometricLib/oval_shadow_anim.png", NME_assets_axonometriclib_oval_shadow_anim_png);
			resourceTypes.set ("assets/axonometricLib/oval_shadow_anim.png", "image");
			resourceClasses.set ("assets/axonometricLib/tile_town.png", NME_assets_axonometriclib_tile_town_png);
			resourceTypes.set ("assets/axonometricLib/tile_town.png", "image");
			resourceClasses.set ("assets/data/autotiles.png", NME_assets_data_autotiles_png);
			resourceTypes.set ("assets/data/autotiles.png", "image");
			resourceClasses.set ("assets/data/autotiles_alt.png", NME_assets_data_autotiles_alt_png);
			resourceTypes.set ("assets/data/autotiles_alt.png", "image");
			resourceClasses.set ("assets/data/base.png", NME_assets_data_base_png);
			resourceTypes.set ("assets/data/base.png", "image");
			resourceClasses.set ("assets/data/beep.mp3", NME_assets_data_beep_mp4);
			resourceTypes.set ("assets/data/beep.mp3", "music");
			resourceClasses.set ("assets/data/button.png", NME_assets_data_button_png);
			resourceTypes.set ("assets/data/button.png", "image");
			resourceClasses.set ("assets/data/button_a.png", NME_assets_data_button_a_png);
			resourceTypes.set ("assets/data/button_a.png", "image");
			resourceClasses.set ("assets/data/button_b.png", NME_assets_data_button_b_png);
			resourceTypes.set ("assets/data/button_b.png", "image");
			resourceClasses.set ("assets/data/button_c.png", NME_assets_data_button_c_png);
			resourceTypes.set ("assets/data/button_c.png", "image");
			resourceClasses.set ("assets/data/button_down.png", NME_assets_data_button_down_png);
			resourceTypes.set ("assets/data/button_down.png", "image");
			resourceClasses.set ("assets/data/button_left.png", NME_assets_data_button_left_png);
			resourceTypes.set ("assets/data/button_left.png", "image");
			resourceClasses.set ("assets/data/button_right.png", NME_assets_data_button_right_png);
			resourceTypes.set ("assets/data/button_right.png", "image");
			resourceClasses.set ("assets/data/button_up.png", NME_assets_data_button_up_png);
			resourceTypes.set ("assets/data/button_up.png", "image");
			resourceClasses.set ("assets/data/button_x.png", NME_assets_data_button_x_png);
			resourceTypes.set ("assets/data/button_x.png", "image");
			resourceClasses.set ("assets/data/button_y.png", NME_assets_data_button_y_png);
			resourceTypes.set ("assets/data/button_y.png", "image");
			resourceClasses.set ("assets/data/courier.ttf", NME_assets_data_courier_ttf);
			resourceTypes.set ("assets/data/courier.ttf", "font");
			resourceClasses.set ("assets/data/cursor.png", NME_assets_data_cursor_png);
			resourceTypes.set ("assets/data/cursor.png", "image");
			resourceClasses.set ("assets/data/default.png", NME_assets_data_default_png);
			resourceTypes.set ("assets/data/default.png", "image");
			resourceClasses.set ("assets/data/fontData10pt.png", NME_assets_data_fontdata10pt_png);
			resourceTypes.set ("assets/data/fontData10pt.png", "image");
			resourceClasses.set ("assets/data/fontData11pt.png", NME_assets_data_fontdata11pt_png);
			resourceTypes.set ("assets/data/fontData11pt.png", "image");
			resourceClasses.set ("assets/data/handle.png", NME_assets_data_handle_png);
			resourceTypes.set ("assets/data/handle.png", "image");
			resourceClasses.set ("assets/data/logo.png", NME_assets_data_logo_png);
			resourceTypes.set ("assets/data/logo.png", "image");
			resourceClasses.set ("assets/data/logo_corners.png", NME_assets_data_logo_corners_png);
			resourceTypes.set ("assets/data/logo_corners.png", "image");
			resourceClasses.set ("assets/data/logo_light.png", NME_assets_data_logo_light_png);
			resourceTypes.set ("assets/data/logo_light.png", "image");
			resourceClasses.set ("assets/data/nokiafc22.ttf", NME_assets_data_nokiafc22_ttf);
			resourceTypes.set ("assets/data/nokiafc22.ttf", "font");
			resourceClasses.set ("assets/data/stick.png", NME_assets_data_stick_png);
			resourceTypes.set ("assets/data/stick.png", "image");
			resourceClasses.set ("assets/data/vcr/flixel.png", NME_assets_data_vcr_flixel_png);
			resourceTypes.set ("assets/data/vcr/flixel.png", "image");
			resourceClasses.set ("assets/data/vcr/open.png", NME_assets_data_vcr_open_png);
			resourceTypes.set ("assets/data/vcr/open.png", "image");
			resourceClasses.set ("assets/data/vcr/pause.png", NME_assets_data_vcr_pause_png);
			resourceTypes.set ("assets/data/vcr/pause.png", "image");
			resourceClasses.set ("assets/data/vcr/play.png", NME_assets_data_vcr_play_png);
			resourceTypes.set ("assets/data/vcr/play.png", "image");
			resourceClasses.set ("assets/data/vcr/record_off.png", NME_assets_data_vcr_record_off_png);
			resourceTypes.set ("assets/data/vcr/record_off.png", "image");
			resourceClasses.set ("assets/data/vcr/record_on.png", NME_assets_data_vcr_record_on_png);
			resourceTypes.set ("assets/data/vcr/record_on.png", "image");
			resourceClasses.set ("assets/data/vcr/restart.png", NME_assets_data_vcr_restart_png);
			resourceTypes.set ("assets/data/vcr/restart.png", "image");
			resourceClasses.set ("assets/data/vcr/step.png", NME_assets_data_vcr_step_png);
			resourceTypes.set ("assets/data/vcr/step.png", "image");
			resourceClasses.set ("assets/data/vcr/stop.png", NME_assets_data_vcr_stop_png);
			resourceTypes.set ("assets/data/vcr/stop.png", "image");
			resourceClasses.set ("assets/data/vis/bounds.png", NME_assets_data_vis_bounds_png);
			resourceTypes.set ("assets/data/vis/bounds.png", "image");
			resourceClasses.set ("assets/Geography.csv", NME_assets_geography_csv);
			resourceTypes.set ("assets/Geography.csv", "text");
			resourceClasses.set ("assets/HaxeFlixel.svg", NME_assets_haxeflixel_svg);
			resourceTypes.set ("assets/HaxeFlixel.svg", "text");
			resourceClasses.set ("assets/Sprite/Character/bot.png", NME_assets_sprite_character_bot_png);
			resourceTypes.set ("assets/Sprite/Character/bot.png", "image");
			resourceClasses.set ("assets/Sprite/Character/claws.png", NME_assets_sprite_character_claws_png);
			resourceTypes.set ("assets/Sprite/Character/claws.png", "image");
			resourceClasses.set ("assets/Sprite/Character/pre_quijote.png", NME_assets_sprite_character_pre_quijote_png);
			resourceTypes.set ("assets/Sprite/Character/pre_quijote.png", "image");
			resourceClasses.set ("assets/Sprite/Character/quijote.jpg", NME_assets_sprite_character_quijote_jpg);
			resourceTypes.set ("assets/Sprite/Character/quijote.jpg", "image");
			resourceClasses.set ("assets/Sprite/Character/quijote.png", NME_assets_sprite_character_quijote_png);
			resourceTypes.set ("assets/Sprite/Character/quijote.png", "image");
			resourceClasses.set ("assets/Sprite/Character/save_pre_quijote.png", NME_assets_sprite_character_save_pre_quijote_png);
			resourceTypes.set ("assets/Sprite/Character/save_pre_quijote.png", "image");
			resourceClasses.set ("assets/Sprite/Character/spaceman.png", NME_assets_sprite_character_spaceman_png);
			resourceTypes.set ("assets/Sprite/Character/spaceman.png", "image");
			resourceClasses.set ("assets/Sprite/Explotion/punch.png", NME_assets_sprite_explotion_punch_png);
			resourceTypes.set ("assets/Sprite/Explotion/punch.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/arrow_game.png", NME_assets_sprite_items_dynamic_arrow_game_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/arrow_game.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/bot_bullet.png", NME_assets_sprite_items_dynamic_bot_bullet_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/bot_bullet.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/bullet.png", NME_assets_sprite_items_dynamic_bullet_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/bullet.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/coin.png", NME_assets_sprite_items_dynamic_coin_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/coin.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/door.png", NME_assets_sprite_items_dynamic_door_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/door.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/gibs.png", NME_assets_sprite_items_dynamic_gibs_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/gibs.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/Grape_icon.png", NME_assets_sprite_items_dynamic_grape_icon_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/Grape_icon.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/jet.png", NME_assets_sprite_items_dynamic_jet_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/jet.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/lock.png", NME_assets_sprite_items_dynamic_lock_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/lock.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/oval_shadow.jpg", NME_assets_sprite_items_dynamic_oval_shadow_jpg);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/oval_shadow.jpg", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/oval_shadow.png", NME_assets_sprite_items_dynamic_oval_shadow_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/oval_shadow.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/SHADOW.png", NME_assets_sprite_items_dynamic_shadow_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/SHADOW.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/SHADOW_32.png", NME_assets_sprite_items_dynamic_shadow_32_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/SHADOW_32.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/spawner.png", NME_assets_sprite_items_dynamic_spawner_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/spawner.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Dynamic/spawner_gibs.png", NME_assets_sprite_items_dynamic_spawner_gibs_png);
			resourceTypes.set ("assets/Sprite/Items/Dynamic/spawner_gibs.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Background/Avatars.png", NME_assets_sprite_items_static_background_avatars_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Background/Avatars.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Background/background_chat.png", NME_assets_sprite_items_static_background_background_chat_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Background/background_chat.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Background/moon_background.png", NME_assets_sprite_items_static_background_moon_background_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Background/moon_background.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Background/scroll_page.png", NME_assets_sprite_items_static_background_scroll_page_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Background/scroll_page.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/5.png", NME_assets_sprite_items_static_ornament_5_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/5.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/6.png", NME_assets_sprite_items_static_ornament_6_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/6.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/7.png", NME_assets_sprite_items_static_ornament_7_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/7.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/8.png", NME_assets_sprite_items_static_ornament_8_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/8.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/book.png", NME_assets_sprite_items_static_ornament_book_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/book.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/Crafting_anvil.png", NME_assets_sprite_items_static_ornament_crafting_anvil_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/Crafting_anvil.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/miniframe.png", NME_assets_sprite_items_static_ornament_miniframe_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/miniframe.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/rock1.png", NME_assets_sprite_items_static_ornament_rock1_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/rock1.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/rock2.png", NME_assets_sprite_items_static_ornament_rock2_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/rock2.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/t0.png", NME_assets_sprite_items_static_ornament_t0_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/t0.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/t1.png", NME_assets_sprite_items_static_ornament_t1_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/t1.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/t2.png", NME_assets_sprite_items_static_ornament_t2_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/t2.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/t3.png", NME_assets_sprite_items_static_ornament_t3_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/t3.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/t4.png", NME_assets_sprite_items_static_ornament_t4_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/t4.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/tre1.png", NME_assets_sprite_items_static_ornament_tre1_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/tre1.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/tree2.png", NME_assets_sprite_items_static_ornament_tree2_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/tree2.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Ornament/trees.png", NME_assets_sprite_items_static_ornament_trees_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Ornament/trees.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Texture/bgtiles.png", NME_assets_sprite_items_static_texture_bgtiles_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Texture/bgtiles.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Texture/black.png", NME_assets_sprite_items_static_texture_black_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Texture/black.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Texture/dirt.png", NME_assets_sprite_items_static_texture_dirt_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Texture/dirt.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Texture/dirt_top.png", NME_assets_sprite_items_static_texture_dirt_top_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Texture/dirt_top.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Texture/grounddirt.png", NME_assets_sprite_items_static_texture_grounddirt_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Texture/grounddirt.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Texture/rocks.png", NME_assets_sprite_items_static_texture_rocks_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Texture/rocks.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Texture/tech_tiles.png", NME_assets_sprite_items_static_texture_tech_tiles_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Texture/tech_tiles.png", "image");
			resourceClasses.set ("assets/Sprite/Items/Static/Texture/tile_town.png", NME_assets_sprite_items_static_texture_tile_town_png);
			resourceTypes.set ("assets/Sprite/Items/Static/Texture/tile_town.png", "image");
			resourceClasses.set ("assets/Sprite/Mouse/cursor.png", NME_assets_sprite_mouse_cursor_png);
			resourceTypes.set ("assets/Sprite/Mouse/cursor.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/big purple.png", NME_assets_sprite_trigger_big_purple_png);
			resourceTypes.set ("assets/Sprite/Trigger/big purple.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/biggray.png", NME_assets_sprite_trigger_biggray_png);
			resourceTypes.set ("assets/Sprite/Trigger/biggray.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/blue.png", NME_assets_sprite_trigger_blue_png);
			resourceTypes.set ("assets/Sprite/Trigger/blue.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/brawl.png", NME_assets_sprite_trigger_brawl_png);
			resourceTypes.set ("assets/Sprite/Trigger/brawl.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/chat.png", NME_assets_sprite_trigger_chat_png);
			resourceTypes.set ("assets/Sprite/Trigger/chat.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/Empty.png", NME_assets_sprite_trigger_empty_png);
			resourceTypes.set ("assets/Sprite/Trigger/Empty.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/emptyTrigger.png", NME_assets_sprite_trigger_emptytrigger_png);
			resourceTypes.set ("assets/Sprite/Trigger/emptyTrigger.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/end_level.png", NME_assets_sprite_trigger_end_level_png);
			resourceTypes.set ("assets/Sprite/Trigger/end_level.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/green.png", NME_assets_sprite_trigger_green_png);
			resourceTypes.set ("assets/Sprite/Trigger/green.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/limit DEBUG.png", NME_assets_sprite_trigger_limit_debug_png);
			resourceTypes.set ("assets/Sprite/Trigger/limit DEBUG.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/limit.png", NME_assets_sprite_trigger_limit_png);
			resourceTypes.set ("assets/Sprite/Trigger/limit.png", "image");
			resourceClasses.set ("assets/Sprite/Trigger/red.png", NME_assets_sprite_trigger_red_png);
			resourceTypes.set ("assets/Sprite/Trigger/red.png", "image");
			resourceClasses.set ("assets/Topography.csv", NME_assets_topography_csv);
			resourceTypes.set ("assets/Topography.csv", "text");
			resourceClasses.set ("axonometric_grounddirt", NME_assets_axonometriclib_grounddirt_png1);
			resourceTypes.set ("axonometric_grounddirt", "image");
			resourceClasses.set ("axonometric_tile_town", NME_assets_axonometriclib_tile_town_png1);
			resourceTypes.set ("axonometric_tile_town", "image");
			resourceClasses.set ("axonometric_oval_shadow_anim", NME_assets_axonometriclib_oval_shadow_anim_png1);
			resourceTypes.set ("axonometric_oval_shadow_anim", "image");
			resourceClasses.set ("img_quijote", NME_assets_sprite_character__quijote_png);
			resourceTypes.set ("img_quijote", "image");
			resourceClasses.set ("topography", NME_assets_topography_csv1);
			resourceTypes.set ("topography", "text");
			resourceClasses.set ("geography", NME_assets_geography_csv1);
			resourceTypes.set ("geography", "text");
			
			
			initialized = true;
			
		}
		
	}
	
	
	public static function getBitmapData (id:String, useCache:Bool = true):BitmapData {
		
		initialize ();
		
		if (resourceTypes.exists (id) && resourceTypes.get (id).toLowerCase () == "image") {
			
			if (useCache && cachedBitmapData.exists (id)) {
				
				return cachedBitmapData.get (id);
				
			} else {
				
				var data = cast (Type.createInstance (resourceClasses.get (id), []), BitmapData);
				
				if (useCache) {
					
					cachedBitmapData.set (id, data);
					
				}
				
				return data;
				
			}
			
		} else if (id.indexOf (":") > -1) {
			
			var libraryName = id.substr (0, id.indexOf (":"));
			var symbolName = id.substr (id.indexOf (":") + 1);
			
			if (libraryTypes.exists (libraryName)) {
				
				#if swf
				
				if (libraryTypes.get (libraryName) == "swf") {
					
					if (!cachedSWFLibraries.exists (libraryName)) {
						
						cachedSWFLibraries.set (libraryName, new SWF (getBytes ("libraries/" + libraryName + ".swf")));
						
					}
					
					return cachedSWFLibraries.get (libraryName).getBitmapData (symbolName);
					
				}
				
				#end
				
				#if xfl
				
				if (libraryTypes.get (libraryName) == "xfl") {
					
					if (!cachedXFLLibraries.exists (libraryName)) {
						
						cachedXFLLibraries.set (libraryName, Unserializer.run (getText ("libraries/" + libraryName + "/" + libraryName + ".dat")));
						
					}
					
					return cachedXFLLibraries.get (libraryName).getBitmapData (symbolName);
					
				}
				
				#end
				
			} else {
				
				trace ("[nme.Assets] There is no asset library named \"" + libraryName + "\"");
				
			}
			
		} else {
			
			trace ("[nme.Assets] There is no BitmapData asset with an ID of \"" + id + "\"");
			
		}
		
		return null;
		
	}
	
	
	public static function getBytes (id:String):ByteArray {
		
		initialize ();
		
		if (resourceClasses.exists (id)) {
			
			return Type.createInstance (resourceClasses.get (id), []);
			
		} else {
			
			trace ("[nme.Assets] There is no ByteArray asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getFont (id:String):Font {
		
		initialize ();
		
		if (resourceTypes.exists (id) && resourceTypes.get (id).toLowerCase () == "font") {
			
			return cast (Type.createInstance (resourceClasses.get (id), []), Font);
			
		} else {
			
			trace ("[nme.Assets] There is no Font asset with an ID of \"" + id + "\"");
			
			return null;
			
		}
		
	}
	
	
	public static function getMovieClip (id:String):MovieClip {
		
		initialize ();
		
		var libraryName = id.substr (0, id.indexOf (":"));
		var symbolName = id.substr (id.indexOf (":") + 1);
		
		if (libraryTypes.exists (libraryName)) {
			
			#if swf
			
			if (libraryTypes.get (libraryName) == "swf") {
				
				if (!cachedSWFLibraries.exists (libraryName)) {
					
					cachedSWFLibraries.set (libraryName, new SWF (getBytes ("libraries/" + libraryName + ".swf")));
					
				}
				
				return cachedSWFLibraries.get (libraryName).createMovieClip (symbolName);
				
			}
			
			#end
			
			#if xfl
			
			if (libraryTypes.get (libraryName) == "xfl") {
				
				if (!cachedXFLLibraries.exists (libraryName)) {
					
					cachedXFLLibraries.set (libraryName, Unserializer.run (getText ("libraries/" + libraryName + "/" + libraryName + ".dat")));
					
				}
				
				return cachedXFLLibraries.get (libraryName).createMovieClip (symbolName);
				
			}
			
			#end
			
		} else {
			
			trace ("[nme.Assets] There is no asset library named \"" + libraryName + "\"");
			
		}
		
		return null;
		
	}
	
	
	public static function getSound (id:String):Sound {
		
		initialize ();
		
		if (resourceTypes.exists (id)) {
			
			if (resourceTypes.get (id).toLowerCase () == "sound" || resourceTypes.get (id).toLowerCase () == "music") {
				
				return cast (Type.createInstance (resourceClasses.get (id), []), Sound);
				
			}
			
		}
		
		trace ("[nme.Assets] There is no Sound asset with an ID of \"" + id + "\"");
		
		return null;
		
	}
	
	
	public static function getText (id:String):String {
		
		var bytes = getBytes (id);
		
		if (bytes == null) {
			
			return null;
			
		} else {
			
			return bytes.readUTFBytes (bytes.length);
			
		}
		
	}
	
	
	//public static function loadBitmapData(id:String, handler:BitmapData -> Void, useCache:Bool = true):BitmapData
	//{
		//return null;
	//}
	//
	//
	//public static function loadBytes(id:String, handler:ByteArray -> Void):ByteArray
	//{	
		//return null;
	//}
	//
	//
	//public static function loadText(id:String, handler:String -> Void):String
	//{
		//return null;
	//}
	
	
}