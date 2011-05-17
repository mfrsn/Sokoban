;=======================================================
; PRAM 2011
; Senaste ändring: filen skapad 2011-04-01
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: floor.scm
; Beskrivning: Definierar den abstrakta datatypen floor
;=======================================================

; Klass
(define floor%
  (class object%
    
    ; Konstruktorvärden
    (init-field type
                (current-object 'empty))
    
    ; Lokala fält
    (field (current-position #f))
    
    ; #### Public ####
    
    ; Returnerar objektets position på brädet.
    (define/public (get-position)
      current-position)
    
    ; Returnerar objektets typ.
    (define/public (get-type)
      type)
    
    ; Sätter objektets position på brädet till 'position'.
    (define/public (set-position! position)
      (set! current-position position))
    
    ; Returnerar objektet som befinner sig på golvobjektet.
    (define/public (get-object)
      current-object)
    
    ; Sätter objektet som befinner sig på golvobjektet till 'object'.
    (define/public (add-object! object)
      (set! current-object object))
    
    ; Tar bort objektet som befinner sig på golvobjektet.
    (define/public (delete-object!)
      (set! current-object 'empty))
    
    (super-new)))