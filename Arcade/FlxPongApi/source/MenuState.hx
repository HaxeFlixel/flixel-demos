package;

import flixel.addons.ui.FlxUIInputText;
import flixel.addons.api.gamejolt.*;
import flixel.addons.api.FlxGameJolt as OldGameJolt;
import flash.display.BitmapData;
import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import openfl.utils.ByteArray;

using StringTools;

/**
 * These lines allow embedding of assets as ByteArrays, which helps to minimize the threat of data being compromised.
 * For your own purposes, it is recommended you add "*.privatekey" to your source control ignore list.
 * The content of the .privatekey file should be just your private key.
 * To see how this file is read and used, look at the bottom of the create() function below.
 */
@:file("assets/example.privatekey") class MyPrivateKey extends ByteArrayData {}

class MenuState extends FlxState
{
	var _connection:FlxText;
	var _return:FlxText;
	var _main:FlxGroup;
	var _highScores:FlxGroup;
	var _apiTest:FlxGroup;
	var _loginGroup:FlxGroup;
	var _allScreens:FlxGroup;
	var _apiPages:Array<FlxGroup>;
	var _login:Button;
	var _apiCurrentPage:Int;
	var _mainMenuTime:Float = 0.0;
	var _input1:FlxUIInputText;
	var _input2:FlxUIInputText;
	var _imageDisplay:FlxSprite;
	
	static inline function API_TEST_BUTTONS():Array<Array<String>>
	{
		var row:Array<String> = [];
		var rows:Array<Array<String>> = [];
		
		for (button in FlxGameJoltRequestType.getConstructors())
		{
			row.push(button);
			if (row.length >= 4)
			{
				rows.push(row);
				row = [];
			}
		}
		if (row.length > 0)
			rows.push(row);
			
		return rows;
	}
	
	override public function create():Void
	{
		Reg.genColors();
		FlxG.cameras.bgColor = Reg.lite;
		Reg.level = 1;
		
		#if FLX_MOUSE
		var mouseSprite:Sprite = new Sprite();
		mouseSprite.graphics.beginFill(Reg.dark, 1);
		mouseSprite.graphics.moveTo(0, 0);
		mouseSprite.graphics.lineTo(20, 20);
		mouseSprite.graphics.lineTo(0, 27.5);
		mouseSprite.graphics.endFill();
		
		// using .show( mouseSprite ) doesn't work, so we convert it to bitmapdata
		
		var mouseData:BitmapData = new BitmapData(20, 30, true, 0);
		mouseData.draw(mouseSprite);
		FlxG.mouse.load(mouseData);
		FlxG.mouse.visible = true;
		#end
		
		// The background emitter, connection info, version, and blurb are always present.
		
		var em:Emitter = new Emitter(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2), 4);
		
		_connection = new FlxText(1, 1, FlxG.width, "Connecting to GameJolt...");
		_connection.color = Reg.med_lite;
		
		var info:FlxText = new FlxText(0, FlxG.height - 14, FlxG.width,
			"FlxPong is a demo of HaxeFlixel & FlxGameJolt, which interacts with the GameJolt API.");
		info.color = Reg.med_lite;
		info.alignment = CENTER;
		
		var ver:FlxText = new FlxText(0, 0, FlxG.width, Reg.VERSION);
		ver.color = Reg.med_lite;
		ver.alignment = RIGHT;
		
		add(em);
		add(_connection);
		add(info);
		add(ver);
		
		// Set up the "main" screen/buttons.
		
		_main = new FlxGroup();
		
		var title:FlxText = new FlxText(0, 20, FlxG.width, "FlxPong!", 16);
		title.color = Reg.med_dark;
		title.alignment = CENTER;
		
		var play:Button = new Button(0, 50, "Play!", playCallback);
		Reg.quarterX(play, 2);
		
		_login = new Button(0, 50, "Log in", switchMenu, 60);
		Reg.quarterX(_login, 3);
		_login.visible = false;
		_login.active = false;
		
		var test:Button = new Button(0, 80, "API Functions", switchMenu);
		Reg.quarterX(test, 1);
		
		var high:Button = new Button(0, 80, "High Scores", scoresCallback);
		Reg.quarterX(high, 2);
		
		var mine:Button = new Button(0, 80, "My Scores", mineCallback);
		Reg.quarterX(mine, 3);
		
		var source:Button = new Button(0, 110, "FlxGameJolt Source", sourceCallback, 120);
		Reg.quarterX(source, 1);
		
		var hf:Button = new Button(0, 110, "HaxeFlixel.com", hfCallback);
		Reg.quarterX(hf, 2);
		
		var doc:Button = new Button(0, 110, "GameJolt API Doc", docCallback, 120);
		Reg.quarterX(doc, 3);
		
		_main.add(title);
		_main.add(play);
		_main.add(_login);
		_main.add(test);
		// _main.add( high );
		// _main.add( mine );
		_main.add(source);
		_main.add(hf);
		_main.add(doc);
		
		// End main group.
		
		// Set up the "high scores" screen.
		
		_highScores = new FlxGroup();
		
		// End high scores.
		
		// Set up the API test screen.
		
		_apiTest = new FlxGroup();
		
		var xpos:Int = 2;
		var ypos:Array<Int> = [20, 42, 64, 86, 108, 130];
		var buttonwidth:Int = 100;
		
		// Set up the pages of this screen.
		
		_apiPages = [];
		_apiCurrentPage = 0;
		
		for (i in 0...API_TEST_BUTTONS().length)
		{
			_apiPages.push(new FlxGroup());
			
			var button1:Button;
			var button2:Button;
			var button3:Button;
			var button4:Button;
			
			if (API_TEST_BUTTONS()[i][0] != null)
			{
				button1 = new Button(xpos, ypos[0], API_TEST_BUTTONS()[i][0], apiCallback, buttonwidth);
				_apiPages[i].add(button1);
			}
			
			if (API_TEST_BUTTONS()[i][1] != null)
			{
				button2 = new Button(xpos, ypos[1], API_TEST_BUTTONS()[i][1], apiCallback, buttonwidth);
				_apiPages[i].add(button2);
			}
			
			if (API_TEST_BUTTONS()[i][2] != null)
			{
				button3 = new Button(xpos, ypos[2], API_TEST_BUTTONS()[i][2], apiCallback, buttonwidth);
				_apiPages[i].add(button3);
			}
			
			if (API_TEST_BUTTONS()[i][3] != null)
			{
				button4 = new Button(xpos, ypos[3], API_TEST_BUTTONS()[i][3], apiCallback, buttonwidth);
				_apiPages[i].add(button4);
			}
			
			_apiPages[i].visible = false;
			_apiPages[i].active = false;
		}
		
		// We do want to see the first page, once apiTest is added
		
		_apiPages[0].visible = true;
		_apiPages[0].active = true;
		
		// Add elements aside from the per-screen buttons
		
		var prev:Button = new Button(xpos, ypos[4], "<<", testMove, Std.int(buttonwidth / 2 - xpos / 2));
		var next:Button = new Button(Std.int(prev.x + prev.width + 2), ypos[4], ">>", testMove, Std.int(buttonwidth / 2 - xpos / 2));
		var testSpace:PongSprite = new PongSprite(xpos + buttonwidth + xpos, ypos[0], FlxG.width - (xpos + buttonwidth + xpos * 2), ypos[4] + 20 - ypos[0],
			Reg.med_lite);
		_return = new FlxText(testSpace.x + 4, testSpace.y + 4, Std.int(testSpace.width - 8), "Return data will display here.");
		_return.color = Reg.lite;
		_imageDisplay = new FlxSprite(testSpace.x + 5, testSpace.y + 5);
		_imageDisplay.visible = false;
		var exit:Button = new Button(Std.int(testSpace.x + testSpace.width - 40), Std.int(testSpace.y + testSpace.height - 20), "Back", switchMenu, 40);
		
		// Add everything to this screen
		
		for (g in _apiPages)
		{
			_apiTest.add(g);
		}
		
		_apiTest.add(prev);
		_apiTest.add(next);
		_apiTest.add(testSpace);
		_apiTest.add(_return);
		_apiTest.add(_imageDisplay);
		_apiTest.add(exit);
		
		_apiTest.active = false;
		_apiTest.visible = false;
		
		// End API test.
		
		// Login screen
		
		_loginGroup = new FlxGroup();
		
		var instruct:FlxText = new FlxText(0, 40, FlxG.width, "Log in to GameJolt to get trophies and stuff:");
		instruct.alignment = CENTER;
		instruct.color = Reg.med_dark;
		
		var word1:FlxText = new FlxText(0, 60, 60, "Username:");
		var word2:FlxText = new FlxText(0, 85, 60, "Token:");
		Reg.quarterX(word1, 1);
		Reg.quarterX(word2, 1);
		word1.color = word2.color = Reg.med_dark;
		
		_input1 = new FlxUIInputText(0, word1.y + (word1.height / 2), 150, "");
		_input2 = new FlxUIInputText(0, word2.y + (word2.height / 2), 150, "");
		Reg.quarterX(_input1, 3);
		Reg.quarterX(_input2, 3);
		_input1.color = _input2.color = Reg.med_lite;
		_input1.y -= _input1.height / 2;
		_input2.y -= _input2.height / 2;
		_input1.maxLength = 30;
		_input2.maxLength = 7;
		#if flash
		_input2.textField.restrict = "A-Za-z0-9";
		#end
		
		var input1bg:PongSprite = new PongSprite(Std.int(_input1.x), Std.int(_input1.y), Std.int(_input1.width - 40), Std.int(_input1.height + 4), Reg.dark);
		var input2bg:PongSprite = new PongSprite(Std.int(_input2.x), Std.int(_input2.y), Std.int(_input2.width - 40), Std.int(_input2.height + 4), Reg.dark);
		
		#if desktop
		_input1.height = input1bg.height;
		_input2.height = input2bg.height;
		#end
		
		var trylogin:Button = new Button(0, 110, "Log in", loginCallback);
		Reg.quarterX(trylogin, 2);
		var back:Button = new Button(400, 108, "Back", switchMenu, 40);
		
		_loginGroup.add(word1);
		_loginGroup.add(word2);
		_loginGroup.add(input1bg);
		_loginGroup.add(input2bg);
		_loginGroup.add(_input1);
		_loginGroup.add(_input2);
		_loginGroup.add(instruct);
		_loginGroup.add(trylogin);
		_loginGroup.add(back);
		
		_loginGroup.active = false;
		_loginGroup.visible = false;
		
		// End Login.
		
		_allScreens = new FlxGroup();
		_allScreens.add(_main);
		_allScreens.add(_apiTest);
		_allScreens.add(_loginGroup);
		
		add(_allScreens);
		
		em.start(false);
		
		// Load the privatekey data as a bytearray.
		
		var ba:ByteArray = new MyPrivateKey();
		
		// If we're already initialized (which would happen on returning from the playstate), we don't need to run init().
		// If we're not initialized, call init() using the game ID and the private key, which is converted to a string
		// with .readUTFBytes( ba.length ). The ba.length ensures that the ByteArray will be read from beginning to end
		// and then stop; otherwise, there would be an error when the end of the ByteArray was reached.
		
		FlxGameJolt.gameID = 19975;
		FlxGameJolt.gameKey = ba.readUTFBytes(ba.length);
		
		var open_session = new FlxGameJoltRequest(BATCH(false, false, [SESSION_CHECK, SESSION_OPEN]));
		open_session.onComplete.add(function(res)
		{
			if (res.responses[0].success)
			{
				_connection.text = "Welcome back to the main menu, " + FlxGameJolt.username + "!";
				return;
			}
			
			initCallback(res.responses[1].success);
		});
		open_session.onError.add((_) -> initCallback(false));
		open_session.send(false);
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		_mainMenuTime += elapsed;
		
		#if FLX_KEYBOARD
		if (FlxG.keys.justPressed.ENTER && _loginGroup.visible)
		{
			loginCallback("Login");
		}
		#end
		
		super.update(elapsed);
	}
	
	#if debug
	function colorCallback(Name:String):Void
	{
		Reg.genColors();
		FlxG.switchState(MenuState.new);
	}
	#end
	
	function playCallback(Name:String):Void
	{
		FlxG.switchState(PlayState.new);
	}
	
	function hfCallback(Name:String):Void
	{
		FlxG.openURL("http://www.haxeflixel.com");
	}
	
	function sourceCallback(Name:String):Void
	{
		FlxG.openURL("https://github.com/HaxeFlixel/flixel-addons/blob/master/flixel/addons/api/FlxGameJolt.hx");
	}
	
	function docCallback(Name:String):Void
	{
		FlxG.openURL("http://gamejolt.com/api/doc/game/");
	}
	
	function scoresCallback(Name:String):Void
	{
		// stuff
	}
	
	function switchMenu(Name:String):Void
	{
		if (_loginGroup.visible)
		{
			_input1.text = " ";
			_input2.text = " ";
		}
		
		for (g in _allScreens)
		{
			g.visible = false;
			g.active = false;
		}
		
		if (Name == "Back")
		{
			_main.visible = true;
			_main.active = true;
		}
		
		if (Name == "API Functions")
		{
			_apiTest.visible = true;
			_apiTest.active = true;
		}
		
		if (Name == "Log in")
		{
			_loginGroup.visible = true;
			_loginGroup.active = true;
		}
	}
	
	function loginCallback(Name:String):Void
	{
		FlxGameJolt.username = _input1.text.trim();
		FlxGameJolt.usertoken = _input2.text.trim();
		
		_connection.text = "Attempting to log in...";
		var login_request = new FlxGameJoltRequest(SESSION_OPEN);
		login_request.onComplete.add(res -> initCallback(res.success));
		login_request.onError.add((_) -> initCallback(false));
		login_request.send(false);
	}
	
	function mineCallback(Name:String):Void {}
	
	@:access(flixel.addons.api.gamejolt.FlxGameJolt.usertoken)
	function apiCallback(Name:String):Void
	{
		_imageDisplay.visible = false;
		_return.text = "Sending " + Name + " request to GameJolt...";
		
		var request:Null<FlxGameJoltRequest> = null;
		
		switch (Name)
		{
			case "BATCH":
				request = new FlxGameJoltRequest(BATCH(false, false, [USER_AUTH, SESSION_CHECK]));
			case "USER_AUTH":
				request = new FlxGameJoltRequest(USER_AUTH);
			case "SESSION_OPEN":
				request = new FlxGameJoltRequest(SESSION_OPEN);
			case "SESSION_PING":
				request = new FlxGameJoltRequest(SESSION_PING(true));
			case "SESSION_CLOSE":
				request = new FlxGameJoltRequest(SESSION_CLOSE);
			case "SESSION_CHECK":
				request = new FlxGameJoltRequest(SESSION_CHECK);
			case "TROPHIES_ADD":
				request = new FlxGameJoltRequest(TROPHIES_ADD(5079));
			case "TROPHIES_REMOVE":
				request = new FlxGameJoltRequest(TROPHIES_REMOVE(5079));
			case "TROPHIES_FETCH":
				request = new FlxGameJoltRequest(TROPHIES_FETCH(5079));
			case "SCORES_FETCH":
				request = new FlxGameJoltRequest(SCORES_FETCH(false));
			case "SCORES_ADD":
				var s = Math.round(_mainMenuTime);
				request = new FlxGameJoltRequest(SCORES_ADD('${s}secondsinmenu', s, "FlxPongRox"));
			case "SCORES_TABLES":
				request = new FlxGameJoltRequest(SCORES_TABLES);
			case "SCORES_GETRANK":
				request = new FlxGameJoltRequest(SCORES_GETRANK(Math.round(_mainMenuTime)));
			case "DATA_FETCH":
				request = new FlxGameJoltRequest(DATA_FETCH("testkey", true));
			case "DATA_SET":
				request = new FlxGameJoltRequest(DATA_SET("testkey", "IheartBACON", true));
			case "DATA_UPDATE":
				request = new FlxGameJoltRequest(DATA_UPDATE("testkey", Append("andSAUSAGE"), true));
			case "DATA_REMOVE":
				request = new FlxGameJoltRequest(DATA_REMOVE("testkey", true));
			case "DATA_GETKEYS":
				request = new FlxGameJoltRequest(DATA_GETKEYS(true));
			case "FRIENDS":
				request = new FlxGameJoltRequest(FRIENDS);
			case "TIME":
				request = new FlxGameJoltRequest(TIME);
			/*
				case "username":
					_return.text = "User name: " + FlxGameJolt.username;
				case "usertoken":
					_return.text = "User token: " + FlxGameJolt.usertoken;
			 */
			default:
				_return.text = "Sorry, there was an error. :(";
		}
		
		if (request != null)
		{
			request.onComplete.add(apiReturn);
			request.onError.add(err -> apiReturn({success: false, message: err}));
			request.send(false);
		}
	}
	
	function apiReturn(ReturnMap:FlxGameJoltResponse):Void
	{
		_return.text = 'Received from GameJolt:\n${ReturnMap}';
	}
	
	function testMove(Name:String):Void
	{
		_apiPages[_apiCurrentPage].visible = false;
		_apiPages[_apiCurrentPage].active = false;
		
		if (Name.charCodeAt(0) == 60)
		{
			_apiCurrentPage--;
		}
		else if (Name.charCodeAt(0) == 62)
		{
			_apiCurrentPage++;
		}
		
		if (_apiCurrentPage < 0)
			_apiCurrentPage = _apiPages.length - 1;
			
		if (_apiCurrentPage > _apiPages.length - 1)
			_apiCurrentPage = 0;
			
		_apiPages[_apiCurrentPage].visible = true;
		_apiPages[_apiCurrentPage].active = true;
	}
	
	function initCallback(Result:Bool):Void
	{
		if (_connection != null)
		{
			if (Result)
			{
				if (_connection != null)
				{
					_connection.text = "Successfully connected to GameJolt! Hi " + FlxGameJolt.username + "!";
				}
				
				new FlxGameJoltRequest(TROPHIES_ADD(5072)).send(false);
				
				if (_login.visible)
				{
					_login.visible = false;
					_login.active = false;
				}
				
				if (_loginGroup.visible == true)
				{
					switchMenu("Back");
				}
			}
			else
			{
				if (_connection != null)
				{
					_connection.text = "Unable to verify your information with GameJolt.";
				}
				_login.visible = true;
				_login.active = true;
			}
		}
	}
}
