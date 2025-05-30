package;

import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import haxe.Json;
import MapJson;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#else
import openfl.utils.Assets;
#end

using StringTools;

class Language
{
	public static var gameplay:LanguageData = null;
	public static var option:LanguageData = null;
	public static var flavor:LanguageData = null;
	public static var font:LanguageFontData = null;

	public static function init():Void {
		gameplay = new LanguageData('Gameplay');
		option = new LanguageData('Option');
		flavor = new LanguageData('Flavor');
		font = new LanguageFontData('Font');
	}
}

class LanguageData
{
	private var _map:Map<String, String> = new Map();
	
	#if LOG_LANGUAGE
	private var name:String = '';
	#end

	public function new(file:String) {
		#if LOG_LANGUAGE
		name = file;
		#end

		var jsonName:String = 'data/language$file.json';

		#if MODS_ALLOWED
		var path:String = Paths.modFolders(jsonName);
		if (!FileSystem.exists(path)) {
			path = Paths.getPreloadPath(jsonName);
		}

		if (FileSystem.exists(path))
		#else
		var path:String = Paths.getPreloadPath(jsonName);
		if (Assets.exists(path))
		#end
		{
			var lang:MapJsonFile = cast Json.parse(File.getContent(path));

			for (data in lang.map) {
				_map.set(data.key, data.value);
			}
		}
	}

	public function get(key:String, ?fallback:String):String {
		key = formatKey(key);

		#if LOG_LANGUAGE
		if (fallback != null) {
			trace('[$name] key: "$key" | value: "${fallback.replace('\n', "{NL}")}"');
		}
		#end

		if (_map.exists(key)) {
			return _map.get(key);
		}
		else {
			if (fallback == null) fallback = key;
			return fallback;
		}
	}

	// Taking this from Psych Engine 1.0.0
	inline private function formatKey(key:String)
	{
		var invalidChars = ~/[~&\\;:<>#]/;
		var hideChars = ~/[.,'"%?!]/;

		var key = invalidChars.split(key.replace(' ', '_')).join('');
		key = hideChars.split(key).join("").toLowerCase().trim().replace(':', '');
		return key;
	}
}

class LanguageFontData extends LanguageData
{
	private var _mapScale:Map<String, Float> = new Map();
	private var _mapOffset:Map<String, Float> = new Map();

	override public function new(file:String) {
		super(file);

		for (key in this._map.keys()) {
			var value:String = this._map.get(key);
			var array:Array<String> = value.split(';');

			_map.set(key, array[0]);
			_mapScale.set(key, Std.parseFloat(array[1]));
			_mapOffset.set(key, Std.parseFloat(array[2]));
		}
	}

	override public function get(key:String, ?fallback:String):String {
		var result:String = super.get(key);

		if (result != key) {
			return Paths.font(result);
		}
		else {
			return Paths.font("GoNotoCurrent.ttf");
		}
	}

	public function getSize(key:String, size:Int):Int {
		key = formatKey(key);

		if (_mapScale.exists(key) && !Math.isNaN(_mapScale.get(key))) {
			return Std.int(size * _mapScale.get(key));
		}
		else {
			return size;
		}
	}

	public function getOffset(key:String, size:Int):Float {
		key = formatKey(key);

		if (_mapOffset.exists(key) && !Math.isNaN(_mapOffset.get(key))) {
			return size * _mapOffset.get(key);
		}
		else {
			return 0;
		}
	}
}

// FlxText extensions
class LanguageText extends FlxText
{
	/**
	 * Creates a new `LanguageText` object at the specified position.
	 *
	 * @param   X              The x position of the text.
	 * @param   Y              The y position of the text.
	 * @param   FieldWidth     The `width` of the text object. Enables `autoSize` if `<= 0`.
	 *                         (`height` is determined automatically).
	 * @param   Text           The actual text you would like to display initially.
	 * @param   Size           The font size for this text object.
	 * @param   Font           The name of the font face for the text display.
	 */
	override public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, ?Font:String)
	{
		super(X, Y + Language.font.getOffset(Font, Size), FieldWidth, Text, Language.font.getSize(Font, Size), true);
		font = Language.font.get(Font);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	/**
	 * You can use this if you have a lot of text parameters to set instead of the individual properties.
	 *
	 * @param	Color			The color of the text in `0xRRGGBB` format.
	 * @param	Alignment		The desired alignment
	 * @param	BorderStyle		Which border style to use
	 * @param	BorderColor 	Color for the border, `0xAARRGGBB` format
	 * @return	This `LanguageText` instance (nice for chaining stuff together, if you're into that).
	 */
	public function setStyle(Color:FlxColor = FlxColor.WHITE, ?Alignment:FlxTextAlign, ?BorderStyle:FlxTextBorderStyle,
		BorderColor:FlxColor = FlxColor.TRANSPARENT):LanguageText
	{
		setFormat(font, size, Color, Alignment, BorderStyle, BorderColor, true);
		return this;
	}
}

class LanguageTypeText extends FlxTypeText
{
	/**
	 * Create a `LanguageTypeText` object, which is very similar to `LanguageText` except that the text is
	 * initially hidden and can be animated one character at a time by calling start().
	 *
	 * @param	X				The X position for this object.
	 * @param	Y				The Y position for this object.
	 * @param	Width			The width of this object. Text wraps automatically.
	 * @param	Text			The text that will ultimately be displayed.
	 * @param	Size			The size of the text.
	 * @param   Font            The name of the font face for the text display.
	 */
	override public function new(X:Float = 0, Y:Float = 0, Width:Int, ?Text:String, Size:Int = 8, ?Font:String)
	{
		super(X, Y + Language.font.getOffset(Font, Size), Width, Text, Language.font.getSize(Font, Size), true);
		font = Language.font.get(Font);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	/**
	 * You can use this if you have a lot of text parameters to set instead of the individual properties.
	 *
	 * @param	Color			The color of the text in `0xRRGGBB` format.
	 * @param	Alignment		The desired alignment
	 * @param	BorderStyle		Which border style to use
	 * @param	BorderColor 	Color for the border, `0xAARRGGBB` format
	 * @return	This `LanguageTypeText` instance (nice for chaining stuff together, if you're into that).
	 */
	public function setStyle(Color:FlxColor = FlxColor.WHITE, ?Alignment:FlxTextAlign, ?BorderStyle:FlxTextBorderStyle,
		BorderColor:FlxColor = FlxColor.TRANSPARENT):LanguageTypeText
	{
		setFormat(font, size, Color, Alignment, BorderStyle, BorderColor, true);
		return this;
	}
}
