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
(define (parse-level-data data)
  (if (or (null? data) (not(list? data)))
      (error "Invalid level data. Given:" data)
      (let* ((map-height (length data))
             (map-width (length (car data)))
             (level (new board%
                         [size-x map-width]
                         [size-y map-height])))
        
        ; Iterera genom raderna
        (define (iter-rows row row-list)
          
          ; Iterera genom kolonnerna
          (define (iter-cols col col-list)
            (cond ((null? col-list) (newline))
                  (else (display (car col-list))
                        (iter-cols (+ col 1) (cdr col-list)))))
          
          (cond ((null? row-list) (void))
                (else (iter-cols 0 (car row-list))
                      (iter-rows (+ row 1) (cdr row-list)))))
        
        ; Kör!
        (iter-rows 0 data))))
    