# FlxAsepriteUtils

Demonstrates how to utilize Aseprite art files with the built-in FlxAsepriteUtils functionality.

## Table of Contents

* [Files](#files)
* [Aseprite Export](#aseprite-export)

### Files

* `player.ase` - Aseprite file built using Character Animations from Kenney.nl (https://www.kenney.nl/assets/platformer-characters)
* `player.png` - Sprite sheet exported from Aseprite. See [Aseprite Export](#aseprite-export) for details.
* `player.json` - Atlas frame data exported from Aseprite. See [Aseprite Export](#aseprite-export) for details.

### Aseprite Export

There are two main ways of exporting sprite sheets from Aseprite:

* UI
    * See the [Official UI Docs](https://www.aseprite.org/docs/sprite-sheet/#export)
    * Requires user interaction, but allows for preview to visualize sprite sheet settings
    * Good default settings are provided when using the [Flixel Aseprite Export Plugin](https://github.com/MondayHopscotch/aseprite-scripts/releases/latest)
* CLI
    * See the [Official CLI Docs](https://www.aseprite.org/docs/cli/)
    * Useful for automated workflows