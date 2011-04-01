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
(load "utils/level-init.scm")

(load "datatypes/board.scm")
(load "datatypes/floor.scm")
(load "datatypes/player.scm")
(load "datatypes/power-up.scm")
(load "datatypes/block.scm")

(define *player* (new player%
                      [current-position 'unknown]
                      [current-board 'none]))

(define level-data (load-level-file "levels/level-2"))
(define level (parse-level-data level-data *player*))