(define (scale-and-rotate-current-image image drawable)
  (let* (
          ;; Get image dimensions
          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))

          ;; Rotate the image if it is portrait
          (rotated
            (if (> height width)
              (gimp-image-rotate image 0)
              )
            )

          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))

          )

    ;; Scale the image to 814px width while maintaining the aspect ratio
    (gimp-image-scale image 814 (/ (* 814 height) width))

    ;; Update the display
    (gimp-displays-flush)
    )
  )

;; Register the script with GIMP
(script-fu-register
  "scale-and-rotate-current-image"              ;; Function name
  "_Scale and Rotate Current Image"            ;; Menu label
  "Scales and rotates the current image."      ;; Description
  "Your Name"                                  ;; Author
  "Your Name"                                  ;; Copyright
  "2023"                                       ;; Date
  "RGB*, GRAY*"                                ;; Image types where the script can be run
  SF-IMAGE "Image" 0                           ;; The currently open image
  SF-DRAWABLE "Drawable" 0                     ;; The drawable of the open image (usually the active layer)
  )

;; Add the script to the image window's menu in GIMP
(script-fu-menu-register "scale-and-rotate-current-image" "<Image>/MyScripts")
