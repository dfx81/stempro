# stempro

## Overview

STEMPro is an educational game for STEM subjects created for KMK. The game is developed using Godot Engine 3.5.3.

Godot Engine is chosen as the engine because it is a free and open source game-engine. There is no licensing fees and it's also a lightweight engine that uses very few system resources, allowing
the game to run on low-end devices. The engine is also cross-platform, allowing the game to be developed once and exported to any platforms such as desktops, mobile, and web.

## Gameplay

STEMPro's gameplay is based on a pen-and-paper game called [Bulls and cows](https://en.wikipedia.org/wiki/Bulls_and_cows) as well as [Wordle](https://www.nytimes.com/games/wordle/index.html).
In each level, the player will be presented with a question and a blank space indicating the amount of letters in the answer. The player must guess the word correctly in order to clear the level.
After each incorrect guesses, the player will be given some hints based on the following criteria:

- If a letter in the player's guess is in the answer and it's in the correct position, the correct letters count will increase by 1
- If a letter in the player's guess is in the answer but it's in the wrong position, the inaccurate letters count will increase by 1
- If a letter in the player's guess is not in the answer, the wrong letters count will increase by 1

Additionally:
- If the answer have duplicate letters (eg. ELECTRON have 2 Es), each repeating letters will be validated separately.
- If your guess contains extra letters past the correct amount in the answer (eg. guessing HEED against HEAD, note the extra Es), any additional letters past the correct amount will be counted as wrong.

The hints will be updated after each guesses in order to guide the player in finding the correct answer. Additionally, there is also keyboard hints where the wrong letters will be indicated on the
keyboard and disabled, increasing the odds for finding the correct answer.

Once the player found the correct answer, the next level will be unlocked for the selected subject.

## Progression

All three subjects are unlocked from the start, but only level 1 will be available for each subject. The player's progression in STEMPro is tracked separately for each subject so the player can
progress at different rates for each subject. Additionally, once the player have completed all levels for each subject, the player will unlock another mode called Daily Shuffle.

Daily Shuffle is an unlockable mode added to increase the replayability of the game. The mode will randomly select 10 different levels from all subjects each day. The player can progress through
each the levels until the player cleared all 10 levels. The levels will reset daily, and every player that plays the game will experience the same set of levels. This mode is also a bit more difficult
compared to the normal mode as the keyboard hints are not available.

## Implementation

### Questions

The questions in the game are implemented as three different [two-dimensional array](https://github.com/dfx81/stempro/blob/main/scripts/Globals.gd#L6), one for each subject. The structure of the each question are as follows:
```
[
  ["This is the question", "ANSWER"],
  ...
]
```
The string on the first index is the question to be shown to the player, while the string on the second index is the answer that the player need to guess.

Additionally, the questions came in three different variants: [Text-based](https://github.com/dfx81/stempro/blob/main/scripts/Globals.gd#L40), [Image-based](https://github.com/dfx81/stempro/blob/main/scripts/Globals.gd#L34), and [Mixed](https://github.com/dfx81/stempro/blob/main/scripts/Globals.gd#L45).
```
[
  ["This is a text-based question", "ANSWER"],
  ["res://PATH-TO-IMAGE", "ANSWER"],
  ["res://PATH-TO-IMAGE", "ANSWER", "This is the question to be displayed alongside the image."],
  ...
]
```
Text-based questions only displays the question as a text to the user, while the image-based question displays an image instead. Mixed questions will display both.

Furthermore, some there are also some [multiple-choice questions](https://github.com/dfx81/stempro/blob/main/scripts/Globals.gd#L68) available in the game, currently exclusive to the computer science subject. This is because
the format of the question is unsuitable for the normal gameplay of the game. The format for these kind of questions are as follows:
```
[
  ["This is a multiple-choice question", "ANSWER", "Option B", "Option C", "Option D"],
  ...
]
```
Despite the limited structure of the multiple-choice questions, there are still some variety to the questions as the answer button placements are randomized in-game. So the player cannot memorize the answer to the questions using the button placements.

### Saves

The game autosaves the player progress [after clearing each level](https://github.com/dfx81/stempro/blob/main/scripts/WordGuessScript.gd#L174). The save file is structured as follows:
```
data.save:
0b00000000         = 1 byte representing the progress of biology levels
0b00000000         = 1 byte representing the progress of physic levels
0b00000000         = 1 byte representing the progress of compsci levels
0b00000000         = 1 byte representing the progress of Daily Shuffle levels
0x0000000000000000 = 8 byte representing the seed for the Daily Shuffle level set
```
The save data is stored in the user://data.save file, the location of which is different according to [where the game is played on](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html#accessing-persistent-user-data-user).

## Assets

All assets used in the game (music, sound effects, images, art, fonts) are free royalty-free assets.

## Build Instructions

In order to compile the game, you need to download [Godot Engine](https://godotengine.org/) first.
Then download the [source files](https://github.com/dfx81/stempro/archive/refs/heads/main.zip) in this [repository](https://github.com/dfx81/stempro).
Then, load the project in Godot and simply export the project to whichever platforms you need. Further instructions for exporting can be found [here](https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html).
