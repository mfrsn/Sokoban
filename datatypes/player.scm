;=====================================================
; PRAM 2011
; Senaste ändring: set-board! modifierad 2011-04-01
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: player.scm
; Beskrivning: Definierar ADT:n Player
;=====================================================

; Klass
(define player%
  (class object%
    
    ; Konstruktorvariabler
    (init-field current-position
                current-board)
    
    ; Lokala fält
    (field (type 'player)
           (power-ups '())
           (power-up-queue 'empty)) ; Lista som lagrar power-up-procedurer
    
    ; #### Private ####
    
    
    ; #### Public ####
    
    ; Getters
    (define/public (get-position)
      current-position)
    
    (define/public (get-type)
      type)
    
    ; Setters
    (define/public (add-power-up! power-up)
      (set! power-ups (cons power-up power-ups)))
    
    (define/public (set-position! position)
      (set! current-position position))
    
    (define/public (set-board! board)
      (set! current-board board)
      (send board add-player! this))
    
    (define/public (clear-power-up-queue!)
      (set! power-up-queue 'empty))
    
    ; Funktioner
    
    ; Flyttar spelaren
    (define/public (move! direction)
      (send current-board move! this direction))
    
    ; Använder spelarens power-up ; BROKEN!
    (define/public (use-power-up)
      (let* ((power-up (car power-ups))
             (type (send power-up get-type)))
        (cond ((null? power-up-procedures) (display "No power-up")) ; Meddelande om ingen power-up här
              ((eq? type 'teleport)
               (set! power-up-queue (send power-up get-power-up-procedure))
               (set! power-ups (cdr power-ups)))
              (else (error "Unknown power-up type" type)))))
              
              
    (super-new)))