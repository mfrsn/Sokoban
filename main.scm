;=====================================================
; PRAM 2011, Senast ändrad 2011-03-XX
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: main.scm
; Beskrivning: Ingångspunkt för programmet.
;=====================================================

(load "utils/position.scm")
(load "utils/carray.scm")

(load "datatypes/board.scm")
(load "datatypes/floor.scm")

(define test-board (new board%
                        [size-x 4]
                        [size-y 4]))

(display "[Set->Get test]")(newline)

(define position (make-position 1 3))

(define test-floor (new floor%
                        [type 'wall]))

(send test-board set-square! position test-floor)

(display "Klarade testet? ")
(eq? (send test-board get-object position) test-floor)
