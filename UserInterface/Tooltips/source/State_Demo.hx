import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

/**
 * @author Lars Doucet
 */
class State_Demo extends FlxUIState
{
	public function new()
	{
		super();
	}

	override public function create()
	{
		_xml_id = "state_menu";
		super.create();
	}

	override public function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void
	{
		super.getEvent(id, sender, data, params);
		switch (id)
		{
			case FlxUITypedButton.CLICK_EVENT:
				var str:String = (params != null && params.length >= 1) ? cast params[0] : "";
				if (str == "defaults")
				{
					FlxG.switchState(State_Demo2.new);
				}
				if (str == "hand_code")
				{
					FlxG.switchState(State_DemoCode.new);
				}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		#if debug
		if (FlxG.keys.justPressed.R)
		{
			FlxG.switchState(State_Demo.new);
		}
		#end
	}
}
