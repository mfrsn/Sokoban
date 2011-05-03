;=====================================================
; PRAM 2011, Senast ändrad 2011-04-17
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
                power-up-procedure
                sub-type)
    
    ; Lokala fält
    (field (type 'power-up))
    
    ; #### Public ####
    
    ; Getters
    (define/public (get-position)
      current-position)
    
    (define/public (get-type)
      type)
    
    (define/public (get-sub-type)
      sub-type)
    
    ; Setters
    (define/public (set-position! position)
      (set! current-position position))
    
    (define/public (get-power-up-procedure)
      power-up-procedure)
     
    (super-new)))