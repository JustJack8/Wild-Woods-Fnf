package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Alphabet;

class CrashReportSubState extends FlxSubState {
	var underText:FlxText;

	public function new(error:String, errorName:String):Void {
		super(flixel.util.FlxColor.TRANSPARENT);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bg.scrollFactor.set();
		bg.alpha = 0;
		add(bg);

		var coolText:Alphabet = new Alphabet(0, 32, "UNCAUGHT ERROR", true);
		coolText.screenCenter(X);
		add(coolText);

		var formattedErrorMessage:String = 'Your game has crashed! :(\nError caught: ${errorName}\n\n${error}\n\nPlease report this error';

		var report:FlxText = new FlxText(0, 0, FlxG.width / 1.5, formattedErrorMessage);
		report.setFormat(Paths.font('vcr.ttf'), 32, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
		report.screenCenter(XY);
		report.borderSize = 1.5;
		add(report);

		underText = new FlxText(0, FlxG.height - 64, FlxG.width, "Press SPACE to return to the Title Screen");
		underText.setFormat(Paths.font('vcr.ttf'), 24, 0xFFFFFFFF, CENTER, OUTLINE, 0xFF000000);
		underText.y = FlxG.height - underText.height - 16;
		underText.borderSize = 1;
		underText.screenCenter(X);
		add(underText);

		FlxTween.tween(bg, {alpha: 0.6}, 0.6, {ease: FlxEase.cubeOut});

		this.camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
	}

	public var curState:Int = 0;
	public var statesToGo:Array<String> = [
		"Title Screen", /*"Main Menu",*/
		"Freeplay Menu" /*"Options Menu", "Back to Gameplay"*/];

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT) {
			curState = flixel.math.FlxMath.wrap(curState + (FlxG.keys.justPressed.RIGHT ? 1 : -1), 0, statesToGo.length - 1);
			underText.text = 'Press SPACE to return to the ${statesToGo[curState]}';
		}

		if (FlxG.keys.justPressed.SPACE)
			close();
	}

	override function close():Void {
		switch (statesToGo[curState]) {
			case "Freeplay Menu":
				FlxG.switchState(new FreeplayState());
			default:
				FlxG.switchState(new TitleState());
		}
		super.close();
	}
}