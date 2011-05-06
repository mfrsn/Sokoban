;================================================================
; PRAM 2011
; Senaste ändring: omskrivning till ett object 2011-05-04
;
; Projekt: Sokoban
; Mattias Fransson, Marcus Eriksson, grupp 4, Y1a
;
; Fil: client.scm
; Beskrivning: Klient till highscore-servern. Se testfall för
; användning.
;================================================================

(require racket/tcp)

(define client%
  (class object%
    (super-new)
    (init-field port-number
                host-address)
    
    ;; --------------------------
    ;; Private
    ;; --------------------------
    
    ; ansluter till servern och skickar arg-lst till den
    (define/private (connect . arg-lst)
      (define-values (server->client client->server) (tcp-connect host-address port-number))
      (write arg-lst client->server)
      (flush-output client->server)
      (let ((response (read server->client)))
        (close-input-port server->client)
        (close-output-port client->server)
        response))
    
    ;; --------------------------
    ;; Public
    ;; --------------------------
    (define/public (set-port! new-port)
      (set! port-number new-port))
    
    (define/public (set-host! new-host)
      (set! host-address new-host))
    
    (define/public (test-connection)
      (connect))
    
    (define/public (clear-highscore! level)
      (connect 'clear-highscore level))
    
    (define/public (upload-score level playername score)
      (connect 'add-score level playername score))
    
    (define/public (download-highscore level number-of-entries)
      (connect 'get-highscore level number-of-entries))
    
    ))

;; --------------------------
;; Testfall för klienten
;; Körs i samband med test-server
;; --------------------------
;(define test-client (new client%
;                         [port-number *port*]
;                         [host-address *host*]))

;(send test-client test-connection)

;(send test-client clear-highscore! 1) ; rensa tidigare värden
;(send test-client clear-highscore! 2)

;(send test-client upload-score 2 "Mattias" 166)
;(send test-client upload-score 2 "Marcus" 167)
;(send test-client upload-score 2 "Malin" 162)
;(send test-client upload-score 2 "Martin" 198)
;(send test-client upload-score 2 "Martina" 209)

;(send test-client upload-score 1 "Peter" 76)
;(send test-client upload-score 1 "Anna" 99)

;(send test-client download-highscore 1 3) ; tre bästa
;(send test-client download-highscore 2 5) ; fem bästa
;(send test-client download-highscore 2 3) ; tre bästa
;(send test-client download-highscore 7 1) ; bana som inte finns