package;

import flixel.FlxG;
import flixel.group.FlxContainer;
import flixel.text.FlxInputText;
import flixel.text.FlxText;
import flixel.text.FlxInputTextManager;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;

class PlayState extends flixel.FlxState
{
	var fields:FlxTypedContainer<FlxText>;
	var fancy:FlxInputText;
	
	override function create()
	{
		super.create();
		
		bgColor = 0xFF808080;
		
		add(fields = new FlxTypedContainer());
		
		final margin = 5.0;
		final gap = 5.0;
		
		/** Helper to create similar input texts below each other*/
		function createInputText(?fieldWidth:Float, text = "", size = 16, below = false)
		{
			var textX = margin;
			var textY = margin;
			if (fields.members.length > 0)
			{
				final prev = fields.members[fields.members.length - 1];
				if (below)
				{
					textY = prev.y + prev.height + 5;
				}
				else
				{
					textX = prev.x + prev.width + 5;
					textY = prev.y;
				}
			}
			
			if (fieldWidth == null)
				fieldWidth = FlxG.width - 5 - textX;
			
			final field = new FlxInputText(textX, textY, fieldWidth, text, size);
			fields.add(field);
			return field;
		}
		
		function createInputTextBelow(?fieldWidth:Float, text = "", size = 16)
		{
			return createInputText(fieldWidth, text, size, true);
		}
		
		final half = Std.int((FlxG.width - margin * 2 - gap) / 2);
		final third = Std.int((FlxG.width - margin * 2 - gap * 2) / 3);
		
		createInputTextBelow(0, "The default text input.");
		
		final textInput = createInputText(0, "An uneditable text input.");
		textInput.editable = false;
		
		final textInput = createInputText("An unselectable text input.");
		textInput.selectable = false;
		
		final textInput = createInputTextBelow(half, "A multiline text input with fieldWidth and fieldHeight set.");
		textInput.fieldHeight = 44;
		textInput.multiline = true;
		
		final textInput = createInputText("A multiline text input with word wrapping.");
		textInput.fieldHeight = 44;
		textInput.wordWrap = textInput.multiline = true;
		
		final textInput = createInputTextBelow("Bold, italicised text input with formatting.");
		textInput.setFormat(FlxAssets.FONT_DEBUGGER, 16, FlxColor.LIME);
		textInput.italic = textInput.bold = true;
		// textInput.scale.set(0.5, 0.5);
		fancy = textInput;
		
		final textInput = createInputTextBelow(half, "A center-aligned text input.");
		textInput.alignment = CENTER;
		
		final textInput = createInputText("A right-aligned text input.");
		textInput.alignment = RIGHT;
		
		final textInput = createInputTextBelow(half, "Only Uppercase, Max chars: 35");
		textInput.forceCase = UPPER_CASE;
		textInput.maxChars = 30;
		
		final textInput = createInputText("only lowercase and a 2px border");
		textInput.fieldBorderThickness = 2;
		textInput.fieldBorderColor = FlxColor.BLACK;
		textInput.forceCase = LOWER_CASE;
		
		final textInput = createInputTextBelow(third, "OnlyAlphanumeric123");
		textInput.filterMode = ALPHANUMERIC;

		final textInput = createInputText(third, "password");
		textInput.passwordMode = true;
		
		final textInput = createInputText("Custom selection colors.");
		textInput.caretWidth = 2;
		textInput.caretColor = FlxColor.BLUE;
		textInput.selectionColor = FlxColor.BLUE;
		textInput.selectedTextColor = FlxColor.WHITE;
		
		final textInput = createInputTextBelow("A text input without a background.");
		textInput.color = FlxColor.WHITE;
		textInput.background = false;
		
		final actionList = new ActionsText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 10);
		actionList.fieldHeight = FlxG.height - 5 - actionList.y;
		actionList.maxLines = Math.ceil(actionList.fieldHeight / actionList.textField.textHeight);
		add(actionList);
	}
}

class ActionsText extends FlxText
{
	static inline var INITIAL_TEXT = "This logs every \"typing action\" performed on any of the input texts";
	
	public var maxLines:Int = -1;
	
	public function new(x:Float, y:Float, fieldWidth = 0, size = 16)
	{
		super(x, y, fieldWidth, INITIAL_TEXT, size);
		
		textField.background = true;
		setFormat(size, 0x0);
		textField.backgroundColor = 0xffffff;
		
		FlxInputText.globalManager.onTypingAction.add((action) -> switch (action)
		{
			case ADD_TEXT(text):
				addAction('Add "$text"');
			case MOVE_CURSOR(type, true):
				addAction('Selection "${type.getName()}"');
			case MOVE_CURSOR(type, false):
				addAction('Cursor "${type.getName()}"');
			case COMMAND(cmd):
				addAction(cmd.getName());
		});
	}
	
	function addAction(msg:String)
	{
		if (text != "" && text.charAt(text.length - 1) != "\n")
			msg = ', $msg';
		
		text += msg;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (text != "" && text.charAt(text.length - 1) != "\n")
			text += "\n";
		
		final lines = text.split("\n");
		if (lines.length > maxLines)
			lines.shift();
		text = lines.join("\n");
		
		final end = text.indexOf("\n");
		if (end != -1)
		{
			textField.setSelection(0, end);
		}
	}
}