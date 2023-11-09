package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class CreditsWildWoods extends MusicBeatState
{
	private static var curSelected:Int = 0;
    private var notebookGrp:FlxTypedGroup<NoteBookSpr>;

    // DEBUG THING
	var editMode:Bool = false;
	var editableSprite:FlxSprite;
	var lpo:Int = 700;

    public var chars:Array<Array<String>> = [
        ['jorclaiyteahlol', 'https://www.twitter.com/OfficialJorclai'],
		['slightlycredited', 'https://twitter.com/SlightlyCre'],
		['justjackcredited', 'https://twitter.com/Just_Jack6'],
		['klawkredit', 'https://www.twitter.com/KlawkSandwich'],
		['snowmanjoecredit', 'https://twitter.com/GummyIsDummy'],
		['gummycred', ''],
		['majii', 'https://www.twitter.com/liminalstarboy'],
		['jacobe', ''],
		['pixlplanett', '']
    ];

    override public function create():Void
    {
        notebookGrp = new FlxTypedGroup<NoteBookSpr>();
		add(notebookGrp);

		for (i in 0...chars.length)
        {
            var noteBookSpr:NoteBookSpr = new NoteBookSpr((1000 * i), 35);
            noteBookSpr.loadGraphic(Paths.image('creditsChars/' + chars[i][0], 'preload'));
            noteBookSpr.coolNoteBookX = i;
            notebookGrp.add(noteBookSpr);
            //noteBookSpr.scale.set(1.5, 1.5);
            noteBookSpr.antialiasing = false;
            //noteBookSpr.cameras = [camBG];

            editableSprite = noteBookSpr;
		    editMode = true; 
        }

		changeSelection();

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
		if (controls.UI_LEFT_P)
		{
			changeSelection(-1);
		}

		if (controls.UI_RIGHT_P)
		{
			changeSelection(1);
		}

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

		if(controls.ACCEPT && chars[curSelected][1] != '') {
			CoolUtil.browserLoad(chars[curSelected][1]);
		}

        super.update(elapsed);
    }

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	
		curSelected += change;
	
		if (curSelected < 0)
			curSelected = chars.length - 1;
		if (curSelected >= chars.length)
			curSelected = 0;
		
		var i = 0;
		for(item in notebookGrp.members) {
			item.coolNoteBookX = i - curSelected;
			i++;
		}
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
        x = FlxMath.lerp(x, (FlxMath.remapToRange(coolNoteBookX, 0, 1, 0, 1.3) * 3060) + 50, CoolUtil.boundTo(elapsed * 9.6, 0, 1));
        super.update(elapsed);
    } 

}