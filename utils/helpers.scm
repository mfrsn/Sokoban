;================================================================
; PRAM 2011
; Senaste ändring: 2011-04-06
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: level-init.scm
; Beskrivning: Hjälpfunktioner för programflödet
;================================================================

; Hämtar inladdad rådata
(define (get-board-data level)
  (vector-ref *game-data* level))

; Återställer den nuvarande nivåns originaltillstånd
(define (load-level!)
  (set! *current-board* (parse-level-data (get-board-data *current-level*)))
  (send *player* set-board! *current-board*)
  (send *counter* set-level! *current-level*)
  (send *game-canvas* redraw))

; Återställer nuvarande nivån
(define (reset-level!)
  (load-level!))

; Laddar nästa nivå
(define (next-level!)
  (set! *current-level* (+ *current-level* 1))
  (load-level!))

; Laddar tidigare nivå
(define (previous-level!)
  (set! *current-level* (- *current-level* 1))
  (load-level!))

; Startar om från första nivån
(define (restart-game!)
  (set! *current-level* 0)
  (load-level!))