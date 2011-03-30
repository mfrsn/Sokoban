;=====================================================
; PRAM 2011, Senast ändrad 2011-03-30
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: power-up.scm
; Beskrivning: Definierar ADT:n Power-up
;=====================================================

(define power-up%
  (class object%
    
    ; Konstruktorvärden
    (init-field current-position
                on-object
                power-up-procedure)
    
    ; Lokala fält
    (field (type 'power-up))
    
    ; #### Private ####
    
    ; Setters
    (define/private (set-position! position)
      (set! current-position position))
    
    ; #### Public ####
    
    ; Getters
    (define/public (get-position)
      current-position)
    
    (define/public (get-type)
      type)
    
    (define/public (get-power-up-procedure)
      power-up-procedure)
    
    ; Funktioner
    
    ; Tar upp power-up:en. Flyttar alltså denna från spelplanen till spelaren. 
    ; **** Remake utifrån vad vi bestämmer ang. lagring hos spelaren ****
    (define/public (take-power-up)
      (send on-object delete-object!)
      (send *player* set-power-up! this)
      (set-position! 'player))
    
    (super-new)))