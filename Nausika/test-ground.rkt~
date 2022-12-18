#lang racket

(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)

(require "util/util.rkt")
(require "message.rkt")
(require "monster.rkt")
(require "item.rkt")
(require "page.rkt")


(define (filter-att lst att)
 (newline)
  (for-each display (map (match-lambda (`(,number ,index . ,value)
                                        (format "[~a:~a ~a個]" number index value)))
  (enumerate (filter (lambda (q) ((compose not zero?) (cdr q)))
       (map (lambda (z) (assoc z *equip*)) (map (lambda (x) (item-name x))
             (filter (lambda (y) (string=? att (item-att y))) item-list)))) 0))))
