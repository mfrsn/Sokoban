;=====================================================
; PRAM 2011
; Senaste ändring: filen skapad 2011-04-01
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: counter.scm
; Beskrivning: Räknarobjekt som håller koll på omgångens poäng.
;=====================================================

(define counter%
  (class object%
    
    (init-field (level #f))
    
    (field (count 0))
    
    (define/public (set-level! new-level)
      (set! level (+ new-level 1))
      (reset!))
    
    (define/public (set-count! value)
      (set! count value))
    
    (define/public (increase!)
      (set! count (+ count 1)))
    
    (define/public (decrease!)
      (set! count (- count 1)))
    
    (define/public (reset!)
      (set! count 0))
    
    (define/public (get-count)
      count)
    
    (super-new)))