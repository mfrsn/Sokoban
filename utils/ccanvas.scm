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
               (send *player* move! 'up))
              ((eq? pressed-key 'down)
               (send *player* move! 'down))
              ((eq? pressed-key 'left)
               (send *player* move! 'left))
              ((eq? pressed-key 'right)
               (send *player* move! 'right))
              (else (void)))
        
        ; Uppdatera brädet
        (send *game-canvas* draw))
      
      ; TEMP vinstloop, *level-2* hårdkodat
      (if (send *level-2* level-complete?)
          (begin
            (play-sound "utils/win-sound.wav" #t)
            (send win-dialog show #t))
          (void)))
    
    (super-new)))