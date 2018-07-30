#lang racket
(provide tcp-client%)

(require "resp.rkt" racket/tcp)

(define (decode resp)
  (if (not (equal? resp ""))
      (redis-decode resp)
      "ERR timed out"))

(define tcp-client%
  (class object%
    (init-field [ip "127.0.0.1"] [port 6379] [timeout 1])
    (field
     [out null]
     [in null])
    (super-new)

    (define/public (init)
      (define-values (i o) (tcp-connect ip port))
      (set! in i)
      (set! out o))

    (define/private (-send msg)
      (display msg out)
      (flush-output out))

    (define/public (apply-cmd cmd [args null])
      (if (null? args)
          (-send (string-append cmd "\r\n"))

          (-send (redis-encode-array (append (list cmd)
                                            (if (list? args)
                                                args
                                                (list args))))))
      (get-response))

    (define/public (get-response)
      (let loop ([resp ""])
        (let ([p (sync/timeout timeout in)])
          (if (input-port? p)
              (let ([s (read-line p)])
                (if (eof-object? s)
                    (decode resp)
                    (loop (string-append resp s "\n"))))
              (decode resp)))))

    (define/public (set-timeout t) (set! timeout t))))
