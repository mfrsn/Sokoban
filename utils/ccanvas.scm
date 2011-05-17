;=====================================================
; PRAM 2011, Senast ändrad 2011-04-01
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: ccanvas.scm
; Beskrivning: Definierar vår canvasklass.
;=====================================================

; Canvasklassen
(define game-canvas%
  (class canvas%
    
    (define/override (on-char event)
      (handle-key-event (send event get-key-code)))
    
    (define/override (on-event event)
      (handle-mouse-event event))
    
    (super-new)))