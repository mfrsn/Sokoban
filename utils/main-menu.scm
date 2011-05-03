;====================================================================
; PRAM 2011
; Senaste ändring: Implementerad 2011-05-03
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: main-menu.scm
; Beskrivning: Definierar uppstartsmenyn.
;====================================================================

(define main-menu%
  (class object%
    
    (init-field canvas)
    
    (field
     (dc (send canvas get-dc))
     (canvas-width (send canvas get-width))
     (canvas-height (send canvas get-height))
     (button-width 100)
     (button-height 20)
    
     ; Palett
     (white (make-object color% 255 255 255))
     (red (make-object color% 255 0 0))
     
     ; Verktyg
     (white-brush (make-object brush% white 'solid))
     (red-brush (make-object brush% red 'solid))
     
     ; Bilder
     (background-png (make-object bitmap% "data/textures/background.png"))
     (new-game-png (make-object bitmap% "data/mainmenu/new-game.png"))
     (new-game-mouseover-png (make-object bitmap% "data/mainmenu/new-game-mouseover.png"))
     
     ; Knappar
     (new-game-button (new menu-button%
                           [label 'new-game]
                           [position (make-position 200 200)]
                           [image new-game-png]
                           [mouseover-image new-game-mouseover-png]))
     
     (button-list (list new-game-button)))
     
    (define/private (fill-canvas)
      (send dc draw-bitmap background-png 0 0))
    
    (define/private (draw-buttons)
      (define (help button-list)
        (let ((position (send (car button-list) get-position)))
          (send dc draw-bitmap (send (car button-list) get-image) (get-x-position position) (get-y-position position))))
      (help button-list))        
    
    (define/private (refresh)
      (fill-canvas)
      (draw-buttons))
    
    (define/private (get-mouseover-button)
      (define (help button-list)
        (cond ((null? button-list) #f)
              ((send (car button-list) get-mouseover)
               (car button-list))
              (else (help (cdr button-list)))))
      (help button-list))
    
    (define/public (handle-mouse-event mouse-x mouse-y event-type)
      ; Hantera mouseover
      (define (help button-list)
        (if (null? button-list)
            (void)
        (let* ((position (send (car button-list) get-position)) 
               (button-x (get-x-position position))
               (button-y (get-y-position position)))
          
          (if (and (>= mouse-x button-x)
                   (<= mouse-x (+ button-x button-width))
                   (>= mouse-y button-y)
                   (<= mouse-y (+ button-y button-height)))
              (send (car button-list) set-mouseover! #t)
              (send (car button-list) set-mouseover! #f))
        (help (cdr button-list)))))
      
      ; Hantera knapptryckning
      (define (handle-button-press button)
        (let ((button-label (send button get-label)))
          (cond ((eq? button-label 'new-game)
                 (start-new-game!))
                (else (void)))))
      
      (help button-list)
      
      (if (eq? event-type 'left-down)
          (let ((mouseover-button (get-mouseover-button)))
            (if (not mouseover-button)
                (void)
                (handle-button-press mouseover-button)))
          (void)))
      
    (define/public (draw)
      (refresh))
    
    (super-new)))
               
               
      