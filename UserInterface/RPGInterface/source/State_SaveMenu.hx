import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

using flixel.util.FlxStringUtil;

import haxe.xml.Access;

/**
 * @author Lars Doucet
 */
class State_SaveMenu extends FlxUIState
{
	public function new()
	{
		super();
	}

	override public function create()
	{
		_xml_id = "state_save";
		super.create();
	}

	override public function getRequest(id:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Dynamic
	{
		var xml:Access;
		if ((data is Xml))
		{
			xml = cast data;
		}
		if (id.indexOf("ui_get:") == 0)
		{
			switch (id.remove("ui_get:"))
			{
				case "save_slot":
					return new SaveSlot(data, _ui);
			}
		}
		return null;
	}

	override public function getEvent(id:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void
	{
		if (params != null)
		{
			switch (id)
			{
				case "click_button":
					switch (Std.string(params[0]))
					{
						case "back": FlxG.switchState(State_Title.new);
					}
			}
		}
	}
}
