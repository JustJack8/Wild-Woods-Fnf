package;

import openfl.events.KeyboardEvent;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'Play',
		'Freeplay',
		'Settings',
		'Credits'
	];

	var debugKeys:Array<FlxKey>;

	// DEBUG THING
	var editMode:Bool = false;
	var editableSprite:FlxSprite;
	var lpo:Int = 700;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-12, -5).loadGraphic(Paths.image('menuStuff/nightskybg'));
		bg.setGraphicSize(Std.int(1305));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var logo:FlxSprite = new FlxSprite(4, 111).loadGraphic(Paths.image('menuStuff/mitw_logo'));
		logo.setGraphicSize(Std.int(590));
		logo.updateHitbox();
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		add(logo);

		var stupidass:FlxSprite = new FlxSprite(506, 23).loadGraphic(Paths.image('menuStuff/stupidass'));
		stupidass.setGraphicSize(Std.int(875));
		stupidass.updateHitbox();
		stupidass.antialiasing = ClientPrefs.globalAntialiasing;
		add(stupidass);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var menuItem:Alphabet = new Alphabet(0, 0, optionShit[i]);
			menuItem.scaleX = 1.2;
			menuItem.scaleY = 1.2;
			menuItem.ID = i;
			switch (i)
			{
				case 0:
					menuItem.x = 90;
					menuItem.y = 571;
				case 1:
					menuItem.x = 300;
					menuItem.y = 571;
				case 2:
					menuItem.x = 650;
					menuItem.y = 571;
				case 3:
					menuItem.x = 1005;
					menuItem.y = 571;
			}
			menuItems.add(menuItem);

			editableSprite = menuItem;
			editMode = true; 
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
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
						trace(editableSprite);
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

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P || controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P || controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice)
							{
								case 'story_mode':
									MusicBeatState.switchState(new StoryMenuState());
								case 'freeplay':
									MusicBeatState.switchState(new FreeplayState());
								case 'credits':
									MusicBeatState.switchState(new CreditsWildWoods());
								case 'options':
									LoadingState.loadAndSwitchState(new options.OptionsState());
							}
						});
					}
				});
				
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
			{
				spr.alpha  = 1;
				FlxTween.tween(spr.scale, {x:1.3, y:1.3}, 0.1, {ease: FlxEase.quadOut});
			}
			else
			{
				spr.alpha = 0.8;
				FlxTween.tween(spr.scale, {x:1.2, y:1.2}, 0.1, {ease: FlxEase.quadOut});
			}
		});
	}
}