#lang racket

(require racket/struct)
(require racket/match)
(require "4king-data.rkt")

(struct TEST (NAME HP))
(define test (list (TEST "tawa" 30) (TEST "hirokazu" 20)))
(define null-list '())

(define (test-code lst)
   (when (null? lst) (display "end"))
 (for-each display (map (match-lambda (`( ,name ,hit)
                                        (format "[~a:~a]~%" name hit)))
                        (map (lambda (x) `(,(TEST-NAME x) ,(TEST-HP x))) lst))))


;(test-code null-list)
;((compose not number?) 12)

;(define singi #f)
;(cond  ((and (not singi) (= 1 1)) (display "yes")))


(define test-member `((,SJ ,DJ) (list HJ CJ)))

(display (car (car test-member)))

