(define (process-and-add-layer new-image image-path offset-x offset-y)
  (let*
    (
      ;; Open the image
      (image (car (gimp-file-load RUN-NONINTERACTIVE image-path image-path)))
      (layer (car (gimp-image-get-active-layer image)))

      ;; Get image dimensions
      (width (car (gimp-image-width image)))
      (height (car (gimp-image-height image)))

      ;; Rotate the image if it is portrait
      (rotated
        (if (> height width)
          (gimp-image-rotate image 1) ; Rotates the image 90 degrees clockwise
        )
      )

      ;; Only scale if the width is greater than 814px
      (scaled
        (if (> width 814)
          (gimp-image-scale image 814 (/ (* 814 height) width))
        )
      )

      ;; Update the layer reference after potential transformations
      (layer (car (gimp-image-get-active-layer image)))
    )

    ;; Insert the layer into the new image
    (gimp-image-insert-layer new-image layer 0 -1)
    (gimp-layer-set-offsets layer offset-x offset-y)

    ;; Remove the temporary image
    (gimp-image-delete image)
  )
)

;; Main script function
(define (script-func image1-path image2-path image3-path image4-path)
  ;; Create a new image with the specified size
  (let* ((new-image (car (gimp-image-new 1850 1256 0)))
         (new-layer (car (gimp-layer-new new-image 1850 1256 0 "Composite" 100 NORMAL-MODE))))
    ;; Insert the new layer into the new image
    (gimp-image-insert-layer new-image new-layer 0 -1)

    ;; Start a GIMP undo group
    (gimp-undo-push-group-start new-image)

    ;; Process each image and add to the composite image
    (process-and-add-layer new-image image1-path 91 63)
    (process-and-add-layer new-image image2-path 91 651)
    (process-and-add-layer new-image image3-path 953 63)
    (process-and-add-layer new-image image4-path 953 651)

    ;; End the GIMP undo group
    (gimp-undo-push-group-end new-image)

    ;; Display the new image
    (gimp-display-new new-image)
  )
)

;; Register the script with GIMP
(script-fu-register
  "script-func"                                   ;; Function name
  "Combine 4 Images"                              ;; Menu label
  "Takes 4 images, processes, and combines them." ;; Description
  "Your Name"                                     ;; Author
  "Your Name"                                     ;; Copyright
  "2023"                                          ;; Date
  ""                                              ;; Image type
  SF-STRING "Image 1" ""
  SF-STRING "Image 2" ""
  SF-STRING "Image 3" ""
  SF-STRING "Image 4" ""
)

;; Add the script to the menu in GIMP
(script-fu-menu-register "script-func" "<Image>/Filters")
