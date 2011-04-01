;=======================================================
; PRAM 2011, Senast ändrad 2011-03-XX
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: board.scm
; Beskrivning: Definierar den abstrakta datatypen Board
;=======================================================

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
           (list-of-goals #f))
    
    ; Kontrollerar om förflyttning är möjlig. Om block eller powerup så returneras
    ; respektive objekt.
    (define/public (check-square position)
      (let* ([floor-object (get-object position)]
             [floor-object-type (send floor-object get-type)])
        (cond ((eq? floor-object-type 'wall) #f)
              ((eq? floor-object-type 'void) #f)
              (else (send floor-object get-object)))))
    
    ; Kontrollerar om alla målrutor är fyllda
    (define/public (level-complete?)
      (define (goal-iter list-of-goals)
        (cond ((not (list-of-goals))
               (error ("No goal objects instantiated.")))
              ((null? list-of-goals)
               #t)
              ((eq? (send (car list-of-goals) get-object) 'empty)
               #f)
              (else (goal-iter (cdr list-of-goals)))))
      (goal-iter list-of-goals))
    
    ; TEMP Returnerar board
    (define/public (get-board)
      (send board get-array))
    
    ; Returnerar golv-objektet på position
    (define/public (get-object position)
      (send board get-element (get-x-position position) (get-y-position position)))
    
    ; Sätter golv-objektet på position till object
    (define/public (set-square! position object)
      (send board set-element! object (get-x-position position) (get-y-position position))
      (send object set-position! position))
    
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
        (if (is-empty? new-position)
            (begin
              (do-move! block block-position new-position)
              (do-move! player player-position block-position))
            (void))))
    
    ; Funktion som hanterar upptagning av power-up
    (define/private (handle-power-up player power-up player-position power-up-position)
      (send player set-power-up! power-up)
      (send (get-object power-up-position) delete-object!)
      (do-move! player player-position power-up-position))
    
    ; Funktionen som kontrollerar förflyttning på spelplanen
    (define/public (move! object direction)
      (let* ((current-position (send object get-position))
             (new-position (calc-new-position current-position direction))
             (check-square-result (check-square new-position)))
        (if (not check-square-result)
            (void)
            (if (is-empty? new-position) ; not (object? check-square-result)
                (do-move! object current-position new-position)
                (if (eq? (send check-square-result get-type) 'block)
                    (handle-block-move object check-square-result current-position new-position direction)
                    (handle-power-up object check-square-result current-position new-position))))))
    
    (super-new)))