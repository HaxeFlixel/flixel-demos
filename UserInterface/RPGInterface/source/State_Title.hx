import firetongue.FireTongue;
import flixel.FlxG;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.addons.ui.FlxUIState;

/**
 * @author Lars Doucet
 */
class State_Title extends FlxUIState
{
	public function new()
	{
		super();
	}

	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xff131c1b;

		if (Main.tongue == null)
		{
			Main.tongue = new FireTongueEx();
			Main.tongue.initialize({locale: "en-US"});
			FlxUIState.static_tongue = Main.tongue;
		}

		_xml_id = "state_title";

		super.create();
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void
	{
		switch (name)
		{
			case "finish_load":
				var radio:FlxUIRadioGroup = cast _ui.getAsset("locale_radio");
				if (radio != null && Main.tongue != null)
				{
					radio.selectedId = Main.tongue.locale.toLowerCase();
				}
			case "click_button":
				if (params != null && params.length > 0)
				{
					switch (Std.string(params[0]))
					{
						case "saves": FlxG.switchState(State_SaveMenu.new);
						case "menu": FlxG.switchState(State_TestMenu.new);
						case "battle": FlxG.switchState(State_Battle.new);
						case "default_test": FlxG.switchState(State_DefaultTest.new);
						case "code_test": FlxG.switchState(State_CodeTest.new);
						case "popup": openSubState(new Popup_Demo());
					}
				}
			case "click_radio_group":
				var id:String = cast data;
				if (Main.tongue != null)
				{
					Main.tongue.initialize({locale: id, finishedCallback: reloadState});
				}
		}
	}

	function reloadState():Void
	{
		FlxG.switchState(State_Title.new);
	}
}
