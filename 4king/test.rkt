#lang racket

(require racket/struct)
(require racket/match)
(require "4king-data.rkt")

;(random 3)


(define (list-index num lst count)
  (cond ((null? lst) #f)
         ((= num (car lst)) count)
         (else (list-index num (cdr lst) (+ 1 count)))))

(list-index 3 '(1 2 3 4) 0)
