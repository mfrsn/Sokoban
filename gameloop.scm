;=====================================================
; PRAM 2011
; Senaste ändring: Skapade filen 2011-04-01
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: gameloop.scm
; Beskrivning: just testin shit'n'stuff
;=====================================================

; Utils
(load "utils/position.scm")
(load "utils/carray.scm")
(load "utils/level-init.scm")

; ADT:s
(load "datatypes/board.scm")
(load "datatypes/floor.scm")
(load "datatypes/player.scm")
(load "datatypes/power-up.scm")
(load "datatypes/block.scm")

; Gameloop
; - Init
; -- Load levels, init player, init counters
; -- set Level-1 as current level
; -- Draw everything
; -Loop
; -- Ask for input
; --- Validate input
; ---- Do/donot
; -- Count
; -- Check victory conditions
; --- Connect to server
; ---- Send highscore data
; --- Load next-level
; -- Draw
; -Exit