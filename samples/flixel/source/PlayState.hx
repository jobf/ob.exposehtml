package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if web
import js.Browser.document;
import ob.exposehtml.Expose;
#end

class PlayState extends FlxState
{
	var bouncer:BouncingSprite;
	var bouncerRed:Int;
	var bouncingIsEnabled:Bool = true;

	var message = "Hello World!";
	var text:FlxText;
	var random = new FlxRandom();

	override public function create()
	{
		super.create();

		bouncer = new BouncingSprite(0, 0);
		bouncer.screenCenter();
		bouncer.y = 0;
		add(bouncer);
		bouncerRed = bouncer.color.red;

		message = "Hello World!";
		text = new FlxText(0, 0, 0, message, 42);
		text.screenCenter();
		add(text);

		expose();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!FlxG.worldBounds.containsPoint(bouncer.getMidpoint()))
		{
			bouncer.bounce();
		}
	}

	function expose()
	{
		#if web
		var expose = new Expose(document);
		expose.Button("Shuffle", "Change the text", shuffleMessage);
		expose.Numeric(text, "x", 10, "Position: X");
		expose.Numeric(bouncer, "angle", 12.5);
		expose.Numeric(this, "bouncerRed", 1, "Red", changeBouncerRed);
		expose.Checkbox(text, "visible");
		expose.Checkbox(this, "bouncingIsEnabled", toggleBounce);
		#end
	}

	function shuffleMessage()
	{
		var chars = message.split("");
		random.shuffle(chars);
		message = chars.join("");
		text.text = message;
	}

	function changeBouncerRed(v:Float)
	{
		bouncerRed = Std.int(v);
		bouncer.color = FlxColor.fromRGB(bouncerRed, bouncer.color.green, bouncer.color.green);
	}

	function toggleBounce(v:Bool)
	{
		bouncer.toggleBounce(v);
	}
}
