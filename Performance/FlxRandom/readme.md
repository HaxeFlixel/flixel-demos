# FlxRandom Demo

This is simply a collection of functions to test the updated `FlxRandom` class in HaxeFlixel.

The buttons on the right side of the display can be used to run a series of tests relating to each function of `FlxRandom`. Most of the tests will run the same function many times for benchmarking purposes. Others will compare the new class to the previous `FlxRandom` (which is stored in the source folder as `OldFlxRandom`), the new `FlxRandom` without `inline`, or pure `Math.random()`.

Some tests may take some time to run, please be patient. Note that the 15-second script timeout has been overridden in `Project.xml` and set to 60 seconds.

# Benchmarking Data

## Flash

## 10 Million Integers
* New `FlxRandom`: 266ms
* New `FlxRandom` without `inline`: 1591ms
* Old `FlxRandom`: 951ms
* `Math.random()`: 999ms

## 10 Million Floats
* New `FlxRandom`: 296ms
* New `FlxRandom` without `inline`: 1701ms
* Old `FlxRandom`: 546ms
* `Math.random()`: 936ms

## Windows, Native

## 10 Million Integers
* New `FlxRandom`: 129ms
* New `FlxRandom` without `inline`: 128ms
* Old `FlxRandom`: 605ms
* `Math.random()`: 1058ms

## 10 Million Floats
* New `FlxRandom`: 183ms
* New `FlxRandom` without `inline`: 182ms
* Old `FlxRandom`: 413ms
* `Math.random()`: 967ms

FlxRandom demo was created by [Steve Richey](https://github.com/steverichey) for [HaxeFlixel](https://github.com/HaxeFlixel).

This project, and HaxeFlixel itself, are shared under an [MIT License](http://opensource.org/licenses/MIT). See `license.md` for details.