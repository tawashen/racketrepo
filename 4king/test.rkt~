#lang racket

(require racket/struct)
(require racket/match)

(struct TEST (NAME HP))
(define test (list (TEST "tawa" 30) (TEST "hirokazu" 20)))
 (for-each display (map (match-lambda (`( ,name ,hit)
                                        (format "[~a:~a]~%" name hit)))
                        (map (lambda (x) `(,(TEST-NAME x) ,(TEST-HP x))) test)))


