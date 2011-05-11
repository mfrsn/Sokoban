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
    
    (init-field canvas
                highscore-client)
    
    (field
     
     ; Bilder
     (background-png (make-object bitmap% "data/textures/background.png"))
     (main-menu-background-png (make-object bitmap% "data/mainmenu/menu-background.png" 'png/mask))
     (menu-background-mask-png (send main-menu-background-png get-loaded-mask))
     (new-game-png (make-object bitmap% "data/mainmenu/new-game.png" 'png/mask))
     (new-game-mouseover-png (make-object bitmap% "data/mainmenu/new-game-mouseover.png" 'png/mask))
     (highscore-background-png (make-object bitmap% "data/mainmenu/highscore-background.png" 'png/mask))
     (highscore-background-mask-png (send highscore-background-png get-loaded-mask))
     (highscore-png (make-object bitmap% "data/mainmenu/highscore.png" 'png/mask))
     (highscore-mouseover-png (make-object bitmap% "data/mainmenu/highscore-mouseover.png" 'png/mask))
     (highscore-next-level-png (make-object bitmap% "data/mainmenu/highscore-next-level.png" 'png/mask))
     (highscore-next-level-mouseover-png (make-object bitmap% "data/mainmenu/highscore-next-level-mouseover.png" 'png/mask))
     (highscore-previous-level-png (make-object bitmap% "data/mainmenu/highscore-previous-level.png" 'png/mask))
     (highscore-previous-level-mouseover-png (make-object bitmap% "data/mainmenu/highscore-previous-level-mouseover.png" 'png/mask))
     
     ; Funktionella variabler
     (dc (send canvas get-dc))
     (canvas-width *game-canvas-width*)
     (canvas-height *game-canvas-height*)
     (total-width (+ canvas-width *game-sidebar-width*))
     (main-menu-position (calculate-menu-background-position 'main-menu))
     (highscore-menu-position (calculate-menu-background-position 'highscore-menu))
     (highscore-level 0)
     (highscore-title-x-offset 170)
     (highscore-title-y-offset 20)
     (highscore-button-center-x-offset 20)
     (highscore-button-bottom-y-offset 20)
     (highscore-entry-spacing 20)
     (highscore-score-offset 260)
     (highscore-name-offset 100)
     (highscore-x-offset 40)
     (highscore-y-offset 20)
     (highscore-header-y-offset 25)
     (main-menu-button-y-offset 30)
     (main-menu-button-spacing 10)
     (number-of-highscore-entrys 5)
     (on-main-menu? #t)
     (highscore-list '())
         
     ; Palett
     (white (make-object color% 255 255 255))
     (red (make-object color% 255 0 0))
     (colour-black (make-object color% 0 0 0))
     
     ; Verktyg
     (white-brush (make-object brush% white 'solid))
     (red-brush (make-object brush% red 'solid))
     (font (send the-font-list find-or-create-font 16 "Britannic Bold" 'default 'normal 'normal))
     
     ; Knappar
     (new-game-button (new menu-button%
                           [label 'new-game]
                           [image new-game-png]
                           [mouseover-image new-game-mouseover-png]))
     
     (highscore-button (new menu-button%
                            [label 'highscore]
                            [image highscore-png]
                            [mouseover-image highscore-mouseover-png]))
     
     (highscore-next-level-button (new menu-button%
                                       [label 'next-level]
                                       [image highscore-next-level-png]
                                       [mouseover-image highscore-next-level-mouseover-png]))
     
     (highscore-previous-level-button (new menu-button%
                                           [label 'previous-level]
                                           [image highscore-previous-level-png]
                                           [mouseover-image highscore-previous-level-mouseover-png]))
     
     (button-list-main-menu (list new-game-button highscore-button))
     (button-list-highscore-menu (list highscore-next-level-button highscore-previous-level-button)))
    
    ; Nödvändiga exekveringar
    (send dc set-text-foreground colour-black)
    (send dc set-font font)
    (set-button-positions!)
    
    ; Sätt knapparnas positioner
    (define/private (set-button-positions!)
      (let ((button-counter 0))
        (define (help button-list identifier)
          (if (null? button-list)
              (void)
              (let ((button (car button-list)))
                (cond ((eq? identifier 'main-menu-buttons)
                       (send button set-position! (calculate-main-menu-button-position button
                                                                                       button-counter))
                       (set! button-counter (+ button-counter 1)))
                      ((eq? identifier 'highscore-menu-buttons)
                       (send button set-position! (calculate-highscore-menu-button-position button)))
                      (else (error "Unknown identifier: " identifier)))
                (help (cdr button-list) identifier))))
        (help button-list-main-menu 'main-menu-buttons)
        (help button-list-highscore-menu 'highscore-menu-buttons)))
    
    ; Huvudmenyns knapppositioner
    (define/private (calculate-main-menu-button-position button button-number)
      (let ((menu-y-position (get-y-position main-menu-position)))
        (make-position (- (/ total-width 2) (/ (send button get-width) 2))
                       (+ menu-y-position
                          main-menu-button-y-offset
                          (* (+ (send button get-height) 
                                main-menu-button-spacing)
                             button-number)))))
    
    ; Highscoremenyns knapppositioner
    (define/private (calculate-highscore-menu-button-position button)
      (let ((label (send button get-label)))
        (cond ((eq? label 'next-level)
               (make-position (+ (/ total-width 2) highscore-button-center-x-offset)
                              (- (+ (get-y-position highscore-menu-position)
                                    (send highscore-background-png get-height))
                                 (send button get-height)
                                 highscore-button-bottom-y-offset)))
              ((eq? label 'previous-level)
               (make-position (- (/ total-width 2)
                                 highscore-button-center-x-offset
                                 (send button get-width))
                              (- (+ (get-y-position highscore-menu-position)
                                    (send highscore-background-png get-height))
                                 (send button get-height)
                                 highscore-button-bottom-y-offset)))
              (else (error "Invalid label: " label)))))
    
    ; Menypositioner
    (define/private (calculate-menu-background-position identifier)
      (let ((image-width 0)
            (image-height 0))
        (cond ((eq? identifier 'main-menu)
               (set! image-width (send main-menu-background-png get-width))
               (set! image-height (send main-menu-background-png get-height)))
              ((eq? identifier 'highscore-menu)
               (set! image-width (send highscore-background-png get-width))
               (set! image-height (send highscore-background-png get-height)))
              (else (error "Unknown identifier in: " identifier)))
        (make-position (- (/ total-width 2) (/ image-width 2))
                       (- (/ canvas-height 2) (/ image-height 2)))))
    
    
    (define/private (fill-canvas)
      (send dc draw-bitmap background-png 0 0))
    
    (define/private (draw-masked-png png mask position)
      (send dc draw-bitmap png (get-x-position position) (get-y-position position) 'solid white mask))
    
    (define/private (draw-background-main-menu)
      (fill-canvas)
      (draw-masked-png main-menu-background-png menu-background-mask-png main-menu-position))
    
    (define/private (draw-background-highscore-menu)
      (fill-canvas)
      (draw-masked-png highscore-background-png highscore-background-mask-png highscore-menu-position))
    
    (define/private (draw-buttons button-list)
      (define (help button-list)
        (if (null? button-list)
            (void)
            (let ((image (send (car button-list) get-image)))
              (draw-masked-png image (send image get-loaded-mask) (send (car button-list) get-position))
              (help (cdr button-list)))))
      (help button-list))        
    
    (define/private (refresh)
      (if on-main-menu?
          (draw-main-menu)
          (draw-highscore)))
    
    (define/private (draw-main-menu)
      (draw-background-main-menu)
      (draw-buttons button-list-main-menu))
    
    (define/private (draw-highscore)
      (draw-background-highscore-menu)
      (draw-buttons button-list-highscore-menu)
      (draw-highscore-table))
     
    (define/private (update-highscore-list)
      (let ((server-highscore-list (send highscore-client
                                        download-highscore
                                        highscore-level
                                        number-of-highscore-entrys)))
        (if (not (equal? highscore-list server-highscore-list))
            (set! highscore-list server-highscore-list)
            (void))))
    
    (define/private (draw-highscore-table)
      (let ((entry-index 0))
        
        (define (help highscore-list)
          (if (null? highscore-list)
              (no-entries-found)
              (let ((cdr-list (cdr highscore-list)))
                (print-highscore-entry (car highscore-list) entry-index)
                (set! entry-index (+ entry-index 1))
                (if (null? cdr-list)
                    (void)
                    (help cdr-list)))))
        
        (define (no-entries-found)
          (send dc draw-text "No entries found!" (- (/ total-width 2) 75) (- (/ canvas-height 2) 20)))
        
        (define (calculate-entry-draw-position entry-type entry-index)
          (cond ((eq? entry-type 'index)
                 (make-position (+ (get-x-position highscore-menu-position)
                                   highscore-x-offset)
                                (+ (get-y-position highscore-menu-position)
                                   highscore-y-offset
                                   highscore-header-y-offset
                                   highscore-title-y-offset
                                   (* highscore-entry-spacing entry-index))))
                ((eq? entry-type 'name)
                 (make-position (+ (get-x-position highscore-menu-position)
                                   highscore-x-offset
                                   highscore-name-offset)
                                (+ (get-y-position highscore-menu-position)
                                   highscore-y-offset 
                                   highscore-header-y-offset
                                   highscore-title-y-offset
                                   (* highscore-entry-spacing entry-index))))
                ((eq? entry-type 'score)
                 (make-position (+ (get-x-position highscore-menu-position)
                                   highscore-x-offset
                                   highscore-score-offset)
                                (+ (get-y-position highscore-menu-position)
                                   highscore-y-offset
                                   highscore-header-y-offset
                                   highscore-title-y-offset
                                   (* highscore-entry-spacing entry-index))))
                (else (void))))
        
        (define (print-highscore-entry entry entry-index)
          (let ((index-position (calculate-entry-draw-position 'index entry-index))
                (name-position (calculate-entry-draw-position 'name entry-index))
                (score-position (calculate-entry-draw-position 'score entry-index)))
            
            (send dc draw-text (string-append (number->string (+ entry-index 1)) ".") (get-x-position index-position) (get-y-position index-position))
            (send dc draw-text (car entry) (get-x-position name-position) (get-y-position name-position))
            (send dc draw-text (number->string (cadr entry)) (get-x-position score-position) (get-y-position score-position))))
        
        (define (draw-titles)
          (let ((y-position (+ (get-y-position highscore-menu-position) highscore-header-y-offset highscore-title-y-offset)))
            (send dc draw-text
                  (string-append "Level " (number->string (+ highscore-level 1)))
                  (+ (get-x-position highscore-menu-position)
                     highscore-title-x-offset)
                  (+ (get-y-position highscore-menu-position)
                     highscore-title-y-offset))
            (send dc draw-text "Rank:" (+ (get-x-position highscore-menu-position) highscore-x-offset) y-position)
            (send dc draw-text "Name:" (get-x-position (calculate-entry-draw-position 'name 0)) y-position)
            (send dc draw-text "Score:" (get-x-position (calculate-entry-draw-position 'score 0)) y-position)))
        
        (draw-titles)
        (help highscore-list)))
            
    
    (define/private (get-mouseover-button)
      (define (help button-list)
        (cond ((null? button-list) #f)
              ((send (car button-list) get-mouseover)
               (car button-list))
              (else (help (cdr button-list)))))
      (if on-main-menu?
          (help button-list-main-menu)
          (help button-list-highscore-menu)))
    
    (define/public (handle-mouse-event mouse-x mouse-y event-type)
      ; Hantera mouseover
      (define (help button-list)
        (if (null? button-list)
            (void)
        (let* ((button (car button-list))
               (position (send button get-position)) 
               (button-x (get-x-position position))
               (button-y (get-y-position position))
               (button-width (send button get-width))
               (button-height (send button get-height)))
          
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
                ((eq? button-label 'highscore)
                 (set! on-main-menu? #f)
                 (update-highscore-list)
                 (send new-game-button set-mouseover! #f))
                ((eq? button-label 'next-level)
                 (if (not (= highscore-level (- *number-of-maps* 1)))
                     (begin
                       (set! highscore-level (+ highscore-level 1))
                       (update-highscore-list))
                     (void))
                 (send highscore-next-level-button set-mouseover! #f))
                ((eq? button-label 'previous-level)
                 (if (not (= highscore-level 0))
                     (begin
                       (set! highscore-level (- highscore-level 1))
                       (update-highscore-list))
                     (void))
                 (send highscore-previous-level-button set-mouseover! #f))
                (else (void)))))
      
      (if on-main-menu?
          (help button-list-main-menu)
          (help button-list-highscore-menu))
      
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
    
    (define/public (set-on-menu! bool)
      (set! on-main-menu? bool))
    
    (super-new)))      