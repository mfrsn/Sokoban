;====================================================================
; PRAM 2011
; Senaste ändring: Infört aboutmenyn, 2011-05-13
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
     ; Huvudmenyns bilder
     (main-menu-background-png
      (make-object bitmap%
        "data/textures/background-main-menu.png"))
     
     (main-menu-pane-png
      (make-object bitmap%
        "data/mainmenu/menu-background.png"
        'png/mask))
     
     (main-menu-pane-mask-png
      (send main-menu-pane-png get-loaded-mask))
     
     (main-menu-new-game-button-png
      (make-object bitmap%
        "data/mainmenu/new-game-button.png"
        'png/mask))
     
     (main-menu-new-game-button-mouseover-png
      (make-object bitmap%
        "data/mainmenu/new-game-button-mouseover.png"
        'png/mask))
     
     (main-menu-highscore-button-png
      (make-object bitmap%
        "data/mainmenu/highscore-button.png"
        'png/mask))
     
     (main-menu-highscore-button-mouseover-png
      (make-object bitmap%
        "data/mainmenu/highscore-button-mouseover.png"
        'png/mask))
     
     (main-menu-about-button-png
      (make-object bitmap%
        "data/mainmenu/about-button.png"
        'png/mask))
     
     (main-menu-about-button-mouseover-png
      (make-object bitmap%
        "data/mainmenu/about-button-mouseover.png"
        'png/mask))
     
     ; Highscoremenyns bilder
     (highscore-menu-background-png
      (make-object bitmap%
        "data/textures/background-highscore.png"))
     
     (highscore-menu-pane-png
      (make-object bitmap%
        "data/mainmenu/highscore-background.png"
        'png/mask))
     
     (highscore-menu-pane-mask-png
      (send highscore-menu-pane-png get-loaded-mask))
     
     (highscore-menu-next-level-button-png
      (make-object bitmap%
        "data/mainmenu/highscore-next-level-button.png"
        'png/mask))
     
     (highscore-menu-next-level-button-mouseover-png
      (make-object bitmap%
        "data/mainmenu/highscore-next-level-button-mouseover.png"
        'png/mask))
     
     (highscore-menu-previous-level-button-png
      (make-object bitmap%
        "data/mainmenu/highscore-previous-level-button.png"
        'png/mask))
     
     (highscore-menu-previous-level-button-mouseover-png
      (make-object bitmap%
        "data/mainmenu/highscore-previous-level-button-mouseover.png"
        'png/mask))
     
     ; Aboutmenyns bilder
     (about-menu-background-png
      (make-object bitmap% "data/textures/background-about.png"))
     
     ; Funktionella variabler
     (dc (send canvas get-dc))
     (canvas-width *game-canvas-width*)
     (canvas-height *game-canvas-height*)
     (total-width (+ canvas-width *game-sidebar-width*))
     
     ; Huvudmenyns konstanter
     (on-main-menu? #t)
     (main-menu-position
      (calculate-menu-background-position 'main-menu))
     (main-menu-button-y-offset 20)
     (main-menu-button-spacing 10)
     
     ; Highscoremenyns konstanter
     (on-highscore-menu? #f)
     (highscore-list '())
     (highscore-menu-position
      (calculate-menu-background-position 'highscore-menu))
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
     (number-of-highscore-entrys 5)
     
     ; Aboutmenyns konstanter
     (on-about-menu? #f)
     (about-x-offset 20)
         
     ; Palett
     (colour-text (make-object color% 215 215 215))
     (colour-black (make-object color% 0 0 0))
     
     ; Fonts
     (large-font (send the-font-list find-or-create-font
                       16 "Arial Rounded MT Bold" 'default 'normal 'normal))
     (small-font (send the-font-list find-or-create-font
                       10 "Arial Rounded MT Bold" 'default 'normal 'normal))
     
     ; Knappar
     (main-menu-new-game-button
      (new menu-button%
           [label 'new-game]
           [image main-menu-new-game-button-png]
           [mouseover-image main-menu-new-game-button-mouseover-png]))
     
     (main-menu-highscore-button
      (new menu-button%
           [label 'highscore]
           [image main-menu-highscore-button-png]
           [mouseover-image main-menu-highscore-button-mouseover-png]))
     
     (main-menu-about-button
      (new menu-button%
           [label 'about]
           [image main-menu-about-button-png]
           [mouseover-image main-menu-about-button-mouseover-png]))
     
     (highscore-menu-next-level-button
      (new menu-button%
           [label 'next-level]
           [image highscore-menu-next-level-button-png]
           [mouseover-image highscore-menu-next-level-button-mouseover-png]))
     
     (highscore-menu-previous-level-button
      (new menu-button%
           [label 'previous-level]
           [image highscore-menu-previous-level-button-png]
           [mouseover-image highscore-menu-previous-level-button-mouseover-png]))
     
     ; Listor med knappobjekten för resp. menystate
     (button-list-main-menu (list main-menu-new-game-button
                                  main-menu-highscore-button
                                  main-menu-about-button))
     
     (button-list-highscore-menu (list highscore-menu-next-level-button
                                       highscore-menu-previous-level-button)))
    
    ; Nödvändiga exekveringar
    (send dc set-text-foreground colour-text)
    (set-button-positions!)
    
    ; Sätt knapparnas positioner
    (define/private (set-button-positions!)
      (let ((button-counter 0))
        (define (help button-list identifier)
          (if (null? button-list)
              (void)
              (let ((button (car button-list)))
                (cond ((eq? identifier 'main-menu-buttons)
                       (send button set-position!
                             (calculate-main-menu-button-position button
                                                                  button-counter))
                       (set! button-counter (+ button-counter 1)))
                      ((eq? identifier 'highscore-menu-buttons)
                       (send button set-position!
                             (calculate-highscore-menu-button-position button)))
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
                                    (send highscore-menu-pane-png get-height))
                                 (send button get-height)
                                 highscore-button-bottom-y-offset)))
              ((eq? label 'previous-level)
               (make-position (- (/ total-width 2)
                                 highscore-button-center-x-offset
                                 (send button get-width))
                              (- (+ (get-y-position highscore-menu-position)
                                    (send highscore-menu-pane-png get-height))
                                 (send button get-height)
                                 highscore-button-bottom-y-offset)))
              (else (error "Invalid label: " label)))))
    
    ; Menypositioner
    (define/private (calculate-menu-background-position identifier)
      (let ((image-width 0)
            (image-height 0))
        (cond ((eq? identifier 'main-menu)
               (set! image-width (send main-menu-pane-png get-width))
               (set! image-height (send main-menu-pane-png get-height)))
              ((eq? identifier 'highscore-menu)
               (set! image-width (send highscore-menu-pane-png get-width))
               (set! image-height (send highscore-menu-pane-png get-height)))
              (else (error "Unknown identifier: " identifier)))
        (make-position (- (/ total-width 2) (/ image-width 2))
                       (- (/ canvas-height 2) (/ image-height 2)))))
    
    (define/private (fill-canvas)
      (cond(on-main-menu?
            (send dc draw-bitmap main-menu-background-png 0 0))
           (on-highscore-menu?
            (send dc draw-bitmap highscore-menu-background-png 0 0))
           (on-about-menu?
            (send dc draw-bitmap about-menu-background-png 0 0))
           (else (error "No active menu stage"))))
    
    ; Funktion för utritning av maskerad png
    (define/private (draw-masked-png png mask position)
      (send dc draw-bitmap png (get-x-position position)
            (get-y-position position) 'solid colour-black mask))
    
    ; Funktion för knapputritning
    (define/private (draw-buttons button-list)
      (define (help button-list)
        (if (null? button-list)
            (void)
            (let ((image (send (car button-list) get-image)))
              (draw-masked-png image
                               (send image get-loaded-mask)
                               (send (car button-list) get-position))
              (help (cdr button-list)))))
      (help button-list))        
    
    ; Uppdateringsfunktionen
    (define/private (refresh)
      (cond (on-main-menu?
             (draw-main-menu))
            (on-highscore-menu?
             (draw-highscore-menu))
            (on-about-menu?
             (draw-about-menu))))
    
    ; Funktion som ritar ut huvudmenyn
    (define/private (draw-main-menu)
      (fill-canvas)
      (draw-masked-png main-menu-pane-png
                       main-menu-pane-mask-png
                       main-menu-position)
      (draw-buttons button-list-main-menu))
    
    ; Funktion som ritar ut highscoremenyn
    (define/private (draw-highscore-menu)
      (fill-canvas)
      (draw-masked-png highscore-menu-pane-png
                       highscore-menu-pane-mask-png
                       highscore-menu-position)
      (draw-buttons button-list-highscore-menu)
      (draw-highscore-table))
    
    ; Funktion som ritar ut aboutmenyn
    (define/private (draw-about-menu)
      (fill-canvas)
      (draw-masked-png highscore-menu-pane-png
                       highscore-menu-pane-mask-png
                       highscore-menu-position)
      (draw-about-text))
    
    ; Funktion som ritar ut abouttexten
    (define/private (draw-about-text)
      ; Ritar den angivna strängen på en beräknad postion
      (define (draw-text string row)
        (let ((position (calculate-text-position row)))
          (send dc draw-text string
                (get-x-position position)
                (get-y-position position))))
      
      ; Returnerar utritningkoordinater för varje rad
      (define (calculate-text-position row)
        (make-position (+ (get-x-position highscore-menu-position)
                          about-x-offset)
                       (+ (get-y-position highscore-menu-position)
                          highscore-title-y-offset
                          (* highscore-entry-spacing (- row 1)))))
      
      ; Innehåll
      (send dc set-font small-font)
      (draw-text "About Sokoban" 1)
      (draw-text "Sokoban is a puzzle game in which the objective is to" 2)
      (draw-text "move the blocks, placed throughout the level, to the goal" 3)
      (draw-text "squares, marked with brighter tiles. You control the" 4)
      (draw-text "player by using the arrow keys for moving and the" 5)
      (draw-text "\"p\" key for using power-ups. These can teleport a block" 6)
      (draw-text "directly to an available goal square by simply moving" 7)
      (draw-text "into a block while the power-up is activated. It is also" 8)
      (draw-text "possible to undo your moves by pressing the \"u\" key." 9)
      (draw-text "Good luck!" 10)
      (draw-text "Marcus & Mattias" 11))
    
    ; Kontaktar server för ev. uppdatering av den lokala highscorelistan
    (define/private (update-highscore-list)
      (let ((server-highscore-list (send highscore-client
                                         download-highscore
                                         highscore-level
                                         number-of-highscore-entrys)))
        (if (not (equal? highscore-list server-highscore-list))
            (set! highscore-list server-highscore-list)
            (void))))
    
    ; Ritar ut den lokala highscoreliskan
    (define/private (draw-highscore-table)
      (let ((entry-index 0))
        ; Iterator som går igenom highscorelistan
        (define (help highscore-list)
          (if (null? highscore-list)
              (no-entries-found)
              (let ((cdr-list (cdr highscore-list)))
                (print-highscore-entry (car highscore-list) entry-index)
                (set! entry-index (+ entry-index 1))
                (if (null? cdr-list)
                    (void)
                    (help cdr-list)))))
        
        ; Funktion som ritar ut ett meddelande då highscorelistan är tom
        (define (no-entries-found)
          (send dc draw-text "No entries found!"
                (- (/ total-width 2) 80) (- (/ canvas-height 2) 20)))
        
        ; Beräknar utritningpositioner för alla element i highscorelistan
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
        
        ; Funktion som ritar ut ett element i highscorelistan på canvas
        (define (print-highscore-entry entry entry-index)
          (let ((index-position (calculate-entry-draw-position 'index entry-index))
                (name-position (calculate-entry-draw-position 'name entry-index))
                (score-position (calculate-entry-draw-position 'score entry-index)))
            (send dc draw-text 
                  (string-append (number->string (+ entry-index 1)) ".")
                  (get-x-position index-position)
                  (get-y-position index-position))
            (send dc draw-text
                  (car entry)
                  (get-x-position name-position)
                  (get-y-position name-position))
            (send dc draw-text
                  (number->string (cadr entry))
                  (get-x-position score-position)
                  (get-y-position score-position))))
        
        ; Funktion som ritar ut rubrikerna till highscorelistan
        (define (draw-titles)
          (let ((y-position (+ (get-y-position highscore-menu-position)
                               highscore-header-y-offset
                               highscore-title-y-offset)))
            (send dc draw-text
                  (string-append "Level " (number->string (+ highscore-level 1)))
                  (+ (get-x-position highscore-menu-position)
                     highscore-x-offset)
                  (+ (get-y-position highscore-menu-position)
                     highscore-title-y-offset))
            (send dc draw-text "Rank:"
                  (+ (get-x-position highscore-menu-position) highscore-x-offset)
                  y-position)
            (send dc draw-text "Name:"
                  (get-x-position (calculate-entry-draw-position 'name 0))
                  y-position)
            (send dc draw-text "Score:"
                  (get-x-position (calculate-entry-draw-position 'score 0))
                  y-position)))
        
        (send dc set-font large-font)
        (draw-titles)
        (help highscore-list)))
            
    ; Funktion som returnerar det knappobjekt som pekaren befinner sig på
    (define/private (get-mouseover-button)
      (define (help button-list)
        (cond ((null? button-list) #f)
              ((send (car button-list) get-mouseover)
               (car button-list))
              (else (help (cdr button-list)))))
      (cond (on-main-menu?
             (help button-list-main-menu))
            (on-highscore-menu?
             (help button-list-highscore-menu))
            (else (void))))
    
    ; Funktion som hanterar pekarevent för menysystemet
    (define/public (handle-mouse-event mouse-x mouse-y event-type)
      ; Kontrollera mouseover
      (define (mouseover button-list)
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
        (mouseover (cdr button-list)))))
      
      ; Hantera knapptryckning
      (define (handle-button-press button)
        (let ((button-label (send button get-label)))
          (cond ((eq? button-label 'new-game)
                 (start-new-game!)
                 (send main-menu-new-game-button set-mouseover! #f))
                ((eq? button-label 'highscore)
                 (set! on-main-menu? #f)
                 (set! on-highscore-menu? #t)
                 (update-highscore-list)
                 (send main-menu-highscore-button set-mouseover! #f))
                ((eq? button-label 'about)
                 (set! on-main-menu? #f)
                 (set! on-about-menu? #t)
                 (send main-menu-about-button set-mouseover! #f))
                ((eq? button-label 'next-level)
                 (if (not (= highscore-level (- *number-of-maps* 1)))
                     (begin
                       (set! highscore-level (+ highscore-level 1))
                       (update-highscore-list))
                     (void))
                 (send highscore-menu-next-level-button set-mouseover! #f))
                ((eq? button-label 'previous-level)
                 (if (not (= highscore-level 0))
                     (begin
                       (set! highscore-level (- highscore-level 1))
                       (update-highscore-list))
                     (void))
                 (send highscore-menu-previous-level-button set-mouseover! #f))
                (else (void)))))
      
      ; Exekvera iterationerna genom resp. knapplista
      (cond (on-main-menu?
             (mouseover button-list-main-menu))
            (on-highscore-menu?
             (mouseover button-list-highscore-menu))
            (else (void)))
      
      ; Delegera knapptryckning
      (if (eq? event-type 'left-down)
          (let ((mouseover-button (get-mouseover-button)))
            (if (not mouseover-button)
                (void)
                (handle-button-press mouseover-button)))
          (void)))
    
    ; Den publika utritningsfunktionen
    (define/public (draw)
      (send dc suspend-flush)
      (refresh)
      (send dc flush)
      (send dc resume-flush))
      ;)
    
    ; Funktion som tillåter ändring av menytillstånd utanför klassen
    (define/public (set-on-main-menu! bool)
      (set! on-highscore-menu? #f)
      (set! on-about-menu? #f)
      (set! on-main-menu? bool))
    
    (super-new)))      