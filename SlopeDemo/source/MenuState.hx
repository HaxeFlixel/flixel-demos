package;
import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class MenuState extends FlxState
{
	public function new()
	{
		super();
	}
	
	override public function create():Void
	{
		FlxG.state.bgColor = 0xff050510;
		
		var text:FlxText;
		text = new FlxText(FlxG.width / 2 - 100, FlxG.height / 3 - 30, 200, "Slope Demo");
		text.alignment = "center";
		text.color = 0x9999ff;
		text.size = 20;
		add(text);

		text = new FlxText(FlxG.width / 2 - 50, FlxG.height / 3, 200, "by Peter Christiansen");
		text.alignment = "center";
		text.color = 0x9999ff;
		add(text);
		
		var startButton:FlxButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height / 3 + 64, "Play", onPlay);
		startButton.color = 0x666699;
		startButton.label.color = 0x9999ff;
		add(startButton);
		
		FlxG.mouse.show("assets/cursor.png", 2);
	}
	
	private function onPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
}