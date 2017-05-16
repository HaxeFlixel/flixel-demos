package;
import flash.utils.ByteArray;
import flixel.FlxBasic;
import flixel.FlxG;
import haxe.Utf8;

typedef Conversation = {
	var sentence:String;
	var charByteSize:Array<Int>;
	var callback:Void->Void;
	var invokedNumTimes:Int;
	var repeatsNumTimes:Int;
	var conversationIndex:Int;
	var autoIncrementConversationIndex:Bool;
}

class DialogueHelper extends FlxBasic
{
	/**
	 * Character timer vars. Decides how much time should pass between each character
	 */
	private var characterFeedClock:Float = 0;
	public var characterFeedDelay(default, default):Float = 0;
	
	/**
	 * Decides if new characters should be fed to the working string or not
	 */
	public var isActive(default, null):Bool = false;
	
	/**
	 * Holds all conversations and querries
	 */
	private var conversations:Array<Conversation>;
	
	/**
	 * Current conversation index for this DialogueHelper instance
	 */
	private var conversationIdx:Int = 0;
	
	private var lastConversationIdx:Int = 0;
	
	/**
	 * Keeps track of which character we're going to work with
	 */
	private var characterIndex:Int = 0;
	
	/**
	 * The string that recieves all the new characters.
	 * This is the string you want to read from and fill
	 * any potential "dialogue boxes" with.
	 */
	public var workingString(default, null):String = "";
	
	/**
	 * Tells you the number of conversations that
	 * remains in this DialogueHelper instance
	 */
	public var finishedSentence(default, null):Bool = false;
	
	/**
	 * Whether or not the the last character of the final sentence has been printed.
	 */
	public var isDone(default, null):Bool = false;
	
	/**
	 * The character buffer that stores the current working string.
	 * Its real purpose is to simplify handling of UTF8-strings.
	 * By using the 'charByteSize'-array for each string, the correct number of bytes
	 * can be read for each character.
	 * This comes in handy for accented- and asian characters.
	 */
	private var characterBuffer:ByteArray;
	
	public function new(characterFeedDelay:Float = .05)
	{
		super();
		this.characterFeedDelay = characterFeedDelay;
	}
	
	public function getCurrentConversation():Conversation
	{
		return conversations[conversationIdx];
	}
	
	/**
	 * Use this to speed up the character feed
	 */
	public function incrementCharacterDelayClock(byAmount:Float):Void
	{
		characterFeedClock += byAmount;
	}
	
	/**
	 * Adds a piece of a conversation to this DialogueHelper instance.
	 * @param	sentence The words you want to add.
	 * @param	finishSpeakCallback A method that should be called whenever the last letter has been printed.
	 * @param	repeatNTimes 0 == indefinite number of times; or > 0 for a set number of times.
	 * @param	autoIncrementConversationIdx Whether you want to manually step through the different sentences w/ nextSentence/previousSentence or not.
	 * @return This piece of the conversation with all the parameters etc.
	 */
	public function addSentence(sentence:String, finishSpeakCallback:Void->Void = null, repeatNTimes:Int = 0, autoIncrementConversationIdx:Bool = true):Conversation
	{
		if (conversations == null) 
		{
			conversations = new Array<Conversation>();
		}
		
		var convo:Conversation = {
			sentence:sentence,
			callback:finishSpeakCallback,
			charByteSize:new Array<Int>(),
			invokedNumTimes:0,
			repeatsNumTimes:repeatNTimes,
			conversationIndex:conversations.length,
			autoIncrementConversationIndex:autoIncrementConversationIdx
		}
		
		// Adds the right character width for each character in the current sentence
		Utf8.iter(sentence, function (chars:Int)
		{
			var char:String = String.fromCharCode(chars);
			
			if (!Utf8.validate(char))
			{
				char = Utf8.encode(char);
			}
			
			convo.charByteSize.push(getNumBytesUTF8(char));
		});
		
		conversations.push(convo);
		return convo;
	}
	
	/**
	 * Measures the width of a UTF8 character and returns it.
	 * @param	s The string to measure.
	 * @return  The width of the UTF8-string.
	 */
	private function getNumBytesUTF8(s:String):Int
	{
		var byteArray:ByteArray = new ByteArray();
		byteArray.writeUTFBytes(s);
		return byteArray.length;
	}
	
	/**
	 * Clears the current working string, sets the next conversation index and starts talking
	 */
	public function resumeConversation(resumeFromIndex:Int = -1):Void
	{
		clear();
		nextSentence(resumeFromIndex);
		start();
	}
	
	/**
	 * Starts printing the characters.
	 */
	public function start():Void
	{
		if (conversations == null || conversations.length == 0)
		{
			return;
		}
		
		isActive = true;
		
		if (workingString.length == 0)
		{
			conversations[conversationIdx].invokedNumTimes++;
		}
	}
	
	/**
	 * Stops/pauses feeding new characters to the working string.
	 */
	public function stop():Void
	{
		isActive = false;
		characterFeedClock = 0;
	}
	
	/**
	 * Almost the same as calling 'setConversationIndex(0)', but calls clear() first to reset a bunch of things
	 */
	public function resetConversation():Void
	{
		clear();
		setConversationIndex(0);
	}
	
	public function setConversationIndex(idx:Int):Void
	{
		lastConversationIdx = conversationIdx;
		
		if (idx > conversations.length - 1)
		{
			idx = conversations.length - 1;
		}
		else if (idx < 0)
		{
			idx = 0;
		}
		
		conversationIdx = idx;
	}
	
	/**
	 * Clears the content of the message string, string buffer contents, flags etc.
	 */
	public function clear():Void
	{
		if (characterBuffer == null)
		{
			return;
		}
		
		stop();
		workingString = "";
		characterIndex = 0;
		characterBuffer.clear();
		finishedSentence = false;
		isDone = false;
	}
	
	/**
	 * Steps ahead one sentence
	 */
	public function nextSentence(resumeFromIndex:Int = -1):Void
	{
		lastConversationIdx = conversationIdx;
		
		if (resumeFromIndex > -1)
		{
			conversationIdx = resumeFromIndex;
		}
		else
		{
			conversationIdx++;
		}
		
		if (conversationIdx > conversations.length - 1)
		{
			conversationIdx = conversations.length - 1;
		}
	}
	
	/**
	 * Steps back one sentence
	 */
	public function previousSentence():Void
	{
		lastConversationIdx = conversationIdx;
		conversationIdx--;
		
		if (conversationIdx < 0)
		{
			conversationIdx = 0;
		}
	}
	
	private function nextCharacter(startedSpecialCharacter:Bool = false):Void
	{
		if (workingString.length == 0)
		{
			characterBuffer = new ByteArray();
			characterBuffer.writeUTFBytes(conversations[conversationIdx].sentence);
			characterBuffer.position = 0; // reset position
		}
		else
		{
			if (characterBuffer.bytesAvailable <= 0) // we reached the end of the sentence
			{
				return;
			}
		}
		
		/**
		 * More about charsets: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/ByteArray.html#readMultiByte()
		 * 
		 * "Note: If the value for the charSet parameter is not recognized by the current system, the application uses
		 * the system's default code page as the character set. For example, a value for the charSet parameter,
		 * as in myTest.readMultiByte(22, "iso-8859-01") that uses 01 instead of 1 might work on your development system,
		 * but not on another system. On the other system, the application will use the system's default code page."
		 */
		
		workingString += characterBuffer.readMultiByte(conversations[conversationIdx].charByteSize[characterIndex++], "utf-8"); // iso-8859-1; shift-jis
	}
	
	private function doCallback():Void
	{
		if (conversations[conversationIdx].callback != null)
		{
			conversations[conversationIdx].callback();
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		if (conversations == null || conversations.length == 0) 
		{
			return;
		}
		
		if (isActive)
		{
			if (characterFeedClock < characterFeedDelay)
			{
				characterFeedClock += FlxG.elapsed;
			}
			else
			{
				if (characterIndex < Utf8.length(conversations[conversationIdx].sentence))
				{
					characterFeedClock = 0;
					nextCharacter();
				}
				else // printed the whole sentence, what now?
				{
					if (!finishedSentence) 
					{
						finishedSentence = true;
						
						if (conversations[conversationIdx].repeatsNumTimes > 0)
						{
							if (conversations[conversationIdx].repeatsNumTimes == conversations[conversationIdx].invokedNumTimes)
							{
								doCallback();
								
								// Sometimes you may want 'autoIncrementConversationIndex' to be false,
								// like when presenting options for a question or something.
								// you can then call 'nextSentence' when you feel like it
								if (conversations[conversationIdx].autoIncrementConversationIndex)
								{
									if (conversationIdx < conversations.length-1)
									{
										nextSentence();
									}
								}
								else
								{
									checkForEOF();
								}
							}
						}
						else // repeats the current sentence indefinitely
						{
							checkForEOF();
							stop();
							doCallback();
						}
					}
				}
			}
		}
		
		super.update(elapsed);
	}
	
	override public function destroy():Void
	{
		super.destroy();
		conversations = null;
		workingString = null;
		characterBuffer = null;
	}
	
	private function checkForEOF():Void
	{
		if (conversationIdx == conversations.length-1)
		{
			isDone = true;
		}
	}
}