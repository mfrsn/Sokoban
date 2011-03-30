;=======================================================
; PRAM 2011, Senast ändrad 2011-03-XX
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: board.scm
; Beskrivning: Definierar den abstrakta datatypen Board
;=======================================================

(load "utils/carray.scm")

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
    (define/public (valid-move? position direction)
      (let ((new-position (calc-new-position position direction))
            (floor-object (get-object new-position))
            (floor-type (send floor-object type?)))
        (cond ((eq? floor-type 'wall) #f)
              ((eq? floor-type 'void) #f)
              ((eq? (send floor-object get-object) 'empty) #t)
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
      (send board set-element! object (get-x-position position) (get-y-position position)))
    
    (super-new)))