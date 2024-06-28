package controls;

import Conductor.Rating;
import Replay.Ana;
import flixel.FlxG;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSort;
import lime.ui.GamepadButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;

class InputMethods
{
	private static var keysArray(get, null):Array<Dynamic>;
	private static function get_keysArray():Array<Dynamic>
	{
		var theThing = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		return theThing;
	}

    private static function getKeyFromEvent(key:FlxKey):Int
    {
        if(key != NONE)
        {
            for (i in 0...keysArray.length)
            {
                for (j in 0...keysArray[i].length)
                {
            		if(key == keysArray[i][j])
                    {
                        return i;
                    }
                }
            }
        }
        return -1;
	}
    
    public static function onKeyDown(limeKey:KeyCode, modifier:KeyModifier)
    {
		var instance:PlayState = PlayState.instance;

        var eventKey:FlxKey = fromKeyCodeToFlxKey(limeKey, modifier);
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);

		@:privateAccess
		if (!instance.cpuControlled && instance.startedCountdown && !instance.paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
		{
			if(!instance.boyfriend.stunned && instance.generatedMusic && !instance.endingSong)
			{
				var ana:Ana = new Ana(Conductor.songPosition, null, false, "miss", key);

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var sortedNotesList:Array<Note> = [];
				for (daNote in instance.notes)
				{
					if (instance.strumsBlocked[daNote.noteData] != true && daNote.canBeHit && daNote.recalculatePlayerNote(instance.opponentPlay) && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && !daNote.blockHit)
					{
						if(daNote.noteData == key) sortedNotesList.push(daNote);
						canMiss = true;
					}
				}

				sortedNotesList.sort(function(a:Note, b:Note)
				{
					if (a.lowPriority && !b.lowPriority)
						return 1;
					else if (!a.lowPriority && b.lowPriority)
						return -1;
				
					return FlxSort.byValues(FlxSort.ASCENDING, a.strumTime, b.strumTime);
				});

				if (sortedNotesList.length > 0) {
					var epicNote:Note = sortedNotesList[0];
					if (sortedNotesList.length > 1) {
						for (bad in 1...sortedNotesList.length)
						{
							var doubleNote:Note = sortedNotesList[bad];
							// no point in jack detection if it isn't a jack
							if (doubleNote.noteData != epicNote.noteData)
								break;
	
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								instance.notes.remove(doubleNote, true);
								doubleNote.destroy();
								break;
							} else if (doubleNote.strumTime < epicNote.strumTime)
							{
								// replace the note if its ahead of time
								epicNote = doubleNote; 
								break;
							}
						}
					}

					// eee jack detection before was not super good
					var noteDiffSigned:Float = (epicNote.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
					instance.goodNoteHit(epicNote);
					ana.hit = true;
					ana.hitJudge = Conductor.judgeNote(epicNote, noteDiffSigned).name;
					ana.nearestNote = [epicNote.strumTime, epicNote.noteData, epicNote.sustainLength];
				}
				else{
					instance.callOnLuas('onGhostTap', [key]);
					if (canMiss) {
						instance.noteMissPress(key);
						ana.hit = false;
						ana.hitJudge = "shit";
						ana.nearestNote = [];
					}
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				instance.keysPressed[key] = true;
			}

			var spr:StrumNote = (instance.opponentPlay ? instance.opponentStrums.members[key] : instance.playerStrums.members[key]);
			if(instance.strumsBlocked[key] != true && spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			instance.callOnLuas('onKeyPress', [key]);
		}
		//trace('pressed: ' + controlArray);
    }

	public static function onKeyRelease(limeKey:KeyCode, modifier:KeyModifier)
	{
		var instance:PlayState = PlayState.instance;

        var eventKey:FlxKey = fromKeyCodeToFlxKey(limeKey, modifier);
		var key:Int = getKeyFromEvent(eventKey);

		@:privateAccess
		if(!instance.cpuControlled && instance.startedCountdown && !instance.paused && key > -1)
		{
			var spr:StrumNote = (instance.opponentPlay ? instance.opponentStrums.members[key] : instance.playerStrums.members[key]);
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			instance.callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

    public static function fromKeyCodeToFlxKey(key:KeyCode, modifier:KeyModifier) // I am SO sorry this is so fucking long - Binpuki
	{
		switch (key)
		{
			case UNKNOWN:
				return FlxKey.NONE;
			case A:
				return FlxKey.A;
			case B:
				return FlxKey.B;
			case C:
				return FlxKey.C;
			case D:
				return FlxKey.D;
			case E:
				return FlxKey.E;
			case F:
				return FlxKey.F;
			case G:
				return FlxKey.G;
			case H:
				return FlxKey.H;
			case I:
				return FlxKey.I;
			case J:
				return FlxKey.J;
			case K:
				return FlxKey.K;
			case L:
				return FlxKey.L;
			case M:
				return FlxKey.M;
			case N:
				return FlxKey.N;
			case O:
				return FlxKey.O;
			case P:
				return FlxKey.P;
			case Q:
				return FlxKey.Q;
			case R:
				return FlxKey.R;
			case S:
				return FlxKey.S;
			case T:
				return FlxKey.T;
			case U:
				return FlxKey.U;
			case V:
				return FlxKey.V;
			case W:
				return FlxKey.W;
			case X:
				return FlxKey.X;
			case Y:
				return FlxKey.Y;
			case Z:
				return FlxKey.Z;
			case NUMBER_0:
				return FlxKey.ZERO;
			case NUMBER_1:
				return FlxKey.ONE;
			case NUMBER_2:
				return FlxKey.TWO;
			case NUMBER_3:
				return FlxKey.THREE;
			case NUMBER_4:
				return FlxKey.FOUR;
			case NUMBER_5:
				return FlxKey.FIVE;
			case NUMBER_6:
				return FlxKey.SIX;
			case NUMBER_7:
				return FlxKey.SEVEN;
			case NUMBER_8:
				return FlxKey.EIGHT;
			case NUMBER_9:
				return FlxKey.NINE;
			case PAGE_UP:
				return FlxKey.PAGEUP;
			case PAGE_DOWN:
				return FlxKey.PAGEDOWN;
			case HOME:
				return FlxKey.HOME;
			case END:
				return FlxKey.END;
			case INSERT:
				return FlxKey.INSERT;
			case ESCAPE:
				return FlxKey.ESCAPE;
			case MINUS:
				return FlxKey.MINUS;
			case PLUS:
				return FlxKey.PLUS;
			case DELETE:
				return FlxKey.DELETE;
			case BACKSPACE:
				return FlxKey.BACKSPACE;
			case LEFT_BRACKET:
				return FlxKey.LBRACKET;
			case RIGHT_BRACKET:
				return FlxKey.RBRACKET;
			case BACKSLASH:
				return FlxKey.BACKSLASH;
			case CAPS_LOCK:
				return FlxKey.CAPSLOCK;
			case SEMICOLON:
				return FlxKey.SEMICOLON;
			case QUOTE:
				return FlxKey.QUOTE;
			case RETURN:
				return FlxKey.ENTER;
			case COMMA:
				return FlxKey.COMMA;
			case PERIOD:
				return FlxKey.PERIOD;
			case SLASH:
				return FlxKey.SLASH;
			case GRAVE:
				return FlxKey.GRAVEACCENT;
			case SPACE:
				return FlxKey.SPACE;
			case UP:
				return FlxKey.UP;
			case DOWN:
				return FlxKey.DOWN;
			case LEFT:
				return FlxKey.LEFT;
			case RIGHT:
				return FlxKey.RIGHT;
			case TAB:
				return FlxKey.TAB;
			case PRINT_SCREEN:
				return FlxKey.PRINTSCREEN;
			case F1:
				return FlxKey.F1;
			case F2:
				return FlxKey.F2;
			case F3:
				return FlxKey.F3;
			case F4:
				return FlxKey.F4;
			case F5:
				return FlxKey.F5;
			case F6:
				return FlxKey.F6;
			case F7:
				return FlxKey.F7;
			case F8:
				return FlxKey.F8;
			case F9:
				return FlxKey.F9;
			case F10:
				return FlxKey.F10;
			case F11:
				return FlxKey.F11;
			case F12:
				return FlxKey.F12;
			case NUMPAD_0:
				return FlxKey.NUMPADZERO;
			case NUMPAD_1:
				return FlxKey.NUMPADONE;
			case NUMPAD_2:
				return FlxKey.NUMPADTWO;
			case NUMPAD_3:
				return FlxKey.NUMPADTHREE;
			case NUMPAD_4:
				return FlxKey.NUMPADFOUR;
			case NUMPAD_5:
				return FlxKey.NUMPADFIVE;
			case NUMPAD_6:
				return FlxKey.NUMPADSIX;
			case NUMPAD_7:
				return FlxKey.NUMPADSEVEN;
			case NUMPAD_8:
				return FlxKey.NUMPADEIGHT;
			case NUMPAD_9:
				return FlxKey.NUMPADNINE;
			case NUMPAD_MINUS:
				return FlxKey.NUMPADMINUS;
			case NUMPAD_PLUS:
				return FlxKey.NUMPADPLUS;
			case NUMPAD_PERIOD:
				return FlxKey.NUMPADPERIOD;
			case NUMPAD_MULTIPLY:
				return FlxKey.NUMPADMULTIPLY;
			default:
				return fromKeyModifierToFlxKey(modifier);
		}

		return FlxKey.NONE;
	}

	static function fromKeyModifierToFlxKey(modif:KeyModifier):FlxKey
	{
		if (modif.shiftKey)
			return FlxKey.SHIFT;
		if (modif.ctrlKey)
			return FlxKey.CONTROL;
		if (modif.altKey)
			return FlxKey.ALT;

		return FlxKey.NONE;
	}
}