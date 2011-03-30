;=====================================================
; PRAM 2011, Senast ändrad 2011-03-30
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: block.scm
; Beskrivning: Definierar ADT:n Block
;=====================================================

; Klass
(define block%
  (class object%
    
    ; Konstruktorvärden
    (init-field current-position)
    
    ; Lokala fält
    (field (type 'block))
    
    ; #### Private ####
    
    ; Setters
    (define/private (set-position! position)
      (set! current-position position))
    
    ; #### Public ####
    
    ; Getters
    (define/public (get-position)
      position)
    
    (define/public (get-type)
      type)
    
    (define/public (move! direction)
      (
       ;... to be defined
       ))
    
    (super-new)))