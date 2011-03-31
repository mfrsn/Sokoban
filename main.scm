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
(load "datatypes/power-up.scm")
(load "datatypes/block.scm")

(define test-board (new board%
                        [size-x 5]
                        [size-y 5]))

(display "[Set->Get test]")(newline)

; Positioner
(define pos00 (make-position 0 0))
(define pos01 (make-position 0 1))
(define pos02 (make-position 0 2))
(define pos10 (make-position 1 0))
(define pos11 (make-position 1 1))
(define pos12 (make-position 1 2))
(define pos20 (make-position 2 0))
(define pos21 (make-position 2 1))
(define pos22 (make-position 2 2))

; Spelare
(define *player* (new player%
                      [current-position pos12]
                      [current-board test-board]))

; Power-up
(define *power-up* (new power-up%
                        [current-position pos00]
                        [power-up-procedure
                         (lambda () (display "You've used a power-up"))]))

; Block
(define *block* (new block%
                     [current-position pos11]))

; Golvobjekt
(define f00 (new floor% [type 'floor]))
(define f01 (new floor% [type 'floor]))
(define f02 (new floor% [type 'floor]))
(define f10 (new floor% [type 'floor]))
(define f11 (new floor% [type 'floor]))
(define f12 (new floor% [type 'floor]))
(define f20 (new floor% [type 'floor]))
(define f21 (new floor% [type 'floor]))
(define f22 (new floor% [type 'floor]))

; Inplacering av golvobjekt på brädet
(send test-board set-square! pos00 f00)
(send test-board set-square! pos01 f01)
(send test-board set-square! pos02 f02)
(send test-board set-square! pos10 f10)
(send test-board set-square! pos11 f11)
(send test-board set-square! pos12 f12)
(send test-board set-square! pos20 f20)
(send test-board set-square! pos21 f21)
(send test-board set-square! pos22 f22)


; Lagring av spelare, block och power-up i golvobjekten
(send f11 add-object! *block*)
(send f00 add-object! *power-up*)
(send f21 add-object! *player*)

;(display "Klarade testet? ")
;(eq? (send test-board get-object position) test-floor)
