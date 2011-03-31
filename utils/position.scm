;=====================================================
; PRAM 2011, Senast ändrad 2011-03-XX
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: position.scm
; Beskrivning: Funktioner som arbetar med positioner
;=====================================================

(define (make-position pos-x pos-y)
  (make-posn pos-x pos-y))

(define (get-x-position position)
  (posn-x position))

(define (get-y-position position)
  (posn-y position))

(define (calc-new-position position direction)
  (cond ((eq? direction 'up) 
         (make-position (get-x-position position)
                        (- (get-y-position position)
                           1)))
        ((eq? direction 'down)
         (make-position (get-x-position position)
                        (+ (get-y-position position)
                           1)))
        ((eq? direction 'left)
         (make-position (- (get-x-position position) 
                           1)
                        (get-y-position position)))
        ((eq? direction 'right)
         (make-position (+ (get-x-position position) 
                           1)
                        (get-y-position position)))
        (else (error "Invalid direction:" direction))))
