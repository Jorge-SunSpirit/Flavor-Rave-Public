package;

import flixel.FlxG;

using StringTools;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	public static var songAccuracy:Map<String, Float> = new Map();
	public static var songRating:Map<String, Float> = new Map();
	public static var songLetter:Map<String, String> = new Map();
	public static var songCombo:Map<String, String> = new Map();
	#else
	public static var weekScores:Map<String, Int> = new Map<String, Int>();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songAccuracy:Map<String, Float> = new Map<String, Float>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();
	public static var songLetter:Map<String, String> = new Map<String, String>();
	public static var songCombo:Map<String, String> = new Map<String, String>();
	#end


	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0);
		setAccuracy(daSong, 0);
		setRating(daSong, 0);
		setLetter(daSong, '');
		setCombo(daSong, '');
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1, ?accuracy:Float = -1):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score) {
				setScore(daSong, score);
				if(rating >= 0) setRating(daSong, rating);
			}
		}
		else {
			setScore(daSong, score);
			if(rating >= 0) setRating(daSong, rating);
		}
	}

	public static function saveAccuracy(song:String, accuracy:Float, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songAccuracy.exists(daSong))
		{
			if (songAccuracy.get(daSong) < accuracy)
				setAccuracy(daSong, accuracy);
		}
		else
			setAccuracy(daSong, accuracy);
	}

	public static function saveLetter(song:String, letter:String, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songLetter.exists(daSong))
		{
			if (getLetterInt(songLetter.get(daSong)) < getLetterInt(letter))
				setLetter(daSong, letter);
		}
		else
			setLetter(daSong, letter);
	}

	public static function saveCombo(song:String, combo:String, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		var finalCombo:String = combo.split(')')[0].replace('(', '');

		if (songCombo.exists(daSong))
		{
			if (getComboInt(songCombo.get(daSong)) < getComboInt(finalCombo))
				setCombo(daSong, finalCombo);
		}
		else
			setCombo(daSong, finalCombo);
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		}
		else
			setWeekScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}
	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}

	static function setLetter(song:String, letter:String):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songLetter.set(song, letter);
		FlxG.save.data.songLetter = songLetter;
		FlxG.save.flush();
	}

	static function setCombo(song:String, combo:String):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songCombo.set(song, combo);
		FlxG.save.data.songCombo = songCombo;
		FlxG.save.flush();
	}

	static function setAccuracy(song:String, accuracy:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songAccuracy.set(song, accuracy);
		FlxG.save.data.songAccuracy = songAccuracy;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + CoolUtil.getDifficultyFilePath(diff);
	}

	static function getLetterInt(letter:String):Int
	{
		switch (letter)
		{
			case 'D':
				return 0;
			case 'C':
				return 1;
			case 'B':
				return 2;
			case 'A':
				return 3;
			case 'S':
				return 4;
			default:
				return -1;
		}
	}

	static function getComboInt(combo:String):Int
	{
		switch (combo)
		{
			case 'Clear':
				return 0;
			case 'SDCB':
				return 1;
			case 'FC':
				return 2;
			case 'GFC':
				return 3;
			case 'SFC':
				return 4;
			case 'MFC':
				return 5;				
			default:
				return -1;
		}
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getLetter(song:String, diff:Int):String
	{
		var daSong:String = formatSong(song, diff);
		if (!songLetter.exists(daSong))
			setLetter(daSong, '');
		
		return songLetter.get(daSong);
	}	

	public static function getCombo(song:String, diff:Int):String
	{
		var daSong:String = formatSong(song, diff);
		if (!songCombo.exists(daSong))
			setCombo(daSong, '');

		return songCombo.get(daSong);
	}

	public static function checkSongFC(song:String, diff:Int):Bool
	{
		var daRank:String = getCombo(song, diff);
		var daMirrorRank:String = getCombo(song + '-opponent', diff);
		var hasFCd:Bool = false;

		//Used to be a for i .. 0 thingie but it did not work :(
		if (!hasFCd && (daRank == 'FC' || daRank == 'GFC' || daRank == 'SFC' || daRank == 'MFC'))
			hasFCd = true;

		if (!hasFCd && (daMirrorRank == 'FC' || daMirrorRank == 'GFC' || daMirrorRank == 'SFC' || daMirrorRank == 'MFC'))
			hasFCd = true;
		return hasFCd;
	}

	public static function checkSongSideFC(song:String, diff:Int):Bool
	{
		var daRank:String = getCombo(song, diff);
		
		if (daRank == 'FC' || daRank == 'GFC' || daRank == 'SFC' || daRank == 'MFC')
			return true;
	
		return false;
	}

	public static function getAccuracy(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songAccuracy.exists(daSong))
			setAccuracy(daSong, 0);

		return songAccuracy.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	inline public static function checkBeaten(song:String, diff:Int, ?forceSide:String = ''):Bool
	{
		var isBeaten:Bool = false;
		switch (forceSide.toLowerCase())
		{
			case 'left':
				isBeaten = getScore(song + '-opponent', diff) > 0;
			case 'right':
				isBeaten = getScore(song, diff) > 0;
			default: //Just incase
				isBeaten = getScore(song, diff) > 0 || getScore(song + '-opponent', diff) > 0;
		}

		// Automatically unlock if in debug mode.
		#if FORCE_DEBUG_VERSION
		if (!isBeaten) FlxG.log.warn('[HS] $song isn\'t beaten, but forcing beaten due to debug.');
		return true;
		#else
		return isBeaten;
		#end
	}

	inline public static function checkWeekBeaten(week:String, diff:Int):Bool
	{
		var isBeaten:Bool = getWeekScore(week, diff) > 0 || getWeekScore(week + '-opponent', diff) > 0;

		// Automatically unlock if in debug mode.
		#if FORCE_DEBUG_VERSION
		if (!isBeaten) FlxG.log.warn('[HS] $week isn\'t beaten, but forcing beaten due to debug.');
		return true;
		#else
		return isBeaten;
		#end
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
		{
			weekScores = FlxG.save.data.weekScores;
		}
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songAccuracy != null)
		{
			songAccuracy = FlxG.save.data.songAccuracy;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
		if (FlxG.save.data.songLetter != null)
		{
			songLetter = FlxG.save.data.songLetter;
		}		
		if (FlxG.save.data.songCombo != null)
		{
			songCombo = FlxG.save.data.songCombo;
		}			
	}
}