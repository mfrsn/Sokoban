;==========================================================
; PRAM 2011, Senast ändrad 2011-05-03
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: main-menu-button.scm
; Beskrivning: Definierar en enkel klass för menyknapparna
;==========================================================

(define menu-button%
  (class object%
    
    (init-field label
                image
                mouseover-image)
    
    (field (mouseover? #f)
           (width #f)
           (height #f)
           (position #f))
    
    (set! width (send image get-width))
    (set! height (send image get-height))
    
    (define/public (set-mouseover! pred)
      (set! mouseover? pred))
    
    (define/public (set-position! new-position)
      (set! position new-position))
    
    (define/public (get-mouseover)
      mouseover?)
    
    (define/public (get-label)
      label)
    
    (define/public (get-image)
      (if mouseover?
          mouseover-image
          image))
    
    (define/public (get-position)
      position)
    
    (define/public (get-width)
      width)
    
    (define/public (get-height)
      height)
    
    (super-new)))