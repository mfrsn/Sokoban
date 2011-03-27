;=================================================
; PRAM 2011, Senast ändrad 2011-03-23
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: vectors.scm
; Beskrivning: Test av vektorer
;=================================================
(require (lib "trace.ss"))

(define array-width 10)
(define array-height 5)

(define array
  (make-vector array-height
               (make-vector array-width 'a)))

(display "Array:\n")
array

(newline)
(display "Ändrar adress 5 i den första vektorn till att innehålla b:\n")
(vector-set! (vector-ref array 0) 5 'b)

array

(display "\nDet verkar som om endast en vektor skapas och varje adress i huvudvektorn pekar på denna.\n")

(define (set-up-array height width)
  (let ((count 1)
        (position 0)
        (max-count (* height width))
        (root-vector (make-vector height 'a)))
    
    ; Skapar varje vektor som ska ligga i rotvektorn
    (define (vector-part)
      (let ((local-vector (make-vector width '()))
            (local-position 0))
        (define (loop)
          (if (= local-position width)
              local-vector
              (begin
                (vector-set! local-vector local-position count)
                (set! local-position (+ local-position 1))
                (set! count (+ count 1))
                (loop))))
        (loop)))
    
    ; Fyller rotvektorn med de vektorer som vektor-part genererar
    (define (loop)
      (if (= position height)
          root-vector
          (begin (vector-set! root-vector position (vector-part))
                 (set! position (+ position 1))
                 (loop))))
    (loop)))

(set! array (set-up-array 10 10))
(display "\nArray:\n")
array

(display "\n Ändrar värdet på adress 5,5 till 'blargh':\n")

(vector-set! (vector-ref array 5) 5 'blargh)

(display "\nArray:\n")
array

(display "SUCCESS!")

