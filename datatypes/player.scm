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
           (current-power-up 'empty)) ; till en procedur som lagras hos spelaren?
    
    ; #### Private ####
    
    
    ; #### Public ####
    
    ; Getters
    (define/public (get-position)
      current-position)
    
    (define/public (get-type)
      type)
    
    ; Setters
    (define/public (set-power-up! power-up)
      (set! current-power-up power-up))
    
    (define/public (set-position! position)
      (set! current-position position))
    
    (define/public (set-board! board)
      (set! current-board board)
      (send board add-player! this))
    
    ; Funktioner
    
    ; Flyttar spelaren
    (define/public (move! direction)
      (send current-board move! this direction))
    
    ; Använder spelarens power-up
    (define/public (use-power-up)
      (if (eq? current-power-up 'empty)
          (error "Called use-power-up with no power-up")
          (begin
            ((send current-power-up get-power-up-procedure))
            (set-power-up! 'empty))))
                     
    
    (super-new)))