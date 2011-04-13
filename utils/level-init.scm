;================================================================
; PRAM 2011
; Senaste ändring: ändrade sättet spelaren läggs till 2011-04-01
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: level-init.scm
; Beskrivning: Laddar in nivå-filerna i board-objekt
;================================================================

; för read-csv-file
(require 2htdp/batch-io)

; Lager runt read-csv-file för namntydlighet.
; Lagrar inläst data i en lista av listor
(define (load-level-file filename)
  (read-csv-file filename))

; Parsar en lista av listor och skapar en
; bana utifrån det. Returnerar sedan nivå-
; objektet.
(define (parse-level-data data)
  (letrec ([map-height (length data)]
           [map-width (length (car data))]
           [level (new board%
                       [size-x map-width]
                       [size-y map-height])])
    
    ; iterera genom raderna (y-koordinater)
    (define (iter-r row row-list)

      ; itererar genom kolonnerna (x-koordinater)
      (define (iter-c col col-list)
        (if (= col map-width)
            (void)
            (begin (cond ((string=? (car col-list) "w")
                          (add-floor level (make-position col row) 'wall))
                         ((string=? (car col-list) "v")
                          (add-floor level (make-position col row) 'void))
                         ((string=? (car col-list) "f")
                          (add-floor level (make-position col row) 'floor))
                         ((string=? (car col-list) "g")
                          (add-goal level (make-position col row)))
                         ((string=? (car col-list) "b")
                          (add-block level (make-position col row)))
                         ((string=? (car col-list) "x")
                          (add-player! level (make-position col row)))
                         ((string=? (car col-list) "pt")
                          (add-powerup level (make-position col row) 'teleport))
                        (else (error "Unknown building block, given" (car col-list))))
                   (iter-c (+ col 1) (cdr col-list)))))
      
      (cond ((= row map-height) (void))
            (else (iter-c 0 (car row-list))
                  (iter-r (+ row 1) (cdr row-list)))))
    
    (iter-r 0 data)
    level))

; Skapar ett golvobjekt
(define (create-floor type object)
  (new floor%
       [type type]
       [current-object object]))

; Skapar ett nytt block och lägger detta på ett
; nytt golvobjekt. Returnerar sedan golvobjektet.
(define (create-block position)
  (create-floor 'floor (new block%
                            [current-position position])))

; Lägger till ett golvobjekt på brädet
(define (add-floor board position type)
  (send board set-square! position (create-floor type 'empty)))
  
; Lägger till ett målområde på brädet
(define (add-goal board position)
  (let ((goal (create-floor 'goal 'empty)))
    (send board set-square! position goal)
    (send board add-to-goal-list! goal)))

; Lägger till ett block+golv på brädet
(define (add-block board position)
  (send board set-square! position (create-block position)))

; Lägger till spelarens position på brädet
(define (add-player! board position)
  (send board set-square! position (create-floor 'floor 'empty))
  (send board set-start-position! position))
  
; Lägger till en power-up
(define (add-powerup board position attribute)
  (cond ((eq? attribute 'teleport)
         (send board set-square! position
               (create-floor 'floor
                             (new power-up%
                                  [current-position position]
                                  [power-up-procedure (lambda ()
                                                        (display "Teleportin mah block"))]
                                  [sub-type 'teleport]))))
         (else (error "Invalid power-up attribute. Given:" attribute))))