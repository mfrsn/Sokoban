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
(load "datatypes/player.scm")

(define test-board (new board%
                        [size-x 4]
                        [size-y 4]))

(display "[Set->Get test]")(newline)

(define position1 (make-position 1 3))
(define position2 (make-position 1 2))

(define test-floor1 (new floor%
                         [type 'floor]))
(send test-board set-square! position1 test-floor1)

(define test-floor2 (new floor%
                         [type 'wall]))
(send test-board set-square! position2 test-floor2)

(define *player* (new player%
                      [current-position position1]
                      [current-board test-board]))

;(display "Klarade testet? ")
;(eq? (send test-board get-object position) test-floor)
