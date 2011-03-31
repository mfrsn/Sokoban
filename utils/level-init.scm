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
        (cond ((= col map-width) (void))
              (else (send level set-square! (make-position col row) (create-floor 'wall 'empty))
                    (iter-c (+ col 1) (cdr col-list)))))
      
      (cond ((= row map-height) (void))
            (else (iter-c 0 (car row-list))
                  (iter-r (+ row 1) (cdr row-list)))))
    
    (iter-r 0 data)
    level))

; Parsar en data-struktur (lista med listor) och returnerar
; ett board-objekt.
; EJ KLAR!!!!!
(define (parse-level-data-crap data *player*)
  (if (or (null? data) (not(list? data)))
      (error "Invalid level data. Given:" data)
      (let* ((map-height (length data))
             (map-width (length (car data)))
             (level (new board%
                         [size-x (+ map-width 0)]
                         [size-y (+ map-height 0)])))
        
        ; Iterera genom raderna
        (define (iter-rows row row-list)
          
          ; Iterera genom kolonnerna
          (define (iter-cols col col-list)
            (cond ((null? col-list) (newline))
                  ((string=? (car col-list) "w")
                   (add-floor level (make-position col row) (create-floor 'wall 'empty))
                   (iter-cols (+ col 1) (cdr col-list)))
                  ((string=? (car col-list) "f")
                   (add-floor level (make-position col row) (create-floor 'floor 'empty))
                   (iter-cols (+ col 1) (cdr col-list)))
                  ((string=? (car col-list) "g")
                   (add-floor level (make-position col row) (create-floor 'goal 'empty))
                   (iter-cols (+ col 1) (cdr col-list)))
                  ((string=? (car col-list) "v")
                   (add-floor level (make-position col row) (create-floor 'void 'empty))
                   (iter-cols (+ col 1) (cdr col-list)))
                  ((string=? (car col-list) "b")
                   (add-floor level (make-position col row) (create-block (make-position col row)))
                   (iter-cols (+ col 1) (cdr col-list)))
                  ((string=? (car col-list) "x")
                   (add-floor level (make-position col row) (create-floor 'floor *player*)))
                   (iter-cols (+ col 1) (cdr col-list)))
                  )
          
          (cond ((null? row-list) (void))
                (else (begin
                        (iter-cols 0 (car row-list))
                        (iter-rows (+ row 1) (cdr row-list))))))
        
        ; Kör!
        (iter-rows 0 data)
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