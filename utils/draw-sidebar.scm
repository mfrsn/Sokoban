;====================================================================
; PRAM 2011
; Senaste ändring: Implementerad 2011-04-17
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: menu-canvas.scm
; Beskrivning: Definierar menu-canvas%
;====================================================================

(define draw-sidebar%
  (class object%
    
    (init-field sidebar-canvas)
    
    (field
     (spacing 30)
     (dc (send sidebar-canvas get-dc))
     (canvas-width *game-sidebar-width*)
     (canvas-height *game-sidebar-height*)
     
     ; Palett
     (colour-black (make-object color% 0 0 0))
     (colour-text (make-object color% 215 215 215))
     
     ; Bildfiler
     (background-png (make-object bitmap% "data/textures/background.png"))
     (teleport-icon-png (make-object bitmap% "data/sidebar/teleport-icon.png" 'png/mask))
     (teleport-icon-mask (send teleport-icon-png get-loaded-mask))
     (font (send the-font-list find-or-create-font
                 16 "Arial Rounded MT Bold" 'default 'normal 'normal)))
    
    (send dc set-text-foreground colour-text)
    (send dc set-font font)
    
    (define/private (fill-canvas)
      (send dc draw-bitmap background-png 0 0))
    
    (define/private (draw-teleport-icon position)
      (send dc draw-bitmap teleport-icon-png (get-x-position position)
            (get-y-position position) 'solid colour-black teleport-icon-mask))
    
    (define/private (draw-text)
      (let ((count (send *counter* get-count)))
        (send dc draw-text "Steps" 20 0)
        (send dc draw-text "Power-ups" 3 65)
        (cond ((< count 10)
               (send dc draw-text (number->string count) 42 35))
              ((< count 100)
               (send dc draw-text (number->string count) 37 35))
              (else (send dc draw-text (number->string count) 30 35)))))
        
    
    (define/private (draw-power-ups)
      (let ((power-ups (send *player* get-power-ups))
            (power-up-index 0))
        (define (help power-ups)
          (if (null? power-ups)
              (void)
              (let ((sub-type (send (car power-ups) get-sub-type)))
                (cond ((eq? sub-type 'teleport)
                       (draw-teleport-icon (translate-position power-up-index))
                       (set! power-up-index (+ power-up-index 1))
                       (help (cdr power-ups)))))))
        (help power-ups)))
    
    (define/private (translate-position index)
      (make-position 35 (+ 95 (* index spacing))))
    
    (define/private (refresh)
      (fill-canvas)
      (draw-text)
      (draw-power-ups))
    
    ; Ritar upp sidobaren
    (define/public (draw)
      (refresh))
    
    ; Ritar då huvudmenyn är igång
    (define/public (draw-main-menu)
      (fill-canvas))
    
    (define/public (get-font)
      (send dc get-font))
    
    (super-new)))