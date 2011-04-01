;=============================================================
; PRAM 2011, Senast ändrad 2011-04-01
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: draw.scm
; Beskrivning: Definierar de funktioner som sköter uppritning.
;=============================================================

; Vår frame
(define frame (new frame%
                   [label "Sokoban"]
                   [min-width 600]
                   [min-height 400]))

; Canvas

(define game-canvas%
  (class canvas%
    
    ; Override för att hantera tangentbordsevent
    (define/override (on-char event)
      (let ((pressed-key (send event get-key-code)))
        (cond ((eq? pressed-key 'up)
               (display "Du skickade spelaren uppåt!\n"))
              ((eq? pressed-key 'down)
               (display "Du skickade spelaren nedåt!\n"))
              ((eq? pressed-key 'left)
               (display "Du skickade spelaren åt vänster!\n"))
              ((eq? pressed-key 'right)
               (display "Du skickade spelaren åt höger!\n"))
              (else (void)))))
    
    (super-new)))

; Paneler
(define top-panel (new horizontal-panel%
                       [parent frame]
                       [vert-margin 60]
                       [alignment '(center top)]))

; Knappar
(define button-reset (new button%
                          [label "Reset"]
                          [parent top-panel]
                          [callback (lambda (button event)
                                      (display "Här ska vi resetta nivån!\n"))]))
(define button-quit (new button%
                         [label "Quit"]
                         [parent top-panel]
                         [callback (lambda (button event)
                                     (display "Här ska vi avsluta spelet!\n"))]))
(define button-set-name (new button%
                             [label "Set name"]
                             [parent top-panel]
                             [callback (lambda (button event)
                                         (send player-name-dialog show #t))]))

(define game-canvas (new game-canvas%
                         [parent frame]))

(send frame show #t)

; Interface för spelarens namn
(define player-name "Player")

(define player-name-dialog (new dialog%
                                  [label "Name"]))

(define name-field (new text-field%
                        [parent player-name-dialog]
                        [label "Enter your name"]))

(define dialog-panel (new horizontal-panel%
                          [parent player-name-dialog]
                          [alignment '(center center)]))
; Knappar
(define ok-button (new button%
                       [label "Ok"]
                       [parent dialog-panel]
                       [callback (lambda (button event)
                                   (begin
                                     (set! player-name (send name-field get-value))
                                     (send player-name-dialog show #f)
                                     (display player-name)))]))
(define cancel-button (new button%
                           [label "Cancel"]
                           [parent dialog-panel]
                           [callback (lambda (button event)
                                       (send player-name-dialog show #f))]))