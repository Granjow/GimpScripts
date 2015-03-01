(define (argN list n) (if (> n 1) (argN (cdr list) (- n 1)) (car list) ) )

(define (script-fu-even-background-resynth
	image 
	drawable
	)
	
	(let* (
		( _selection  (gimp-image-get-selection image) )
		( _layer  (car (gimp-image-get-active-layer image)) )
		( _selBounds  (gimp-selection-bounds image) )
		( _duplicate 0 )
		( _newLayer 0 )
		)
		
		(if (= 0 (car _selBounds)) (error "Select drawing first.") )
		
		(gimp-image-undo-group-start image)
		
		; Scale the image down to speed up «heal selection»
		; Then, heal the drawing away, leaving only background behind
		(set! _duplicate (car (gimp-image-duplicate image)) )
		(gimp-image-scale _duplicate 400 400)
		(python-fu-heal-selection
			1 ; Non-interactive
			_duplicate ; Image
			(car (gimp-image-get-active-layer _duplicate) ) ; Drawable
			50 ; Sampling width
			0 ; Sample from 0 = all around
			1 ; Direction 
		)
		(gimp-selection-none _duplicate)
		
		; Gaussian blur to soften incorrectly healed background
		; 10 % of the image size is a good radius
		(plug-in-gauss-iir
			1 ;Non-interactive
			_duplicate ;Image unused
			(car (gimp-image-get-active-layer _duplicate)) ;Drawable
			40 ;Radius
			40 ;Radius x
			40 ;Radius y
		)
		
		; Add the layer back to the original image and use division
		; to fix the uneven background
		(gimp-image-scale _duplicate 
			(car (gimp-image-width image))
			(car (gimp-image-height image))
		)
		(set! _newLayer (car(gimp-layer-new-from-drawable
			(car(gimp-image-get-active-layer _duplicate))
			image
		)))
		(gimp-image-insert-layer image _newLayer 0 0)
		(gimp-layer-set-mode _newLayer DIVIDE-MODE)
		(gimp-layer-set-opacity _newLayer 88)
		
		(gimp-image-undo-group-end image)
		
		(gimp-image-undo-group-start image)
		(gimp-selection-none image)
		(gimp-image-undo-group-end image)
		
		(gimp-image-delete _duplicate)
		(gimp-displays-flush)
	)
	
)

(script-fu-register "script-fu-even-background-resynth"
	"Even Background with Resynthesize" ;Menu label
	"For images with white background and uneven lighting. \
	 Create a selection containing the whole drawing without background \
	 and run this plugin.\
	 See also: http://photo.stackexchange.com/a/60048/4149"
	"Simon A. Eugster" ;Author
	"Copyright (c) 2015 Simon A. Eugster <simon.eu@gmail.com>" ;(C)
	"2015" ;Date
	"" ; Image type
	SF-IMAGE "image" 0
	SF-DRAWABLE "drawable" 0
)
(script-fu-menu-register "script-fu-even-background-resynth" "<Image>/Filters")
