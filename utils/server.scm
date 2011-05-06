;================================================================
; PRAM 2011
; Senaste ändring: gort servern trådad 2011-05-04
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: server.scm
; Beskrivning: Server för highscore-rapportering
;================================================================

(require racket/tcp)

(define server%
  (class object%
    (super-new)
    (init-field port-number
                (highscore-list '()))
    
    ;; --------------------------
    ;; Private
    ;; --------------------------
    (define/private (get-highscore-object level)
      (let ((hs-obj (assq level highscore-list)))
        (if (not hs-obj)
            #f
            (cdr hs-obj))))
    
    ; TODO: ordentlig felhantering
    (define (add-score! arg-lst)
      (cond ((not (= (length arg-lst) 3)) #f)
            (else
             (send (get-highscore-object (car arg-lst)) add-entry! (cadr arg-lst) (caddr arg-lst))
             #t)))
    
    ; TODO: ordentlig felhantering
    (define/private (get-highscore arg-lst)
      (let ((hs-obj (get-highscore-object (car arg-lst))))
        (if (not hs-obj)
            'error-downloading-highscore
            (send hs-obj get-scorelist (cadr arg-lst)))))
    
    ;; --------------------------
    ;; Public
    ;; --------------------------
    
    ; NOTE: saknar felhanting, två highscore's med samma level-number ger
    ; odefinierat beteende.
    (define/public (add-highscore! level-number)
      (set! highscore-list (cons (cons level-number (new highscore% [level level-number])) highscore-list)))
    
    (define/public (set-port! new-port)
      (set! port-number new-port))
    
    (define/public (start)
      (define listener (tcp-listen port-number))
      (display "Server running on service port ")
      (display port-number)
      (newline)
      (define (server-loop)
        (define-values (client->server server->client) (tcp-accept listener))
        (let ((arg-lst (read client->server)))
          (close-input-port client->server)
          (cond ((null? arg-lst)
                 (write 'sokoban-highscore-server server->client)
                 (flush-output server->client)
                 (close-output-port server->client)
                 (server-loop))
                
                ((eq? (car arg-lst) 'clear-highscore)
                 (send (get-highscore-object (cadr arg-lst)) clear-highscore!)
                 (write 'highscore-cleared server->client)
                 (flush-output server->client)
                 (close-output-port server->client)
                 (server-loop))
                
                ((eq? (car arg-lst) 'add-score) ; add score
                 (if (add-score! (cdr arg-lst))
                     (begin
                       (write 'score-added server->client)
                       (flush-output server->client))
                     (begin
                       (write 'error-adding-score server->client)
                       (flush-output server->client)))
                 (close-output-port server->client)
                 (server-loop))
                
                ((eq? (car arg-lst) 'get-highscore) ; returnerar highscore
                 (write (get-highscore (cdr arg-lst)) server->client)
                 (flush-output server->client)
                 (close-output-port server->client)
                 (server-loop))
                
                (else ; okänt argument
                 (write 'unknown-server-command server->client)
                 (flush-output server->client)
                 (close-output-port server->client)
                 (server-loop)))))
      (define std (thread server-loop))
      (lambda ()
        (kill-thread std)
        (tcp-close listener)
        (display "Server stopped")))
    
    ))

;; --------------------------
;; Testfall för server
;; --------------------------
;(define test-server (new server% [port-number *port*]))
;
; skapa highscore-listor. TODO: (automatisk numrering?)
;(send test-server add-highscore! 1)
;(send test-server add-highscore! 2)
;(send test-server add-highscore! 3)
;
; server hanterare, kan endast stänga av servern atm
;(define stop-server (send test-server start))