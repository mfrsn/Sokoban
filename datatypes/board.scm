;=======================================================
; PRAM 2011
; Senaste ändring: nödlösning till level-complete? 2011-04-02
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: board.scm
; Beskrivning: Definierar den abstrakta datatypen Board
;=======================================================

(require scheme/mpair)

; Klass
(define board%
  (class object%
    
    ; Konstruktorvärden
    (init-field size-x
                size-y)
    
    ; Lokala fält
    (field (board (new array%
                       [width size-x]
                       [height size-y]))
           
           ; Lista med målområdesobjekten för effektiv åtkomst vid vinstkontroll
           (list-of-goals '())
           (start-position #f))
    
    ; #### Private ####
    
    ; Utför själva förflyttningen av objekt på spelplanen
    (define/private (do-move! object current-position new-position)
      (send (get-object current-position) delete-object!)
      (send (get-object new-position) add-object! object)
      (send object set-position! new-position))
    
    ; Funktion som kollar om en golvruta är tom
    (define/private (is-empty? position)
      (eq? (send (get-object position) get-object) 'empty))
    
    ; Funktion som hanterar förflyttning av block och spelare
    (define/private (handle-block-move player block player-position block-position direction)
      (let ((new-position (calc-new-position block-position direction)))
        (if (and (is-empty? new-position)
                 (check-square new-position))
            (begin
              (do-move! block block-position new-position)
              (do-move! player player-position block-position)
              (send *counter* increase!))
            (void))))
    
    ; Funktion som hanterar upptagning av power-up
    (define/private (handle-power-up player power-up player-position power-up-position)
      (send player set-power-up! power-up)
      (send power-up set-position! 'player)
      (send (get-object power-up-position) delete-object!)
      (do-move! player player-position power-up-position)
      (send *counter* increase!)
      (play-sound "data/sounds/power-up.wav" #t))
    
    ; Kontrollerar om förflyttning är möjlig. Om block eller powerup så returneras
    ; respektive objekt.
    (define/private (check-square position)
      (let* ([floor-object (get-object position)]
             [floor-object-type (send floor-object get-type)])
        (cond ((eq? floor-object-type 'wall) #f)
              ((eq? floor-object-type 'void) #f)
              (else (send floor-object get-object)))))
    
    ; #### Public ####
    
    ; Lägger till spelaren i brädet
    (define/public (add-player! player)
      (send (get-object start-position) add-object! player)
      (send player set-position! start-position))
    
    ; Kontrollerar om alla målrutor är fyllda
    (define/public (level-complete?)
      (define (goal-iter list-of-goals)
        (cond ((null? list-of-goals)
               #t)
              ((eq? (send (mcar list-of-goals) get-object) 'empty)
               #f)
              ((not (eq? (send (send (mcar list-of-goals) get-object) get-type) 'block))
               #f)
              (else (goal-iter (mcdr list-of-goals)))))
      (goal-iter list-of-goals))
    
    ; Lägger in ett målobjekt i listan av mål
    (define/public (add-to-goal-list! goal)
      (set! list-of-goals (mcons goal list-of-goals)))
    
    ; Uppdaterar startposition för spelaren
    (define/public (set-start-position! position)
      (set! start-position position))
    
    ; TEMP Returnerar board
    (define/public (get-board)
      (send board get-array))
    
    ; Returnerar brädets bredd
    (define/public (get-width)
      size-x)
    
    ; Returnerar brädets höjd
    (define/public (get-height)
      size-y)
    
    ; Returnerar golv-objektet på position
    (define/public (get-object position)
      (send board get-element (get-x-position position) (get-y-position position)))
    
    ; Sätter golv-objektet på position till object
    (define/public (set-square! position object)
      (send board set-element! object (get-x-position position) (get-y-position position))
      (send object set-position! position))
    
    ; Funktionen som kontrollerar förflyttning på spelplanen
    (define/public (move! object direction)
      (let* ((current-position (send object get-position))
             (new-position (calc-new-position current-position direction))
             (check-square-result (check-square new-position)))
        (if (not check-square-result)
            (void)
            (if (is-empty? new-position)
                (begin
                  (do-move! object current-position new-position)
                  (send *counter* increase!))
                (if (eq? (send check-square-result get-type) 'block)
                    (handle-block-move object check-square-result current-position new-position direction)
                    (handle-power-up object check-square-result current-position new-position))))))
    
    (define/public (print-board)
      (define (iter-r row)
        
        (define (iter-c col)
          (cond ((= col size-x) (void))
                (else (if (eq? (send (get-object (make-position col row)) get-object) 'empty)
                          (begin (display (send (get-object (make-position col row)) get-type)) (display " "))
                          (begin (display (send (send (get-object (make-position col row)) get-object) get-type)) (display " ")))
                      (iter-c (+ col 1)))))
        
        (cond ((= row size-y) (void))
              (else (iter-c 0) (newline)
                    (iter-r (+ row 1)))))
      
      (iter-r 0))
    
    (super-new)))