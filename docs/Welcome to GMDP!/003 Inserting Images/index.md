[i] Images are only supported after you download GMDP and select a file to write to in your file system. You cannot use images without first selecting a file. [/i]

An image can be inserted with the syntax
[code]
![image text](relative/image/path)
[/code]

The path of the image depends on where the currently used markdown file is being written to. If it's being written to a directory named "foo", which also contains the images "bar.png" and a similarly named image in a subfolder named "sub", you can use them in your presentation using
[code]
![Foo image](bar.png)
![Subdirectory Image](sub/bar.png)
[/code]
