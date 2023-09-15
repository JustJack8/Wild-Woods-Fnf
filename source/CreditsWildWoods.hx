package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class CreditsWildWoods extends MusicBeatState
{
    private var notebookGrp:FlxTypedGroup<NoteBookSpr>;

    // DEBUG THING
	var editMode:Bool = false;
	var editableSprite:FlxSprite;
	var lpo:Int = 700;

    public var chars:Array<String> = [
        'jorclaiyteahlol',
        'slightlycredited',
        'justjackcredited',
        'klawkredit',
        'snowmanjoecredit',
        'gummycred',
        'majii',
        'jacobe',
        'pixlplanett'
    ];

    override public function create():Void
    {
        notebookGrp = new FlxTypedGroup<NoteBookSpr>();
		add(notebookGrp);

		for (i in 0...chars.length)
        {
            var noteBookSpr:NoteBookSpr = new NoteBookSpr((300 * i) + 400, 35);
            noteBookSpr.loadGraphic(Paths.image('creditsChars/' + chars[i], 'preload'));
            noteBookSpr.coolNoteBookX = i;
            notebookGrp.add(noteBookSpr);
            //noteBookSpr.scale.set(1.5, 1.5);
            noteBookSpr.antialiasing = false;
            //noteBookSpr.cameras = [camBG];

            editableSprite = noteBookSpr;
		    editMode = true; 
        }

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        if (editMode)
			{
				if (FlxG.keys.pressed.SHIFT)
					{
						editableSprite.x = FlxG.mouse.screenX;
						editableSprite.y = FlxG.mouse.screenY;
					}
				else if (FlxG.keys.justPressed.C)
					{
						trace(editableSprite.x);
						trace(editableSprite.y);
						trace(lpo);
					}
				else if (FlxG.keys.justPressed.E)
					{
						if (FlxG.keys.pressed.ALT)
							lpo += 100;
						else
							lpo += 15;
						editableSprite.setGraphicSize(Std.int(lpo));
						editableSprite.updateHitbox();
					}
				else if (FlxG.keys.justPressed.Q)
					{
						if (FlxG.keys.pressed.ALT)
							lpo -= 100;
						else
							lpo -= 15;
						editableSprite.setGraphicSize(Std.int(lpo));
						editableSprite.updateHitbox();
					}
				else if (FlxG.keys.justPressed.L)
					{
						if (FlxG.keys.pressed.ALT)
							editableSprite.x += 50;
						else
							editableSprite.x += 1;
					}
				else if (FlxG.keys.justPressed.K)
						{
							if (FlxG.keys.pressed.ALT)
								editableSprite.y += 50;
							else
								editableSprite.y += 1;
						}
				else if (FlxG.keys.justPressed.J)
					{
						if (FlxG.keys.pressed.ALT)
							editableSprite.x -= 50;
						else
							editableSprite.x -= 1;
					}
				else if (FlxG.keys.justPressed.I)
					{
						if (FlxG.keys.pressed.ALT)
							editableSprite.y -= 50;
						else
							editableSprite.y -= 1;
					}
			}

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }

        super.update(elapsed);
    }
}

class NoteBookSpr extends FlxSprite
{
    public var coolNoteBookX:Int;

    public function new(?x:Float = 0, ?x:Float = 0)
    {
        super(x, x);
    }

    override function update(elapsed:Float) {
        x = FlxMath.lerp(x, (FlxMath.remapToRange(coolNoteBookX, 0, 1, 0, 1.3) * 2260) + 50, CoolUtil.boundTo(elapsed * 9.6, 0, 1));
        super.update(elapsed);
    } 

}