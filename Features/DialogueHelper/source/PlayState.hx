package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private static inline var DIALOGUE_0:String = "Click here, please.";
	private static inline var DIALOGUE_1:String = "(Click again!)"; // TODO: Make this work -> もう一回クリックして！ (Click again!)
	private static inline var QUERY:String = "So, game development... I\nheard it's pretty hard work,\nis that right?";
	private static inline var OPTION_RESPONSE_0:String = "Yea? I- I dunno if I have\nwhat it takes to do it...\nTeach me, GameDev-Sensei!";
	private static inline var OPTION_RESPONSE_1:String = "No? Well, then ANYONE could\ndo it, right... right??";
	
	private var diagHelper:DialogueHelper;
	private var speechBubbleText:FlxBitmapText;
	private var speechBubble:FlxSprite;
	
	private var option1:FlxSprite;
	private var option2:FlxSprite;
	private var option1Idx:Int = -1;
	private var option2Idx:Int = -1;
	
	override public function create():Void
	{
		speechBubble = new FlxSprite(0, 0, AssetPaths.speech_bubble__png);
		speechBubble.setPosition(FlxG.width * .5 -speechBubble.width * .5, 16 * 3);
		
		diagHelper = new DialogueHelper(.1 /* Character feed delay. Higher value = slower text speed */);
		
		// This piece of dialogue will will be assigned index 0
		// Every time addSentence is called, the index is incremented by 1
		diagHelper.addSentence(DIALOGUE_0);
		
		diagHelper.addSentence(DIALOGUE_1);
		diagHelper.addSentence(QUERY, function ()
		{
			openOptions(); // Will be called as soon as the last letter from this string has been printed
		});
		
		option1Idx = diagHelper.addSentence(OPTION_RESPONSE_0).conversationIndex; // index 3
		option2Idx = diagHelper.addSentence(OPTION_RESPONSE_1).conversationIndex; // index 4
		
		var characters = " ABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ!?-,.'";
		var dialogueFont:FlxBitmapFont = FlxBitmapFont.fromMonospace(AssetPaths.font12x12__png, characters, FlxPoint.weak(12, 12));
		var padding = 10;
		
		speechBubbleText = new FlxBitmapText(dialogueFont);
		speechBubbleText.setPosition(speechBubble.x +padding, speechBubble.y +padding);
		speechBubbleText.autoUpperCase = true;
		speechBubbleText.lineSpacing = 2;
		speechBubbleText.text = "";
		
		option1 = new FlxSprite(0, 0, AssetPaths.yes_option__png);
		option2 = new FlxSprite(0, 0, AssetPaths.no_option__png);
		
		option1.setPosition(speechBubble.x, speechBubble.y+speechBubble.height);
		option2.setPosition(option1.x +option1.width +padding, option1.y);
		option1.visible = option2.visible = false;
		
		var infoText = new FlxText(10, 10, 150, "Press R to restart demo.");
		infoText.setFormat(null, 8, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		
		add(new FlxSprite(0, 0, AssetPaths.backdrop__png));
		add(speechBubble);
		add(diagHelper);
		add(speechBubbleText);
		add(option1);
		add(option2);
		add(infoText);
		
		diagHelper.start();
	}

	private function openOptions():Void
	{
		option1.visible = option2.visible = true;
	}
	
	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}
		
		if (FlxG.mouse.justPressed)
		{
			// User has chosen an option, reset the conversation
			if (diagHelper.getCurrentConversation().conversationIndex >= 3)
			{
				diagHelper.resetConversation();
				diagHelper.start();
			}
			else if (!option1.visible && FlxG.mouse.getScreenPosition().inCoords(speechBubble.x, speechBubble.y, speechBubble.width, speechBubble.height))
			{
				diagHelper.characterFeedDelay = 0; // Speeds up the character feed
				
				if (diagHelper.finishedSentence)
				{
					diagHelper.resumeConversation(); // Starts the next part of the dialogue
				}
			}
			else if (option1.visible && FlxG.mouse.getScreenPosition().inCoords(option1.x, option1.y, option1.width, option1.height))
			{				
				if (diagHelper.finishedSentence)
				{
					diagHelper.resumeConversation(option1Idx /* Tells the dialogue handler resume the conversation from a specific point */);
				}
				
				option1.visible = option2.visible = false;
			}
			else if (option2.visible && FlxG.mouse.getScreenPosition().inCoords(option2.x, option2.y, option2.width, option2.height))
			{	
				if (diagHelper.finishedSentence)
				{
					diagHelper.resumeConversation(option2Idx);
				}
				
				option1.visible = option2.visible = false;
			}
		}
		
		speechBubbleText.text = diagHelper.workingString;
		
		super.update(elapsed);
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		speechBubbleText = null;
		
		if (diagHelper != null)
		{
			diagHelper.destroy();
			diagHelper = null;
		}
	}
}
