#lang racket

;(foldl (lambda (x y) (+ x y)) 0 '(1 2 3 4 5 6))
;(apply + '(1 2 3 4 5 6))


 (struct document (author title content))
(struct book document (publisher))
(struct paper (journal) #:super struct:document)

(define test (book 'tawa 'tawatitle 'tawacontent 'tawajournal))


(define-struct circle (radius)#:reflection-name '<circle>)
(make-circle 15)

