;=====================================================
; PRAM 2011, Senast ändrad 2011-03-XX
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: level-init.scm
; Beskrivning: Laddar in nivå-filerna i board-objekt
;=====================================================

(require 2htdp/batch-io)

; Lager runt read-csv-file för namntydlighet
(define (load-level-file filename)
  (read-csv-file filename))

(define (parse-level-data data *player*)
  (letrec ([map-height (length data)]
           [map-width (length (car data))]
           [level (new board%
                       [size-x map-width]
                       [size-y map-height])])
    
    (define (iter-r row row-list)
      
      (define (iter-c col col-list)
        (if (= col map-width)
            (void)
            (begin (cond ((string=? (car col-list) "w")
                          (add-wall level (make-position col row)))
                         ((string=? (car col-list) "f")
                          (add-floor level (make-position col row)))
                         ((string=? (car col-list) "g")
                          (add-goal level (make-position col row)))
                         ((string=? (car col-list) "b")
                          (add-block level (make-position col row)))
                         ((string=? (car col-list) "x")
                          (add-player level (make-position col row) *player*))
                        (else (error "Unknown building block, given" (car col-list))))
                   (iter-c (+ col 1) (cdr col-list)))))
      
      (cond ((= row map-height) (void))
            (else (iter-c 0 (car row-list))
                  (iter-r (+ row 1) (cdr row-list)))))
    
    (iter-r 0 data)
    level))

(define (create-floor type object)
  (new floor%
       [type type]
       [current-object object]))

(define (create-block position)
  (create-floor 'floor (new block%
                            [current-position position])))

(define (add-floor board position)
  (send board set-square! position (create-floor 'floor 'empty)))

(define (add-wall board position)
  (send board set-square! position (create-floor 'wall 'empty)))
  
(define (add-goal board position)
  (send board set-square! position (create-floor 'goal 'empty))
  ; add to goal-list of board
  )

(define (add-block board position)
  (send board set-square! position (create-block position)))

(define (add-player board position *player*)
  (send board set-square! position (create-floor 'floor *player*))
  (send *player* set-position! position)
  (send *player* set-board! board))