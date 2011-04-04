;===================================================================
; PRAM 2011, Senast ändrad 2011-04-01
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: GUI.scm
; Beskrivning: Skapar de fönster och objekt som bygger upp vårt GUI.
;===================================================================

(define (make-gui width height)
  ; Vår frame
  (define frame (new frame%
                     [label "Sokoban"]
                     [min-width width]
                     [min-height height]
                     [style '(no-resize-border)]))
  ; Paneler
  (define top-panel (new horizontal-panel%
                         [parent frame]
                         [stretchable-height #f]
                         [alignment '(center top)]))
  
  ; Knappar
  (define button-reset (new button%
                            [label "Reset"]
                            [parent top-panel]
                            [callback (lambda (button event)
                                        (display "Här ska vi resetta nivån!\n")
                                        (send game-canvas focus))]))
  
  (define button-restart (new button%
                              [label "Restart"]
                              [parent top-panel]
                              [callback (lambda (button event)
                                          (display "Här ska vi starta om spelet!\n")
                                          (send game-canvas focus))]))
  
  (define button-quit (new button%
                           [label "Quit"]
                           [parent top-panel]
                           [callback (lambda (button event)
                                       (send frame show #f))]))
  
  (define button-set-name (new button%
                               [label "Set name"]
                               [parent top-panel]
                               [callback (lambda (button event)
                                           (send player-name-dialog show #t))]))
  
  ; #### Dialogruta för spelarens namn ####  
  (define player-name-dialog (new dialog%
                                  [label "Name"]))
  
  (define name-field (new text-field%
                          [parent player-name-dialog]
                          [label "Enter your name: "]))
  
  (define dialog-panel (new horizontal-panel%
                            [parent player-name-dialog]
                            [alignment '(center center)]))
  
  ; Knappar
  (define ok-button (new button%
                         [label "Ok"]
                         [parent dialog-panel]
                         [enabled #t]
                         [callback (lambda (button event)
                                     (set! *player-name* (send name-field get-value))
                                     (send player-name-dialog show #f)
                                     (send game-canvas focus))]))
  
  (define cancel-button (new button%
                             [label "Cancel"]
                             [parent dialog-panel]
                             [callback (lambda (button event)
                                         (send player-name-dialog show #f)
                                         (send game-canvas focus))]))
  
  ; Definierar spelets canvas, förs samtidigt in i 'frame'
  (define game-canvas (new game-canvas%
                           [parent frame]
                           [min-width width]
                           [min-height height]))
  
  (send frame show #t)
  
  ; Returnerar game-canvas
  (cons frame game-canvas))

; Selektorer
(define (get-frame GUI)
  (car GUI))

(define (get-canvas GUI)
  (cdr GUI))


; #### Vinstdialog #### Måste vara global för att kunna kalla på
; (send win-dialog show #t) vid vinst.

(define win-dialog (new dialog%
                        [label "Victory!"]
                        [width 200]
                        [alignment '(center center)]
                        [stretchable-width #t]
                        [stretchable-height #f]))

(define win-message (new message%
                         [parent win-dialog]
                         [label "Congratulations! You beat the level!"]))

(define win-dialog-panel (new horizontal-panel%
                              [parent win-dialog]
                              [alignment '(center center)]))

(define next-level-button (new button%
                               [label "Next level"]
                               [parent win-dialog-panel]
                               [callback (lambda (button event)
                                           (load-level (next-level))
                                           (send win-dialog show #f))]))

(define quit-button (new button%
                         [label "Quit"]
                         [parent win-dialog-panel]
                         [callback (lambda (button event)
                                     (send win-dialog show #f)
                                     (send *game-frame* show #f))]))


  