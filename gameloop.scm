;====================================================================
; PRAM 2011
; Senaste ändring: Power-up funktionalitet implementerad 2011-04-17
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: gameloop.scm
; Beskrivning: Definierar vår gameloop, uppstart + globala variabler
;====================================================================

; ADT:s
(load "datatypes/board.scm")
(load "datatypes/floor.scm")
(load "datatypes/player.scm")
(load "datatypes/power-up.scm")
(load "datatypes/block.scm")
(load "datatypes/counter.scm")
(load "datatypes/highscore.scm")

; Utils
(load "utils/position.scm")
(load "utils/carray.scm")
(load "utils/level-init.scm")
(load "utils/GUI.scm")
(load "utils/ccanvas.scm")
(load "utils/draw.scm")
(load "utils/game-control.scm")
(load "utils/cgif.scm")
(load "utils/csidebar.scm")
(load "utils/draw-sidebar.scm")
(load "utils/main-menu.scm")
(load "utils/main-menu-button.scm")
(load "utils/client.scm")

; Huvudmeny
(define *main-menu-active?* #t)

; Anslutning till servern
(define *port* 23408)
(define *host* "130.236.71.123")

; Ladda in nivåfilerna
(define *number-of-maps* 6)
(define *game-data* (make-vector *number-of-maps*))
(vector-set! *game-data* 0 (load-level-file "levels/level-1"))
(vector-set! *game-data* 1 (load-level-file "levels/level-2"))
(vector-set! *game-data* 2 (load-level-file "levels/level-3"))
(vector-set! *game-data* 3 (load-level-file "levels/level-4"))
(vector-set! *game-data* 4 (load-level-file "levels/level-5"))
(vector-set! *game-data* 5 (load-level-file "levels/level-6"))

; Starta klient till highscoreservern
(define *highscore-client* (new client%
                                [port-number *port*]
                                [host-address *host*]))

; Skapa spelaren
(define *player* (new player%
                      [current-position 'unknown]
                      [current-board 'none]))

(define *player-name* (void))

; Initiera första nivån
(define *current-level* 0)
(define *current-board* (parse-level-data (get-board-data *current-level*)))

; Räknaren
(define *counter* (new counter%))
(send *counter* set-level! *current-level*)

; Grafikinställningar
(define *game-canvas-width* 800)
(define *game-canvas-height* 480)
(define *game-sidebar-width* 100)
(define *game-sidebar-height* 480)
(define *victory* #f)


; Miljön
(define GUI (make-gui *game-canvas-width*
                      *game-canvas-height*
                      *game-sidebar-width*
                      *game-sidebar-height*))

(define *game-frame* (get-game-frame GUI))

(define *game-canvas* (new draw-object%
                           [canvas (get-game-canvas GUI)]))

(define *game-sidebar* (new draw-sidebar%
                            [sidebar-canvas (get-sidebar-canvas GUI)]))

(define *main-menu* (new main-menu%
                         [canvas (get-game-canvas GUI)]
                         [highscore-client *highscore-client*]))

; Spelloopen, ligger endast och väntar på knapptryckningar
(define (handle-key-event key)
  (if *main-menu-active?*
      (void)
      (begin
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
             (send *highscore-client* upload-score *current-level* *player-name* (send *counter* get-count))
             (send win-dialog show #t))
           (void)))))

; Hantera musevent för huvudcanvas
(define (handle-mouse-event event)
  (if *main-menu-active?*
      (send *main-menu* handle-mouse-event (send event get-x) (send event get-y) (send event get-event-type))
      (void)))

(define (draw-main-menu)
  (send *main-menu* draw)
  (send *game-sidebar* draw-main-menu))

; Huvudmenyns animationstimer
(define *main-menu-animation-timer* (new timer%
                                         [interval 150]
                                         [notify-callback draw-main-menu]))
(send *main-menu-animation-timer* stop)

; Starta spelet

(define (run)
  (send *game-frame* show #t)
  (main-menu!))