;=====================================================
; PRAM 2011
; Senaste ändring: Gameloop påbörjad 2011-04-04
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
(load "utils/GUI.scm")
(load "utils/ccanvas.scm")
(load "utils/draw.scm")
(load "utils/helpers.scm")

; ADT:s
(load "datatypes/board.scm")
(load "datatypes/floor.scm")
(load "datatypes/player.scm")
(load "datatypes/power-up.scm")
(load "datatypes/block.scm")

;=========
; Init
;=========
(define *game-data* (make-vector 3))
(vector-set! *game-data* 0 (load-level-file "levels/level-1"))
(vector-set! *game-data* 1 (load-level-file "levels/level-2"))
(vector-set! *game-data* 2 (load-level-file "levels/level-3"))

(define *player* (new player%
                      [current-position 'unknown]
                      [current-board 'none]))

(define *current-level* 0)
(define *current-board* (parse-level-data (get-board-data *current-level*)))
(send *player* set-board! *current-board*)

; Gfx
(define *width* 800)
(define *height* 480)
(define *victory* #f)
(define *player-name* (void))

(define GUI (make-gui *width* *height*))

(define *game-canvas* (new draw-object%
                           [canvas (get-canvas GUI)]))

(define *game-frame* (get-frame GUI))

(sleep/yield 0.01)
(send *game-canvas* draw)

;=========
; Loop
;=========

(define (handle-key-event key)
  (cond ((eq? key 'up)
         (send *player* move! 'up))
        ((eq? key 'down)
         (send *player* move! 'down))
        ((eq? key 'left)
         (send *player* move! 'left))
        ((eq? key 'right)
         (send *player* move! 'right))
        (else (void)))
  
  ; Do shit 'n stuff here
  (send *game-canvas* draw)
  
  (if (send *current-board* level-complete?)
      (begin
        (play-sound "utils/win-sound.wav" #t)
        (send win-dialog show #t))
      (void)))