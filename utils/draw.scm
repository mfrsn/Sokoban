;=============================================================
; PRAM 2011, Senast ändrad 2011-04-01
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: draw.scm
; Beskrivning: Definierar de funktioner som sköter uppritning.
;=============================================================

(define draw-object%
  (class object%
    
    ; Konstruktorvärden
    (init-field canvas
                current-board)
    
    ; Lokala fält
    (field 
     ; Funktionella variabler
     (refresh? #t)
     (canvas-width (send canvas get-width))
     (canvas-height (send canvas get-height))
     (map-width (send current-board get-width))
     (map-height (send current-board get-height))
     (block-size (calculate-block-size))
     (dc (send canvas get-dc))
     
     ; Konstanta verktyg
     (background-colour (make-colour 0 34 102))
     (player-colour (make-colour 178 34 34))
     (block-colour (make-colour 94 64 51))
     (floor-colour (make-colour 159 182 205))
     (wall-colour (make-colour 0 0 0))
     (goal-colour (make-colour 255 215 0))
     (power-up-colour (make-colour 60 179 113))
     
     ; Brushes
     (no-brush (make-object brush% "WHITE" 'transparent))
     (background-brush (make-object brush% background-colour 'solid))
     (black-brush (make-object brush% "BLACK" 'solid))
     (blue-brush (make-object brush% "BLUE" 'solid))
     (red-brush (make-object brush% "RED" 'solid))
     (green-brush (make-object brush% "GREEN" 'solid))
     (yellow-brush (make-object brush% "YELLOW" 'solid))
     (brown-brush (make-object brush% "BROWN" 'solid))
     (player-brush (make-object brush% player-colour 'solid))
     (block-brush (make-object brush% block-colour 'solid))
     (floor-brush (make-object brush% floor-colour 'solid))
     (wall-brush (make-object brush% wall-colour 'solid))
     (goal-brush (make-object brush% goal-colour 'solid))
     (power-up-brush (make-object brush% power-up-colour 'solid))
     
     ; Pens
     (no-pen (make-object pen% "WHITE" 1 'transparent))
     (background-pen (make-object pen% background-colour 1 'solid))
     (black-pen (make-object pen% "BLACK" 1 'solid))
     (black-pen2 (make-object pen% "BLACK" 2 'solid)))
    
    ; #### Private ####
    
    ; Ritar ett block med sitt övre vänstra hörn i position
    (define/private (draw-block position)
      (let ((draw-position (translate-position position)))
        (send dc draw-rectangle (get-x-position draw-position) (get-y-position draw-position) block-size block-size)
        (send dc set-brush no-brush)))
    
    ; Fyller hela canvas med background-colour
    (define/private (fill-canvas)
      (send dc set-brush background-brush)
      (send dc draw-rectangle 0 0 canvas-width canvas-height)
      (send dc set-brush no-brush))
    
    ; Funktion som skapar ett rgb-objekt
    (define/private (make-colour r g b)
      (make-object color% r g b))
    
    ; Funktion som räknar ut sidan för ett block
    ; detta beroende av nivåns utseende ENBART FÖR TESTSYFTE
    (define/private (calculate-block-size)
      (min (floor (/ canvas-width map-width))
           (floor (/ canvas-height map-height))))
      
    ; Funktion som 
    (define/private (translate-position position)
      (make-position (* (get-x-position position) block-size)
                     (* (get-y-position position) block-size)))
    
    (define/private (refresh)
      (define (iter-row row)
        
        (define (iter-col col)
          (if (= col map-width)
              (void)
              (let* ((position (make-position col row))
                     (floor-object (send current-board get-object position))
                     (object-on-floor (send floor-object get-object)))
                
                (if (eq? object-on-floor 'empty)
                  (let ((type (send floor-object get-type)))
                    (cond ((eq? type 'void)
                           (void))
                          ((eq? type 'floor)
                           (send dc set-brush floor-brush)
                           (draw-block position))
                          ((eq? type 'wall)
                           (send dc set-brush wall-brush)
                           (draw-block position))
                          ((eq? type 'goal)
                           (send dc set-brush goal-brush)
                           (draw-block position))
                          (else (error "Invalid floor type:" type))))
                  
                  (let ((type (send object-on-floor get-type)))
                    (cond ((eq? type 'player)
                           (send dc set-brush player-brush))
                          ((eq? type 'block)
                           (send dc set-brush block-brush))
                          ((eq? type 'power-up)
                           (send dc set-brush power-up-brush))
                          (else (error "Invalid floor-object-type:" type)))
                    (draw-block position)))
                
                (iter-col (+ col 1)))))
        
        (if (= row map-height)
            (void)
            (begin
              (iter-col 0)
              (iter-row (+ row 1)))))
      
      (iter-row 0))
                          
    
    ; #### Public ####
    
    ; Sätter current-board till new-board
    (define/public (set-board! new-board)
      (set! current-board new-board))
    
    ; Omritningsfunktion, kallas i samband med nivåbyte.
    (define/public (redraw)
      (set! refresh? #t)
      (set! map-width (send current-board get-width))
      (set! map-height (send current-board get-height))
      (set! block-size (calculate-block-size))
      (draw))
    
    ; Den publika ritfunktionen
    (define/public (draw)
      (if refresh?
          (begin
            (fill-canvas)
            (set! refresh? #f)
            (refresh))
          (refresh)))
    
    (super-new)))

  
