;=====================================================
; PRAM 2011, Senast ändrad 2011-04-01
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: main.scm
; Beskrivning: Ingångspunkt för programmet.
;=====================================================

(load "utils/position.scm")
(load "utils/carray.scm")
(load "utils/level-init.scm")
(load "utils/GUI.scm")
(load "utils/ccanvas.scm")
(load "utils/draw.scm")

(load "datatypes/board.scm")
(load "datatypes/floor.scm")
(load "datatypes/player.scm")
(load "datatypes/power-up.scm")
(load "datatypes/block.scm")

(define *player* (new player%
                      [current-position 'unknown]
                      [current-board 'none]))

(define *level-2* (parse-level-data (load-level-file "levels/level-3")))
(send *player* set-board! *level-2*)

; Starta GUI

; Konstanter
(define *width* 800)
(define *height* 480)
(define *victory* #f)
(define *player-name* (void))

; Skapar GUI:n. (make-gui) returnerar ett par av frameobjektet
; och det canvasobjekt som ligger i denna. 
(define GUI (make-gui *width* *height*))

; Skapar ett draw-objekt som definieras som objektet *game-canvas*
; draw-object% lägger den grafiska funktionaliteten
; till vår canvas.

(define *game-canvas* (new draw-object%
                           [canvas (get-canvas GUI)]
                           [current-board *level-2*]))

(define *game-frame* (get-frame GUI))

; NOTE: När vi byter bana måste följande hända:
; (send *game-canvas* set-board! --ny-nivå--)
; (send *game-canvas* redraw)
; (set! victory #f)

; Vi måste vänta innan vi kan skicka draw...
(sleep/yield 0.01)
(send *game-canvas* draw)

; Bakgrundsmusik
;(define (play-song)
;  (play-sound "utils/lost-in-a-maze.wav" #t))

;(define *playback-timer* (new timer%
;                              [notify-callback play-song]
;                              [interval 118375]))
;(play-song)

; (send *playback-timer* stop) måste skickas när vi avslutar

