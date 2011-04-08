;================================================================
; PRAM 2011
; Senaste ändring: quicksort implementerad 2011-04-08
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: highscore.scm
; Beskrivning: ADT för en highscorelista. Sorteringsfunktionen
; är en modifierad version av quicksort från laboration 2.
;================================================================

(define highscore%
  (class object%
    (super-new)
    (init-field level
                (scorelist '()))
    
    ;; --------------------------
    ;; Private
    ;; --------------------------
    (define/private (get-player entry)
      (car entry))
    
    (define/private (get-score entry)
      (cadr entry))
    
    (define/private (no-entries? lst)
      (null? lst))
    
    (define/private (get-first-entry lst)
      (car lst))
    
    (define/private (get-rest-entries lst)
      (cdr lst))
    
    ; Sorterar highscore listan efter score. Då man vill ha
    ; så få drag som möjligt ligger låg score först.
    (define/private (sort-highscore!)
      
      ; Delar upp lst i två listor varav lo-lst innehåller alla
      ; entries med lägre score än pivot-entry.
      (define (partition pivot-entry lst)
        (define (iter current-lst lo-lst hi-lst)
          (cond ((null? current-lst)
                 (cons lo-lst hi-lst))
                ((> (get-score (get-first-entry current-lst))
                    (get-score pivot-entry))
                 (iter (get-rest-entries current-lst)
                       lo-lst
                       (cons (get-first-entry current-lst) hi-lst)))
                (else
                 (iter (get-rest-entries current-lst)
                       (cons (get-first-entry current-lst) lo-lst)
                       hi-lst))))
        (iter lst '() '()))
      
      ; Själva sorteringen, returnerar en färdig lista
      (define (quicksort lst)
        (cond ((no-entries? lst) '())
              ((= (length lst) 1) lst)
              (else
               (let ((parts (partition (car lst) (cdr lst))))
                 (append (quicksort (car parts))
                         (list (get-first-entry lst))
                         (quicksort (cdr parts)))))))
      
      (set! scorelist (quicksort scorelist)))
    
    ;; --------------------------
    ;; Public
    ;; --------------------------
    (define/public (add-entry! player score)
      (set! scorelist (cons (list player score) scorelist))
      (sort-highscore!))
    
    (define/public (print-highscore number-of-entries)
      (display "Level ")(display level)(newline))

    ))

;; --------------------------
;; Testfall för highscore ADT
;; --------------------------
(define highscore (new highscore%
                       [level 1]))

(send highscore add-entry! "mattias" 44)
(send highscore add-entry! "marcus" 42)
(send highscore add-entry! "björn" 51)
(send highscore add-entry! "märta" 47)
(send highscore add-entry! "per" 39)