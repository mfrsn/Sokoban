;=====================================================
; PRAM 2011, Senast ändrad 2011-04-01
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: counter.scm
; Beskrivning: Räknarobjekt som håller koll på omgångens
; poäng.
;=====================================================

(define counter%
  (class object%
    
    (init-field (board 'none)) ; Behöver vi vetskap om brädet?
    
    (field (count 0))
    
    ; Se kommentar vid board-fältet..
    (define/public (set-board! new-board)
      (set! board new-board))
    
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
    
    (define/public (report-score level player-name)
      ;(skicka-till-server level player-name count)
      ())
    
    (super-new)))