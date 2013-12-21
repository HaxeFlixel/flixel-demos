package;

import flixel.addons.api.FlxGameJolt;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxCollision;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var ball:Ball;
	public var emitterGroup:FlxTypedGroup<Emitter>;
	public var collidables:FlxGroup;
	
	private var _obstacles:FlxTypedGroup<PongSprite>;
	private var _centerText:FlxText;
	private var _player:Player;
	private var _debris:Emitter;
	private var _enemy:Enemy;
	private var _enemyBullets:Emitter;
	private var _paused:Bool = false;
	
	override public function create():Void
	{
		Reg.PS = this;
		FlxG.cameras.bgColor = Reg.lite;
		
		#if !FLX_NO_MOUSE
		FlxG.mouse.hide();
		#end
		
		_debris = new Emitter(FlxG.width, 0, 2, Reg.med_lite );
		_debris.height = FlxG.height;
		_debris.setXSpeed( Reg.level * -10, Reg.level * -1 );
		_debris.setYSpeed( -10, 10 );
		
		_player = new Player();
		
		_enemy = new Enemy();
		
		ball = new Ball();
		
		emitterGroup = new FlxTypedGroup<Emitter>( 5 );
		_obstacles = new FlxTypedGroup<PongSprite>( 10 );
		newObstacle();
		
		_centerText = new FlxText( 0, 0, FlxG.width, "" );
		_centerText.alignment = "center";
		_centerText.color = Reg.med_dark;
		_centerText.y = Std.int( ( FlxG.height - _centerText.height ) / 2 );
		
		add( _debris );
		add( emitterGroup );
		add( _player );
		add( _enemy );
		add( ball );
		add( _obstacles );
		add( _centerText );
		
		collidables = new FlxGroup();
		
		var topWall:PongSprite = new PongSprite( 0, -2, FlxG.width, 2, Reg.dark );
		var bottomWall:PongSprite = new PongSprite( 0, FlxG.height, FlxG.width, 2, Reg.dark );
		topWall.moves = false;
		bottomWall.moves = false;
		topWall.immovable = true;
		bottomWall.immovable = true;
		
		collidables.add( _obstacles );
		collidables.add( topWall );
		collidables.add( bottomWall );
		collidables.add( _player );
		collidables.add( _enemy );
		
		_debris.start( false );
		
		FlxGameJolt.addTrophy( 5071 );
		
		super.create();
		
		ball.init();
		_player.init();
		_enemy.init();
	}
	
	override public function update():Void
	{
		#if !FLX_NO_KEYBOARD
		if ( FlxG.keys.justPressed.P ) {
			_paused = !_paused;
		}
		if ( FlxG.keys.justPressed.ESCAPE ) {
			FlxG.switchState( new MenuState() );
		}
		#end
		
		if ( _paused ) {
			return;
		}
		
		_player.y = FlxMath.bound( FlxG.mouse.y, 0, FlxG.height - _player.height );
		
		if ( ball.alive ) {
			if ( ball.x > FlxG.width ) {
				ball.kill();
				_enemy.kill();
				Reg.level++;
				_centerText.text = "Nice! Moving on to level " + Reg.level + "!";
				
				FlxGameJolt.addScore( Std.string( Reg.level - 1 ) + " enemies destroyed", Reg.level - 1, 20599 );
				
				FlxTimer.start( 4, newEnemy, 1 );
			}
			
			if ( ball.x < 0 ) {
				ball.kill();
				_player.kill();
				_centerText.text = "Aww! You lost. You got as far as level " + Reg.level + " though, so there's that.";
				FlxTimer.start( 4, endGame, 1 );
			}
		}
		
		super.update();
	}
	
	public function newEnemy( f:FlxTimer ):Void
	{
		_centerText.text = "";
		_debris.setXSpeed( Reg.level * -10, Reg.level * -1 );
		_enemy.reset(0,0);
		ball.reset( FlxG.width / 2, FlxG.height / 2 );
		newObstacle();
	}
	
	public function newObstacle():Void
	{
		var obs:PongSprite = _obstacles.recycle( PongSprite, [ FlxG.width, FlxRandom.intRanged( 0, FlxG.height ), FlxRandom.intRanged( 1, 20 ), FlxRandom.intRanged( 4, 40 ), Reg.med_dark ] );
		obs.velocity.x = FlxRandom.floatRanged( -100, -1 );
		obs.velocity.y = FlxRandom.floatRanged( -10, 10 );
		//obs.moves = false;
		obs.immovable = true;
	}
	
	private function endGame( f:FlxTimer ):Void
	{
		FlxG.switchState( new MenuState() );
	}
}