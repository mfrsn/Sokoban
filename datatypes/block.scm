;=====================================================
; PRAM 2011
; Senaste ändring: block-klass skapad 2011-03-30
;
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

    ; #### Public ####
    
    ; Setters
    (define/public (set-position! position)
      (set! current-position position))
    
    ; Getters
    (define/public (get-position)
      current-position)
    
    (define/public (get-type)
      type)
    
    (super-new)))