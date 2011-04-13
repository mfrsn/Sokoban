;====================================================================
; PRAM 2011
; Senaste ändring: Ändrat i nivårepresentationen 2011-04-06
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: gameloop.scm
; Beskrivning: Definierar vår gameloop, uppstart + globala variabler
;====================================================================

; Utils
(load "utils/position.scm")
(load "utils/carray.scm")
(load "utils/level-init.scm")
(load "utils/GUI.scm")
(load "utils/ccanvas.scm")
(load "utils/draw.scm")
(load "utils/helpers.scm")
(load "utils/cgif.scm")

; ADT:s
(load "datatypes/board.scm")
(load "datatypes/floor.scm")
(load "datatypes/player.scm")
(load "datatypes/power-up.scm")
(load "datatypes/block.scm")
(load "datatypes/counter.scm")

; Ladda in nivåfilerna
(define *number-of-maps* 3)
(define *game-data* (make-vector *number-of-maps*))
(vector-set! *game-data* 0 (load-level-file "levels/level-2"))
(vector-set! *game-data* 1 (load-level-file "levels/level-3"))
(vector-set! *game-data* 2 (load-level-file "levels/level-1"))

; Skapa spelaren
(define *player* (new player%
                      [current-position 'unknown]
                      [current-board 'none]))

(define *player-name* (void))

; Initiera första nivån
(define *current-level* 0)
(define *current-board* (parse-level-data (get-board-data *current-level*)))
(send *player* set-board! *current-board*)

(define *counter* (new counter%))
(send *counter* set-level! *current-level*)

; Grafikinställningar
(define *width* 800)
(define *height* 480)
(define *victory* #f)

(define GUI (make-gui *width* *height*))

(define *game-canvas* (new draw-object%
                           [canvas (get-canvas GUI)]))

(define *game-frame* (get-frame GUI))

; Starta spelet
(sleep/yield 0.01)
(send *game-canvas* draw)

; Spelloopen, ligger endast och väntar på knapptryckningar
(define (handle-key-event key)
  (cond ((eq? key 'up)
         (send *player* move! 'up))
        ((eq? key 'down)
         (send *player* move! 'down))
        ((eq? key 'left)
         (send *player* move! 'left))
        ((eq? key 'right)
         (send *player* move! 'right))
        ((eq? key #\p)
         (send *player* use-power-up))
        (else (void)))

  ; Do shit 'n stuff here
  (send *game-canvas* draw)
  
  (if (send *current-board* level-complete?)
      (begin
        (play-sound "data/sounds/win-sound.wav" #t)
        (send *counter* report-score *player-name*)
        (send win-dialog show #t))
      (void)))