;=================================================
; PRAM 2011, Senast ändrad 2011-03-30
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: carray.scm
; Beskrivning: Definierar klassen array%.
;=================================================


(define array%
  (class object%
    ; #### Initialiseringsvariabler ####
    
    (init-field width
                height)
    
    ; #### Private ####
    
    ; Arrayskaparfunktion
    (define/private (make-array width height)
      (let ((root (make-vector width))
            (address-counter 0))
        
        ; Loop som skapar varje element
        (define (loop)
          (let ((vector-element (make-vector height)))
            (if (= address-counter height)
                root
                (begin
                  (vector-set! root
                               address-counter
                               vector-element)
                  (set! address-counter (+ address-counter 1))
                  (loop)))))
        
        (loop)))
    
    ; Kontrollfunktion av giltig adress [x,y] i en tvådimensionell array.
    (define/private (valid-address? x y)
      (not (or (>= y (vector-length array))
               (>= x (vector-length (vector-ref array 0))))))
    
    ; Den lokala arrayen
    (define array (make-array width height))
    
    ; #### Public ####
    
    (define/public (get-width) width)
    (define/public (get-height) height)
    (define/public (get-array) array)
    
    ; Funktion som returnerar värdet för en 2D-array 'array' på address [x,y].
    (define/public (get-element x y)
      (if (valid-address? x y)
          (vector-ref (vector-ref array y) x)
          (error "Address is out of bounds." x y)))
    
    ; Funktion som för in 'element' på adress [x,y] i en array 'array'.
    (define/public (set-element! element x y)
      (if (valid-address? x y) 
          (vector-set! (vector-ref array y) x element)
          (error "Address is out of bounds." x y)))
    
    
    (super-new)))