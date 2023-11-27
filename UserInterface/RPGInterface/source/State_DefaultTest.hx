import flixel.addons.ui.FlxUI;
import flixel.addons.ui.interfaces.IFlxUIState;
import flixel.addons.ui.FlxUITypedButton;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.addons.ui.FlxUIPopup;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

/**
 * @author Lars Doucet
 */
class State_DefaultTest extends FlxUIState
{
	override public function create()
	{
		_xml_id = "state_default";
		super.create();
	}

	override public function getRequest(id:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Dynamic
	{
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
						case "back": FlxG.switchState(new State_Title());
						case "popup":
							var popup:FlxUIPopup = new PopupFix(); // create the popup
							popup.quickSetup // set it up
							(Main.tongue.get("$POPUP_DEMO_2_TITLE", "ui"), // title text
								Main.tongue.get("$POPUP_DEMO_2_BODY", "ui"), // body text
								["<yes>", "<no>", "<cancel>"] // FlxUI will translate labels to "$POPUP_YES", etc,
							); // and localize them if possible,
							// otherwise it will display "YES", "NO", etc

							openSubState(popup); // show the popup

							// you can call quickSetup() before or after setting the subState, it will behave properly either way

							// since the above example is a little messy, here's what it looks like without the firetongue calls:
							//  popup.quickSetup("title","body",["Yes","No","Cancel"]);
					}
				case "click_popup":
					switch (cast params[0] : Int)
					{
						case 0: FlxG.log.add("Yes was clicked");
						case 1: FlxG.log.add("No was clicked");
						case 2: FlxG.log.add("Cancel was clicked");
					}
			}
		}
	}
}

/**
 * An extension to `FlxUIPopup` that fixes a bug in `getEvent` where the event was not being broadcast correctly to the parent widget
 */
class PopupFix extends FlxUIPopup
{
	override function getEvent(id:String, sender:IFlxUIWidget, data:Dynamic, ?eventParams:Array<Dynamic>)
	{
		if (eventParams == null)
		{
			if (params != null)
			{
				eventParams = [];
			}
		}
		if (params != null)
		{
			eventParams = eventParams.concat(params);
		}

		switch (id)
		{
			case FlxUITypedButton.CLICK_EVENT:
				if (eventParams != null)
				{
					var buttonAmount:Int = Std.int(eventParams[0]); // 0 is Yes, 1 is No and 2 is Cancel
					if ((_parentState is IFlxUIState))
					{
						// This fixes a bug where the event was being sent to this popup rather than the state that created it
						castParent().getEvent(FlxUIPopup.CLICK_EVENT, this, buttonAmount, eventParams);
					}
					else
					{
						// This is a generic fallback in case something goes wrong
						FlxUI.event(FlxUIPopup.CLICK_EVENT, this, buttonAmount, eventParams);
					}
					close();
				}
		}
	}
}