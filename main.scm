;=====================================================
; PRAM 2011, Senast ändrad 2011-03-XX
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: main.scm
; Beskrivning: Ingångspunkt för programmet.
;=====================================================

(load "utils/position.scm")
(load "datatypes/board.scm")
(load "utils/level-init.scm")

(define test-board (new board%
                        [size-x 4]
                        [size-y 4]))

(display "[Set->Get test]")(newline)

(define val 42)
(define pos (make-position 1 3))

(send test-board set-square! pos val)

(display "Klarade testet? ")
(eq? (send test-board get-object pos) val)