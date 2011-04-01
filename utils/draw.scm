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
     (refresh? #f)
     (canvas-width (send canvas get-width))
     (canvas-height (send canvas get-height))
     (map-width (send current-board get-width))
     (map-height (send current-board get-height))
     (block-size (calculate-block-size))
     (dc (send canvas get-dc))
     
     ; Konstanta verktyg
     (background-colour (make-colour 135 184 145))
     
     ; Brushes
     (no-brush (make-object brush% "WHITE" 'transparent))
     (background-brush (make-object brush% background-colour 'solid))
     (black-brush (make-object brush% "BLACK" 'solid))
     (blue-brush (make-object brush% "BLUE" 'solid))
     (red-brush (make-object brush% "RED" 'solid))
     (green-brush (make-object brush% "GREEN" 'solid))
     (yellow-brush (make-object brush% "YELLOW" 'solid))
     (brown-brush (make-object brush% "BROWN" 'solid))
     
     ; Pens
     (no-pen (make-object pen% "WHITE" 1 'transparent))
     (background-pen (make-object pen% background-colour 1 'solid))
     (black-pen (make-object pen% "BLACK" 2 'solid)))
    
    ; #### Private ####
    
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
                    (cond ((eq? type 'floor)
                           (send dc set-brush blue-brush))
                          ((eq? type 'wall)
                           (send dc set-brush black-brush))
                          ((eq? type 'goal)
                           (send dc set-brush yellow-brush))
                          ((eq? type 'void)
                           (void))
                          (else (error "Invalid floor type:" type)))
                    (draw-block position))
                  
                  (let ((type (send object-on-floor get-type)))
                    (cond ((eq? type 'player)
                           (send dc set-brush red-brush))
                          ((eq? type 'block)
                           (send dc set-brush brown-brush))
                          ((eq? type 'power-up)
                           (send dc set-brush green-brush))
                          (else (error "Invalid floor-object-type:" type)))
                    (draw-block position)))
                
                (iter-col (+ col 1)))))
        
        (if (= row map-height)
            (void)
            (begin
              (iter-col 0)
              (iter-row (+ row 1)))))
      
      (send dc set-pen no-pen)
      (iter-row 0))
                          
    
    ; #### Public ####
    
    ; Sätter current-board till new-board
    (define/public (set-board! new-board)
      (set! current-board new-board))
    
    ; Omritningsfunktion, kallas i samband med nivåbyte.
    (define/public (redraw)
      (set! refresh? #f)
      (draw))
    
    ; Den publika ritfunktionen
    (define/public (draw)
      (if (not refresh?)
          (begin
            (fill-canvas)
            (set! refresh? #t)
            (refresh))
          (refresh)))
    
    (super-new)))

(define graphical-object%
  (class object%
    
    ; Konstruktorvärden
    
    (super-new)))
    

  
