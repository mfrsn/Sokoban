;===================================================================
; PRAM 2011, Senast ändrad 2011-04-01
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: GUI.scm
; Beskrivning: Skapar de fönster och objekt som bygger upp vårt GUI.
;===================================================================

(define (make-gui game-canvas-width
                  game-canvas-height
                  game-menu-width
                  game-menu-height)
  ; Vår frame
  (define frame (new frame%
                     [label "Sokoban"]
                     [min-width game-canvas-width]
                     [min-height game-canvas-height]
                     [style '(no-resize-border)]))
  ; Paneler
  (define top-panel (new horizontal-panel%
                         [parent frame]
                         [stretchable-height #f]
                         [alignment '(center top)]))
  
  (define mid-panel (new horizontal-panel%
                         [parent frame]
                         [alignment '(center top)]))
  
  ; Knappar
  (define reset-button (new button%
                            [label "Reset"]
                            [parent top-panel]
                            [callback (lambda (button event)
                                        (reset-level!)
                                        (send game-canvas focus))]))
  
  (define restart-button (new button%
                              [label "Restart"]
                              [parent top-panel]
                              [callback (lambda (button event)
                                          (restart-game!)
                                          (send game-canvas focus))]))
  
  (define main-menu-button (new button%
                                [label "Main menu"]
                                [parent top-panel]
                                [callback (lambda (button event)
                                            (main-menu!)
                                            (send game-canvas focus))]))
  
  (define quit-button (new button%
                           [label "Quit"]
                           [parent top-panel]
                           [callback (lambda (button event)
                                       (quit!))]))
  
  ; Definierar spelets canvas, förs samtidigt in i 'frame'
  (define game-canvas (new game-canvas%
                           [parent mid-panel]
                           [min-width game-canvas-width]
                           [min-height game-canvas-height]))
  
  ; Definierar spelets in-game meny.
  (define game-sidebar (new sidebar-canvas%
                            [parent mid-panel]
                            [min-width game-menu-width]
                            [min-height game-menu-height]))
  
  ; Returnerar game-canvas
  (list frame game-canvas game-sidebar))

; Selektorer
(define (get-game-frame GUI)
  (car GUI))

(define (get-game-canvas GUI)
  (cadr GUI))

(define (get-sidebar-canvas GUI)
  (caddr GUI))


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
                                           (next-level!)
                                           (send win-dialog show #f))]))

(define quit-button (new button%
                         [label "Quit"]
                         [parent win-dialog-panel]
                         [callback (lambda (button event)
                                     (send win-dialog show #f)
                                     (send *game-frame* show #f))]))

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
                         [min-width 60]
                         [callback (lambda (button event)
                                     (set! *player-name* (send name-field get-value))
                                     (send player-name-dialog show #f)
                                     (send *game-canvas* focus))]))


  