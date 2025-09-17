A theme usually follows a folder structure that looks like this:
[code]
templates/mytheme
L meta.ini
L content.tscn
L heading_content.tscn
L title.tscn
[/code]

The meta.ini contains a list of scenes which tell GMDP which scenes to use for which type of slide.

[ol]
Your first step should be to get a copy of [url=https://github.com/WinnerWind/gmdp]GMDP's source code[/url]. You can look up "cloning github repos" to get an idea of how to do so.
After that, open the project in [url=https://godotengine.org]Godot[/url] create a folder in the newly formed copy of the repository in the templates folder. 
Create a meta.ini file.
Create a metadata section in the meta.ini file. If you don't know how to do this, the bottom of this document contains a sample meta.ini file.
In the metadata section, add keys for "name", "author", "designed_by", and "url". These all tell users who designed the theme. [img]res://docs/Welcome to GMDP!/101 - Making Themes/101-1 - Creating a Basic Theme/metadata.png[/img]
Create a section called "scenes"
This section contains key-value pairs which tell GMDP which scenes to use for which type of slide. After reading through "Types of Slides", you define each key to be the internal name of the slide type, and the value to be the relative path to the scene. 
Each slide scene must have the root node to have the slide.gd script (located in res://scripts/slides/slide.gd) or it must have a script that extends slide.gd. After that, you point the exported nodes (Heading Label, Subheading Label etc.) at their respective nodes. 
Also note that each slide scene's root MUST have its size set to 1920x1080 in order to render properly.
In the end, your theme NEEDS to have styles for "heading", "heading_content", "content" and "heading_subtitle_content" in order to be recognised as a valid theme.
[/ol]

A sample (incomplete!) metadata file looks like:
[code]
[metadata]
name="Gummy Revived"
author="WinnerWind"
designed_by="WinnerWind"
url="https://winnerwind.in"

[scenes]
heading="heading.tscn"
heading_content="heading_content.tscn"
content="content.tscn"
heading_subtitle_content="heading_subtitle_content.tscn"
[/code]
