;=====================================================
; PRAM 2011, Senast ändrad 2011-03-30
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
    (init-field current-position)
    
    ; Lokala fält
    (field (on-object #f) ; Ska spelaren hålla reda på objektet den befinner sig på? Framtida användning?
           (type 'player)
           (current-power-up 'empty))
    
    ; #### Private ####
    (define/private (set-position! position)
      (set! current-position position))
    
    ; #### Public ####
    
    ; Getters
    (define/public (position?)
      position)
    
    (define/public (type?)
      type)
    
    ; Setters
    (define/public (set-power-up! power-up)
      (set! current-power-up power-up))
    
    ; Funktioner
    
    ; Flyttar spelaren
    (define/public (move! direction)
      (
       ;... to be defined ...
       ))
    
    (super-new)))