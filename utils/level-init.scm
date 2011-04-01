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

; Parsar en data-struktur (lista med listor) och returnerar
; ett board-objekt.
; EJ KLAR!!!!!
(define (parse-level-data data *player*)
  (if (or (null? data) (not (list? data)))
      (error "Invalid level data. Given:" data)
      (let* ((map-height (length data))
             (map-width (length (car data)))
             (level (new board%
                         [size-x (+ map-width 0)]
                         [size-y (+ map-height 0)])))
        
        (display map-width)(newline)
        (display map-height)(newline)
        
        (map
         (lambda (row)
           (let ((row-count 0))
             (map
              (lambda (element)
                (let ((col-count 0))
                  (cond ((string=? element "w")
                         (add-floor level (make-position col-count row-count) (create-floor 'wall 'empty)) (set! col-count (+ col-count 1)))
                        ((string=? element "f")
                         (add-floor level (make-position col-count row-count) (create-floor 'floor 'empty)) (set! col-count (+ col-count 1)))
                        ((string=? element "g")
                         (add-floor level (make-position col-count row-count) (create-floor 'goal 'empty)) (set! col-count (+ col-count 1)))
                        ((string=? element "v")
                         (add-floor level (make-position col-count row-count) (create-floor 'void 'empty)) (set! col-count (+ col-count 1)))
                        ((string=? element "b")
                         (add-floor level (make-position col-count row-count) (create-block (make-position col-count row-count))) (set! col-count (+ col-count 1)))
                        ((string=? element "x")
                         (add-floor level (make-position col-count row-count) (create-floor 'floor *player*)))))) row) (set! row-count (+ row-count 1)))) data)
        
        level)))

(define (create-floor type object)
  (new floor%
       [type type]
       [current-object object]))

(define (add-floor board position floor-object)
  (send board set-square! position floor-object))

(define (create-block position)
  (let ((block (new block%
                    [current-position position])))
    (create-floor 'floor block)))