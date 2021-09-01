import flixel.FlxSprite;
import flixel.util.FlxColor;

class BouncingSprite extends FlxSprite
{
	var speed:Float = 300;
	var accelerationHasStopped:Bool = false;
	var isBouncing:Bool = true;
	var lastVelocity:Float;

	public function new(x, y)
	{
		super(x, y);
		makeGraphic(42, 42, FlxColor.YELLOW);
		acceleration.y = speed;
	}

	public function bounce()
	{
		velocity.y *= -1;
	}

	public function toggleBounce(v:Bool)
	{
		if (isBouncing)
		{
			lastVelocity = velocity.y;
			velocity.y = 0;
			acceleration.y = 0;
		}
		else
		{
			velocity.y = lastVelocity;
			acceleration.y = speed;
		}
		isBouncing = v;
	}
}
