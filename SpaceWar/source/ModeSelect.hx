package;
import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class ModeSelect extends FlxState 
{
	private var original:FlxButton;
	private var nyan:FlxButton;
	
	override public function create():Void 
	{	
		FlxG.mouse.show();
		
		var title:FlxText;
		title = new FlxText(0, 16, FlxG.width, "Space War");
		title.setFormat(null, 16, 0xFFFFFF, "center");
		add(title);
		
		original = new FlxButton(275, 220, "Original Mode", originalMode);
		add(original);
		
		nyan = new FlxButton(275, 250, "Nyan Mode", nyanMode);
		add(nyan);
	}
	
	override public function update():Void 
	{	
		super.update();	
	}
	
	public function new() 
	{	
		super();	
	}
	
	private function originalMode():Void 
	{	
		FlxG.switchState(new PlayState());	
	}
	
	private function nyanMode():Void 
	{	
		FlxG.switchState(new NyanState());	
	}
}