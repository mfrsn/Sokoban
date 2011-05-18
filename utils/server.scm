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
(require 2htdp/batch-io)

(load "../datatypes/highscore.scm")

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
    ; arg-lst: (level player-name score)
    (define (add-score! arg-lst)
      (cond ((not (= (length arg-lst) 3)) #f)
            (else
             (send (get-highscore-object (car arg-lst)) add-entry!
                   (cadr arg-lst) (caddr arg-lst))
             #t)))
    
    ; TODO: ordentlig felhantering
    ; arg-lst: (level number-of-entries)
    (define/private (get-highscore arg-lst)
      (let ((hs-obj (get-highscore-object (car arg-lst))))
        (if (not hs-obj)
            'error-downloading-highscore
            (send hs-obj get-scorelist (cadr arg-lst)))))
    
    (define/private (print-connection-info port)
      (define-values (server-addr client-addr) (tcp-addresses port))
      (display "Connection accepted from ")
      (display client-addr)
      (newline))
    
    ;; --------------------------
    ;; Public
    ;; --------------------------
    (define/public (set-port! new-port)
      (set! port-number new-port))
    
    ; NOTE: saknar felhanting, två highscore's med samma level-number ger
    ; odefinierat beteende.
    (define/public (add-highscore! level-number)
      (set! highscore-list
            (cons (cons level-number
                        (new highscore% [level level-number]))
                  highscore-list)))
    
    (define/public (start)
      (define listener (tcp-listen port-number))
      (display "Server running on service port ")
      (display port-number)
      (newline)
      (define (server-loop)
        (define-values (client->server server->client) (tcp-accept listener))
        (print-connection-info client->server)
        (let ((arg-lst (read client->server)))
          (close-input-port client->server)
          (cond ((null? arg-lst)
                 ; tom argument-lista för att testa anslutning
                 (write 'sokoban-highscore-server server->client)
                 (flush-output server->client)
                 (close-output-port server->client)
                 (server-loop))
                
                ; töm en highscorelista
                ; arg-lst: 'clear-highscore level-number
                ((eq? (car arg-lst) 'clear-highscore)
                 (send (get-highscore-object (cadr arg-lst)) clear-highscore!)
                 (write 'highscore-cleared server->client)
                 (flush-output server->client)
                 (close-output-port server->client)
                 (server-loop))
                
                ; rapportera in poäng
                ; arg-lst: 'add-score level player-name score
                ((eq? (car arg-lst) 'add-score)
                 (if (add-score! (cdr arg-lst))
                     (begin
                       (write 'score-added server->client)
                       (flush-output server->client))
                     (begin
                       (write 'error-adding-score server->client)
                       (flush-output server->client)))
                 (close-output-port server->client)
                 (display "Score added.")(newline)
                 (server-loop))
                
                ; hämta highscore
                ; arg-lst 'get-highscore level number-of-entries
                ((eq? (car arg-lst) 'get-highscore)
                 (write (get-highscore (cdr arg-lst)) server->client)
                 (flush-output server->client)
                 (close-output-port server->client)
                 (display "Highscore sent.")(newline)
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
;; Server instantiering
;; --------------------------
(define *port* 23408)

(define highscore-server (new server% [port-number *port*]))

; server hanterare, kan endast stänga av servern atm
(define stop-server (send highscore-server start))

; skapa highscore-listor.
(send highscore-server add-highscore! 0)
(send highscore-server add-highscore! 1)
(send highscore-server add-highscore! 2)
(send highscore-server add-highscore! 3)
(send highscore-server add-highscore! 4)
(send highscore-server add-highscore! 5)
(send highscore-server add-highscore! 6)
