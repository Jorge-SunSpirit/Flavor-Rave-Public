package;

typedef Metadata =
{
	var song:MetadataSong;
	var dialogue:MetadataDialogue;
	var control:MetadataControl;
}

typedef MetadataSong =
{
	var name:String;
	var artist:String;
	var charter:String;
	var titleCardStep:Null<Int>;
	var extraCharacter:Array<Bool>;//0 is if they exist, 1 is if they are a player
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
}
