import flixel.addons.ui.FlxUI;
import flixel.addons.ui.interfaces.IFlxUIState;
import flixel.addons.ui.FlxUITypedButton;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.addons.ui.FlxUIPopup;

class Popup_Default extends FlxUIPopup
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