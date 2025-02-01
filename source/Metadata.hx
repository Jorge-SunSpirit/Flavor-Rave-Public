package;

typedef Metadata =
{
	var song:MetadataSong;
	var dialogue:MetadataDialogue;
	var control:MetadataControl;
	var freeplay:MetadataFreeplay;
}

typedef MetadataSong =
{
	var name:String;
	var artist:String;
	var charter:String;
	var pauseartist:String;
	var titleCardStep:Null<Int>;
	var extraCharacter:Array<Bool>;//0 is if they exist, 1 is if they are a player
	var pauseArt:Null<String>;
}

typedef MetadataDialogue =
{
	var introDialogue:String;
	var endDialogue:String;
}

typedef MetadataControl =
{
	var freeplayDialogue:Null<Bool>;
	var happyEnding:Null<Bool>;
	var hasLyrics:Null<Bool>;
	var disableHealth:Null<Bool>;
	var noteChangesHealth:Null<Bool>;
	var noteChangesStrum:Null<Bool>;
	var noteChangesRating:Null<Bool>;
}

typedef MetadataFreeplay =
{
	var characters:Null<Array<String>>;
	var stage:Null<String>;
	var isOnePlayer:Null<Bool>;
}
