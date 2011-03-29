(require graphics/graphics)

(open-graphics)

(define frame (new frame%
                   [label "Mah window"]
                   [width 300]
                   [height 300]))

(define msg (new message%
                 [label "Mah message"]
                 [parent frame]
                 [auto-resize #t]))

(define button (new button%
                    [label "Mah button"]
                    [parent frame]
                    [callback (lambda (button event) 
                                (begin
                                  (send msg set-label "Whacha' want mah button?")
                                  (sleep/yield 2)
                                  (send msg set-label "Right, here have a circle!")
                                  (sleep/yield 0.5)
                                  (send dc set-pen (make-object pen% circle-color 5 'solid))
                                  (send dc draw-ellipse 50 15 200 200)
                                  (sleep/yield 1)
                                  (send msg set-label "Mah message")))]))
                 
(define canvas (new canvas%
                    [parent frame]))

(define dc (send canvas get-dc))

(define circle-color (make-object color% 43 127 198))

(send frame show #t)
(sleep/yield 1)

; Arrayskaparfunktion

(define (make-array width height)
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

; Kontrollfunktion för arrays av dimension 2 eller högre.

(define (array? array)
  (or (not (vector? array))
      (not (vector? (vector-ref array 0)))))

; Kontrollfunktion av giltig adress [x,y] i en tvådimensionell array.

(define (valid-address? x y array)
  (or (>= y (vector-length array))
      (>= x (vector-length (vector-ref array 0)))))

; Funktion som returnerar värdet för en 2D-array 'array' på address [x,y].

(define (get-array-value x y array)
  (cond ((array? array)
         (error "Not a valid two dimensional array: " array))
        ((valid-address? x y array)             
         (error "Address is out of bounds." x y))
        (else (vector-ref (vector-ref array y) x))))

; Funktion som för in 'element' på adress [x,y] i en array 'array'.

(define (set-element-array! element x y array)
  (cond ((array? array)
         (error "Not a valid two dimensional array: " array))
        ((valid-address? x y array)             
         (error "Address is out of bounds." x y))
        (else (vector-set! (vector-ref array y) x element))))

(define test (make-array 5 5))
(define test1 (make-vector 3 'a))

(define mah-class%
  (class object%
    ; Initialiseringsvariabler
    (init-field color
                pos)
    ; Variabler
    (field (no-pen (make-object pen% "white" 1 'transparent)))
    ; Metoder
    (define/public (draw)
      (begin
        (send dc set-pen (make-object pen% color 5 'solid))
        (send dc draw-ellipse (posn-x pos) (posn-y pos) 50 50)
        (send dc set-pen no-pen)))
    (super-new)))

(define e1 (new mah-class%
                [color "black"]
                [pos (make-posn 15 15)]))

(define e2 (new mah-class%
                [color "red"]
                [pos (make-posn 70 15)]))

(define e3 (new mah-class%
                [color "green"]
                [pos (make-posn 15 70)]))

(define e4 (new mah-class%
                [color "cyan"]
                [pos (make-posn 70 70)]))

(define circle-array (make-array 2 2))

(set-element-array! e1 0 0 circle-array)
(set-element-array! e2 0 1 circle-array)
(set-element-array! e3 1 0 circle-array)
(set-element-array! e4 1 1 circle-array)

(send e1 draw)
(send e2 draw)
(send e3 draw)
(send e4 draw)

;------------------- Möjligen ny fil -------------------------

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

(define mah-array (new array%
                       [width 4]
                       [height 4]))
