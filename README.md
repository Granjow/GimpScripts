
## Even Background

Please see [this question on Stackexchange](http://photo.stackexchange.com/questions/60001/how-to-fix-uneven-gradient-lighting-on-a-canvas-with-white-background) to understand the problem.

**Usage:** Create a selection rectangle of full image height and any width, but without any parts of the drawing inside, then run the script.

## Even Background with Resynthesize

This script requires the [Resynthesizer plugin](https://github.com/bootchk/resynthesizer). It can not only tackle linear backgrounds, but generally uneven ones, and was created based on [this Stack answer](http://photo.stackexchange.com/a/60048/4149).

**Usage:** Create a selection that covers the drawing without background, then run the plugin. A fast way to mask the object is:

1.  Enable Quick Mask (Shift+Q)
2.  Use the pencil tool (N) to change the mask with white/black colour
3.  Disable the Quick Mask (Shift+Q) to get a selection
