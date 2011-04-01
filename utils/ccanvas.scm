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
    
    ; Override för att hantera tangentbordsevent
    (define/override (on-char event)
      (let ((pressed-key (send event get-key-code)))
        (cond ((eq? pressed-key 'up)
               (display "Du skickade spelaren uppåt!\n"))
              ((eq? pressed-key 'down)
               (display "Du skickade spelaren nedåt!\n"))
              ((eq? pressed-key 'left)
               (display "Du skickade spelaren åt vänster!\n"))
              ((eq? pressed-key 'right)
               (display "Du skickade spelaren åt höger!\n"))
              (else (void)))))
    
    (super-new)))