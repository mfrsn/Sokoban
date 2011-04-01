;=======================================================
; PRAM 2011, Senast ändrad 2011-04-01
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: testcases.scm
; Beskrivning: Definierar hårdkodade setups av testfall.
;=======================================================

(define (test-run-level-1)
  (send *player* move! 'up)
  (send *player* move! 'left)
  (send *player* move! 'left)
  (send *player* move! 'left)
  (send *player* move! 'up)
  (send *player* move! 'up)
  (send *player* move! 'up)
  (send *player* move! 'left)
  (send *player* move! 'up)
  (send *player* move! 'left)
  (send *player* move! 'up)
  (send *player* move! 'up)
  (send *player* move! 'down)
  (display "Use power-up: ")
  (send *player* use-power-up) (newline)
  (display "Power-up gone? ")
  (eq? (send *player* use-power-up) 'empty)
  (display "Moved blocks? ") (newline)
  (display "Block 1: ")
  (not (eq? (send (send level get-object (make-position 7 2)) get-object) 'empty)) (newline)
  (display "Block 2: ")
  (not (eq? (send (send level get-object (make-position 6 4)) get-object) 'empty)) (newline)
  (display "DONE!"))