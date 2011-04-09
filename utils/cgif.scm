;==================================================
; PRAM 2011
; Senaste ändring: Skapat klassen gif% 2011-04-09
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: cgif.scm
; Beskrivning: Definierar animeringsklassen gif%
;==================================================

(define gif%
  (class object%
    
    (init-field gif-list    ; Lista med bitmaps%
                delay       ; Angivet i millisekunder
                position    ; Gifens position på canvas
                dc          ; Canvas drawing-context
                background  ; Anger objektets bakgrund på brädet
                style       ; Anger animationens style
                (object #f)); Om animationen sker "ovanpå" spelaren används denna
    
    
    (field (mask-list '())       ; Lista med masks  
           (draw-list gif-list)  ; Lista med alla bilder som utgör gifen
           (drawn-list '())      ; Lista dit redan ritade bilder förs över
           (masked-list '())     ; Lista dit redan använda masks förs över
           (object-mask '())     ; Spelarens mask
           (x-position (get-x-position position)) ; Gifens x-position på canvas
           (y-position (get-y-position position)) ; Gifens y-position på canvas
           (block-size 36)  ; Den konstanta blockstorleken
           (black (make-object color% 0 0 0))) ; En nödvändig definition för utritning med mask
           
    ; #### Private ####
    
    ; Egen appendfunktion som tar ett element och lägger detta sist i en lista
    (define/private (my-append element lst)
      (append lst (list element)))
    
    ; Vänder på en lista
    (define/private (reverse-order lst)
      (if (null? lst)
          '()
          (my-append (car lst) (reverse-order (cdr lst)))))
    
    ; Skapar en lista med masks eftersom gif-list gås igenom
    ; framlänges måste mask-listan byggas "baklänges" för att matcha.
    (define/private (make-mask-list)
      (define (help gif-list)
        (if (null? gif-list)
            '()
            (append (list (send (car gif-list) get-loaded-mask)) (help (cdr gif-list)))))
      (help gif-list))
    
    (define/private (set-up)
      (set! mask-list (make-mask-list))
      (if (not object)
          (void)
          (begin
            (set! object-mask (send object get-loaded-mask))
            (send *game-canvas* enable #f))))
    
    
    ; #### Exekvering ####
    (set-up)
    
    ; TESTSYFTE
    (define/private (draw-all lst y)
      (let ((x-pos 300))
        (define (help lst)
          (if (null? lst)
              (void)
              (begin
                (send dc draw-bitmap (car lst) x-pos y)
                (set! x-pos (+ x-pos 36))
                (help (cdr lst)))))
        (help lst)))
    ; TESTSYFTE
    (define/public (draw-allx)
      (let ((x-pos 300))
        (define (slask gif-list mask-list)
          (if (null? gif-list)
              (void)
              (begin
                (send dc draw-bitmap (car gif-list) x-pos 72 'solid black (car mask-list))
                (set! x-pos (+ x-pos 36))
                (slask (cdr gif-list) (cdr mask-list)))))
        (send dc clear)
        (draw-all mask-list 0)
        (draw-all gif-list 36)
        (slask gif-list mask-list)))
    
    ; Rita
    (define (draw)
      (cond ((null? draw-list)
             (if (eq? style 'continuous)
                 (begin
                   (set! draw-list (reverse-order drawn-list))
                   (set! drawn-list '())
                   (set! mask-list (reverse-order masked-list))
                   (set! masked-list '())
                   (send dc draw-bitmap background x-position y-position)
                   (send dc draw-bitmap (car draw-list) x-position y-position 'solid black (car mask-list)))
                 (begin
                   (send animation-timer stop)
                   (send *game-canvas* enable #t)
                   (send *game-canvas* focus)
                   (send *game-canvas* draw))))
            (else
             (if (not object)
                 (begin
                   (send dc draw-bitmap background x-position y-position)
                   (send dc draw-bitmap (car draw-list) x-position y-position 'solid black (car mask-list)))
                 (begin
                   (send dc draw-bitmap background x-position y-position)
                   (send dc draw-bitmap object x-position y-position 'solid black object-mask)
                   (send dc draw-bitmap (car draw-list) x-position y-position 'solid black (car mask-list))))
             (set! drawn-list (cons (car draw-list) drawn-list))
             (set! draw-list (cdr draw-list))
             (set! masked-list (cons (car mask-list) masked-list))
             (set! mask-list (cdr mask-list)))))
    
    
    ; Animationstimer
    (define animation-timer (new timer% 
                                 [interval delay]
                                 [notify-callback draw]))
    
    ; Stoppa timern
    ;(send animation-timer stop)
    
    ; #### Public ####
    
    (define/public (start-animation)
      (send animation-timer start delay))
    
    (define/public (stop-animation)
      (send animation-timer stop))
    
    (super-new)))


