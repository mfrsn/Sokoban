;===================================================================
; PRAM 2011,
; Senaste ändring: Implementerat kontroll vid restart 2011-05-13
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
  (define frame
    (new frame%
         [label "Sokoban"]
         [min-width game-canvas-width]
         [min-height game-canvas-height]
         [style '(no-resize-border)]))
  ; Paneler
  (define top-panel
    (new horizontal-panel%
         [parent frame]
         [stretchable-height #f]
         [alignment '(center top)]))
  
  (define mid-panel
    (new horizontal-panel%
         [parent frame]
         [alignment '(center top)]))
  
  ; Knappar
  (define reset-button
    (new button%
         [label "Reset"]
         [parent top-panel]
         [callback (lambda (button event)
                     (reset-level!))]))
  
  (define restart-button
    (new button%
         [label "Restart"]
         [parent top-panel]
         [callback (lambda (button event)
                     (if *main-menu-active?*
                         (void)
                         (send restart-affirmation-dialog show #t)))]))
  
  (define main-menu-button
    (new button%
         [label "Main menu"]
         [parent top-panel]
         [callback (lambda (button event)
                     (main-menu!)
                     (send game-canvas focus))]))
  
;  (define mute-button
;    (new button%
;     [label "Mute"]
;     [parent top-panel]
;     [min-width 60]
;     [callback (lambda (button event)
;                 (if *music-on?*
;                     (begin
;                       (set! *music-on?* #f)
;                       (stop-music!)
;                       (send mute-button set-label "Unmute")
;                       (send *game-canvas* focus))
;                     (begin
;                       (set! *music-on?* #t)
;                       (play-music!)
;                       (send mute-button set-label "Mute")
;                       (send *game-canvas* focus))))]))
  
  (define quit-button
    (new button%
         [label "Quit"]
         [parent top-panel]
         [callback (lambda (button event)
                     (quit!))]))
  
  ; Definierar spelets canvas, förs samtidigt in i 'frame'
  (define game-canvas
    (new game-canvas%
         [parent mid-panel]
         [paint-callback (lambda (canvas dc)
                           draw-main-menu)]
         [min-width game-canvas-width]
         [min-height game-canvas-height]))
  
  ; Definierar spelets in-game meny.
  (define game-sidebar
    (new canvas%
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

; Vinstdialog
(define win-dialog
  (new dialog%
       [label "Victory!"]
       [width 200]
       [alignment '(center center)]
       [stretchable-width #t]
       [stretchable-height #f]))

(define win-message
  (new message%
       [parent win-dialog]
       [label "Congratulations! You beat the level!"]))

(define win-dialog-panel
  (new horizontal-panel%
       [parent win-dialog]
       [alignment '(center center)]))

(define next-level-button
  (new button%
       [label "Next level"]
       [parent win-dialog-panel]
       [callback (lambda (button event)
                   (next-level!)
                   (send win-dialog show #f))]))

(define quit-button
  (new button%
       [label "Quit"]
       [parent win-dialog-panel]
       [callback (lambda (button event)
                   (send win-dialog show #f)
                   (send *game-frame* show #f))]))

; #### Dialogruta för spelarens namn ####  
(define player-name-dialog
  (new dialog%
       [label "Name"]))

(define name-field
  (new text-field%
       [parent player-name-dialog]
       [label "Enter your name: "]))

(define dialog-panel
  (new horizontal-panel%
       [parent player-name-dialog]
       [alignment '(center center)]))

; Knappar
(define ok-button
  (new button%
       [label "Ok"]
       [parent dialog-panel]
       [min-width 60]
       [callback (lambda (button event)
                   (let* ((entered-name (send name-field get-value))
                          (name-length (string-length entered-name)))
                     (cond ((= name-length 0)
                            (send name-length-error-message 
                                  set-label "You have to enter your name!")
                            (send name-length-error-dialog show #t))
                           ((> name-length 12)
                            (send name-length-error-message 
                                  set-label "Your name can only be up to 12 characters long!")
                            (send name-length-error-dialog show #t))
                           (else
                            (set! *player-name* entered-name)
                            (send player-name-dialog show #f)
                            (send *game-canvas* focus)))))]))

; Errormeddelande vid namnangivning
(define name-length-error-dialog
  (new dialog%
       [label "Error!"]
       [alignment '(center center)]
       [stretchable-width #t]
       [stretchable-height #f]))

(define name-length-error-message
  (new message%
       [parent name-length-error-dialog]
       [label ""]
       [auto-resize #t]))

(define name-length-error-ok-button
  (new button%
       [parent name-length-error-dialog]
       [label "Ok"]
       [callback (lambda (button event)
                   (send name-length-error-dialog show #f))]))

; Kontrolldialog vid restart
(define restart-affirmation-dialog
  (new dialog%
       [label "Restart"]
       [alignment '(center center)]
       [stretchable-width #t]
       [stretchable-height #f]))

(define restart-affirmation-message
  (new message%
       [parent restart-affirmation-dialog]
       [label "Are you sure?"]))

(define restart-affirmation-button-panel 
  (new horizontal-panel%
       [parent restart-affirmation-dialog]
       [stretchable-width #f]))

(define restart-affirmation-yes-button
  (new button%
       [parent restart-affirmation-button-panel]
       [label "Yes"]
       [callback (lambda (button event)
                   (restart-game!)
                   (send restart-affirmation-dialog show #f))]))

(define restart-affirmation-no-button
  (new button%
       [parent restart-affirmation-button-panel]
       [label "No"]
       [callback (lambda (button event)
                   (send restart-affirmation-dialog show #f)
                   (send *game-canvas* focus))]))

  
