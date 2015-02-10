(define (argN list n) (if (> n 1) (argN (cdr list) (- n 1)) (car list) ) )

(define (script-fu-even-background 
	image 
	drawable
	)
	
	(let* (
		( _selection  (gimp-image-get-selection image) )
		( _layer  (car (gimp-image-get-active-layer image)) )
		( _newLayer 0 )
		( _tiledLayer 0 )
		( _selBounds  (gimp-selection-bounds image) )
		( _selW  (- (argN _selBounds 4) (argN _selBounds 2)) )
		( _selH  (- (argN _selBounds 5) (argN _selBounds 3)) )
		( _img  0 )
		( _tiled  0 )
		( _ret  0 )
		)
		
		(gimp-image-undo-group-start image)
		
		(gimp-message-set-handler 0)
		(if (= 0 (car _selBounds)) (error "Select a rectangle first.") )
		
		(gimp-message-set-handler 1) ;messages to console
		(gimp-message "Script starting.")
		
		(set! _selBounds (gimp-selection-bounds image) ) ;(isSel,x1,y1,x2,y2)
		
		(set! _img (car(gimp-image-new
					_selW 
					_selH
					0 )) )
		(gimp-message (string-append "New image ID: " (number->string _img)) )
		
		(gimp-message (string-append "Copying layer " (number->string _layer)) )
		(set! _newLayer (car(gimp-layer-new-from-drawable _layer _img)) )
		(gimp-image-insert-layer _img _newLayer 0 0)
		(gimp-layer-set-offsets _newLayer (- (argN _selBounds 2)) (- (argN _selBounds 3)) )
		(gimp-layer-resize-to-image-size _newLayer)
		
		
		(set! _ret (plug-in-tile 
			1 ;noninteractive
			0
			_newLayer
			(car (gimp-image-width image))
			(car (gimp-image-height image))
			TRUE ))
			
		(set! _tiled (car _ret) )
		
		(plug-in-gauss
			1 ;noninteractive
			_tiled
			(car (gimp-image-get-active-layer _tiled))
			128
			64
			0 ;IIR 
		)
			
		(set! _tiledLayer (car(gimp-layer-new-from-drawable 
			(car(gimp-image-get-active-layer _tiled))
			image )) )
			
		(gimp-image-insert-layer image _tiledLayer 0 0)
		(gimp-layer-set-mode _tiledLayer DIVIDE-MODE)
		(gimp-layer-set-opacity _tiledLayer 88)
		
		
		
		(gimp-image-delete _img)
		(gimp-image-delete _tiled)
		
		(gimp-selection-none image)
		
		(gimp-image-undo-group-end image)
		
		(gimp-displays-flush)
	)
	
)

(script-fu-register "script-fu-even-background"
	"Even Background" ;Menu label
	"For images with white background and a vertical gradient\
	 from uneven lighting. Removes the gradient (i.e. evens lighting).\
	 Select a rectangle with background only, reaching from top to bottom, first."
	"Simon A. Eugster" ;Author
	"Copyright (c) 2015 Simon A. Eugster <simon.eu@gmail.com>" ;(C)
	"2015" ;Date
	"" ; Image type
	SF-IMAGE "image" 0
	SF-DRAWABLE "drawable" 0
)
(script-fu-menu-register "script-fu-even-background" "<Image>/Filters")
