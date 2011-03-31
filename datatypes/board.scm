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
    
    ; Kontrollerar om förflyttning är möjlig. Om block eller powerup returneras
    ; respektive objekt.
    ; TODO: fixa ALLT!
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
    
    ; Funktionen som kontrollerar förflyttning på spelplanen
    (define/public (move! object direction)
      (let* ((current-position (send object get-position))
             (new-position (calc-new-position current-position direction))
             (check-square-result (check-square new-position)))
        (if (not check-square-result)
            (void)
            (if (not (object? check-square-result))
                (do-move! object current-position new-position)
                #f))))
    
    (super-new)))