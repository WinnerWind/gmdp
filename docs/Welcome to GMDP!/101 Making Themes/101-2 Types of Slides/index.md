GMDP will try to detect what "type" a slide is by seeing whether the given slide has a
[ul]
Heading
Subheading
Main Content
Images (and also how many!)
Footer
[/ul]

Because a slide can have some of these, one of these, or all of these, GMDP provides an internal name for each and every type of slide. This name is determined by the above variables, in that order.

[ul]
If a slide has only a Heading, the slide name is just "heading"
If a slide has only a subheading, the slide name is just "subheading"
If a slide only has content and nothing else, the slide name is just "content"
If a slide only has images and nothing else, the slide name is "<number_of_images>_image", where <number_of_images> is replaced with the number of images in the slide
If a slide only has a footer, the slide name is just "footer"
[/ul]

Since a slide can have multiple of these, names are generated programatically.
[ul]
If a slide has a heading and a subheading, the name is "heading_subheading"
If a slide has a heading, subheading, and content, the name is "heading_subheading_content"
If a slide has 5 images and nothing else, the name is "5_image"
If a slide has content and a footer, the name is "content_footer"
[/ul]

This way, you can see that the canonical order in which scenes are named is:
[code]
heading_subheading_content_footer_<image-count>_image
[/code]

Refer to official scenes and the source code to see examples.
