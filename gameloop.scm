;====================================================================
; PRAM 2011
; Senaste ändring: Power-up funktionalitet implementerad 2011-04-17
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
(load "utils/cmenu.scm")
(load "utils/draw-menu.scm")

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
(vector-set! *game-data* 0 (load-level-file "levels/level-1"))
(vector-set! *game-data* 1 (load-level-file "levels/level-2"))
(vector-set! *game-data* 2 (load-level-file "levels/level-3"))

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
(define *game-canvas-width* 800)
(define *game-canvas-height* 480)
(define *game-menu-width* 100)
(define *game-menu-height* 480)
(define *victory* #f)

(define GUI (make-gui *game-canvas-width*
                      *game-canvas-height*
                      *game-menu-width*
                      *game-menu-height*))

(define *game-canvas* (new draw-object%
                           [canvas (get-game-canvas GUI)]))

(define *game-frame* (get-game-frame GUI))

(define *game-sidebar* (new draw-sidebar%
                            [sidebar-canvas (get-sidebar-canvas GUI)]))

; Starta spelet
(sleep/yield 0.01)
(send *game-canvas* draw)
(send *game-sidebar* draw)

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
  (send *game-sidebar* draw)
  
  (if (send *current-board* level-complete?)
      (begin
        (play-sound "data/sounds/win-sound.wav" #t)
        (send *counter* report-score *player-name*)
        (send win-dialog show #t))
      (void)))