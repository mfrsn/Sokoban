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
     (canvas-width *game-canvas-width*)
     (canvas-height *game-canvas-height*)
     (total-width (+ canvas-width *game-sidebar-width*))
     (menu-width 260)
     (button-width 180)
     (button-height 40)
     (menu-position (calculate-menu-position))
    
     ; Palett
     (white (make-object color% 255 255 255))
     (red (make-object color% 255 0 0))
     
     ; Verktyg
     (white-brush (make-object brush% white 'solid))
     (red-brush (make-object brush% red 'solid))
     
     ; Bilder
     (background-png (make-object bitmap% "data/textures/background.png"))
     (menu-background-png (make-object bitmap% "data/mainmenu/menu-background.png" 'png/mask))
     (menu-background-mask-png (send menu-background-png get-loaded-mask))
     (new-game-png (make-object bitmap% "data/mainmenu/new-game.png" 'png/mask))
     (new-game-mouseover-png (make-object bitmap% "data/mainmenu/new-game-mouseover.png" 'png/mask))
     (highscore-png (make-object bitmap% "data/mainmenu/highscore.png" 'png/mask))
     (highscore-mouseover-png (make-object bitmap% "data/mainmenu/highscore-mouseover.png" 'png/mask))
     
     ; Knappar
     (new-game-button (new menu-button%
                           [label 'new-game]
                           [position (calculate-button-position 0)]
                           [image new-game-png]
                           [mouseover-image new-game-mouseover-png]))
     
     (highscore-button (new menu-button%
                            [label 'highscore]
                            [position (calculate-button-position 1)]
                            [image highscore-png]
                            [mouseover-image highscore-mouseover-png]))
     
     (button-list (list new-game-button highscore-button)))
    
    (define/private (calculate-button-position button-number)
      (make-position (- (/ total-width 2) (/ button-width 2)) (+ 170 (* (+ button-height 10) button-number))))
    
    (define/private (calculate-menu-position)
      (let ((top-button-position (calculate-button-position 0)))
        (make-position (- (get-x-position top-button-position)
                          (/ (- menu-width button-width) 2))
                       (- (get-y-position top-button-position)
                          47))))
     
    (define/private (fill-canvas)
      (send dc draw-bitmap background-png 0 0))
    
    (define/private (draw-masked-png png mask position)
      (send dc draw-bitmap png (get-x-position position) (get-y-position position) 'solid white mask))
    
    (define/private (draw-background)
      (fill-canvas)
      (draw-masked-png menu-background-png menu-background-mask-png menu-position))
    
    (define/private (draw-buttons)
      (define (help button-list)
        (if (null? button-list)
            (void)
            (let ((image (send (car button-list) get-image)))
              (draw-masked-png image (send image get-loaded-mask) (send (car button-list) get-position))
              (help (cdr button-list)))))
      (help button-list))        
    
    (define/private (refresh)
      (draw-background)
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
                 (start-new-game!)
                 (send new-game-button set-mouseover! #f))
                (else (void)))))
      
      (help button-list)
      
      (if (eq? event-type 'left-down)
          (let ((mouseover-button (get-mouseover-button)))
            (if (not mouseover-button)
                (void)
                (handle-button-press mouseover-button)))
          (void)))
      
    (define/public (draw)
      ;(send dc suspend-flush)
      (refresh)
      ;(send dc flush)
      ;(send dc resume-flush))
      )
    (super-new)))
               
               
      