package;

@:build(flixel.system.FlxAssets.buildFileReferences("assets", true, null, "*.mp3|*.ogg"))
class AssetPaths
{
	public static final sounds = SoundPaths;
}

// remove extension of sounds
@:build(flixel.system.FlxAssets.buildFileReferences("assets/sounds", true, #if web "*.mp3" #else "*.ogg" #end, null,
    function (name)
	{
		return name.toLowerCase()
			.split("assets/sounds/").join("")
			.split("/").join("_")
			.split("-").join("_")
			.split(" ").join("_")
			.split(".")[0];
	}
))
class SoundPaths {}
