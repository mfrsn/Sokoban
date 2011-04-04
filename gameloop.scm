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

; ADT:s
(load "datatypes/board.scm")
(load "datatypes/floor.scm")
(load "datatypes/player.scm")
(load "datatypes/power-up.scm")
(load "datatypes/block.scm")

;=========
; Init
;=========

; Game board
(define *player* (new player%
                      [current-position 'unknown]
                      [current-board 'none]))

(define *level-1* (parse-level-data (load-level-file "levels/level-2")))
(define *level-2* (parse-level-data (load-level-file "levels/level-1")))

(define *current-level-id* 0)
(define *level-list* (make-vector 2))

(vector-set! *level-list* 0 *level-1*)
(vector-set! *level-list* 1 *level-2*)

(send *player* set-board! *level-1*)

; Gfx
(define *width* 800)
(define *height* 480)
(define *victory* #f)
(define *player-name* (void))

(define GUI (make-gui *width* *height*))

(define *game-canvas* (new draw-object%
                           [canvas (get-canvas GUI)]
                           [current-board *level-1*]))

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
  
  (if (send (current-level) level-complete?)
      (begin
        (play-sound "utils/win-sound.wav" #t)
        (send win-dialog show #t))
      (void)))

;=========
; Handles?
;=========

(define (next-level)
  (set! *current-level-id* (+ *current-level-id* 1))
  *current-level-id*)

(define (current-level)
  (vector-ref *level-list* *current-level-id*))

(define (load-level level-id)
  (let ((level (vector-ref *level-list* level-id)))
    (send *game-canvas* set-board! level)
    (send *player* set-board! level)
    (send *game-canvas* redraw)))