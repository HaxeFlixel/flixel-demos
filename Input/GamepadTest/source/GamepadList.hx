package;

import flixel.util.FlxColor;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.addons.ui.FlxUIRadioGroup;


class GamepadList extends FlxUIRadioGroup
{
	var ids:Array<String> = [];
	var labels:Array<String> = [];
	
	var onChange:Null<FlxGamepad>->Void;
	
	public function new(x:Float, y:Float, onChange:Null<FlxGamepad>->Void)
	{
		super(x, y, ids, labels, null, 25, 200, 25, 200);
		this.onChange = onChange;
		
		FlxG.gamepads.deviceConnected.add(onDeviceConnect);
		FlxG.gamepads.deviceDisconnected.add(onDeviceDisconnect);
		callback = onSelect;
	}
	
	
	function onDeviceConnect(gamepad:FlxGamepad):Void
	{
		updateList();
		select(gamepad.id);
	}
	
	function onDeviceDisconnect(gamepad:FlxGamepad):Void
	{
		updateList();
		if (FlxG.gamepads.numActiveGamepads > 0)
			select(FlxG.gamepads.lastActive.id);
	}
	
	function select(i:Int)
	{
		selectedIndex = i;
		onSelect(selectedId);
	}
	
	function onSelect(_)
	{
		var gamepad = FlxG.gamepads.getByID(selectedIndex);
		if (gamepad != null && gamepad.connected)
			onChange(gamepad);
		else
			onChange(null);
	}
	
	function updateList()
	{
		@:privateAccess
		for (i in 0...FlxG.gamepads._gamepads.length)
		{
			ids[i] = Std.string(i);
			labels[i] = '$i - ' + getModel(FlxG.gamepads.getByID(i));
		}
		updateRadios(ids, labels);
		updateStyle();
	}
	
	inline function getModel(gamepad:FlxGamepad)
	{
		return
			if (gamepad != null && gamepad.connected)
				gamepad.model.getName();
			else
				"None";
	}
	
	function updateStyle()
	{
		for (button in getRadios())
		{
			button.button.up_color = FlxColor.BLACK;
			button.button.over_color = FlxColor.BLACK;
			button.button.down_color = FlxColor.BLACK;
			button.button.getLabel().color = FlxColor.BLACK;
			// button.textY = -4;
		}
	}
}