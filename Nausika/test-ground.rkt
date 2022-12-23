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


(define-syntax status-check
    (syntax-rules ()
      ((_ ((pred1 b1 ...) ...))
      (cond (pred1 (begin b1 ...)) ...))))


      
;評価させない式をLmabdaで包んで関数化
(define table `(((< 12 6) "T") ((> 10 6) "A") (else "W")))
;((cdr (assq 'Page181 table)))

table

(define-syntax kakko-tenkai
  (syntax-rules ()
    ((_ ((o n1 n2 sym ...) ...))
     `(((o n1 n2) sym ...) ...))))

(kakko-tenkai ((< 12 5 "T") (> 12 10 "A")))

(define test (kakko-tenkai ((< 12 5 "T") (> 12 10 "A"))))

(status-check test)



(define-syntax begin1
 (syntax-rules ()
  ((_ form1 form ...)
   ((lambda ()
    form1
    (begin0 form ...))))))

;(begin1 1 2)



(define-syntax typecase
 (syntax-rules (else)
  ((_ test-key (else form ...))
   (cond (else form ...)))
  ((_ test-key (type? form ...))
   (when (type? test-key)
    form ...))
  ((_ test-key (type0? form0 ...) (type1? form1 ...) ...)
   (cond ((type0? test-key) form0 ...)
    (else (typecase test-key (type1? form1 ...) ...))))))

#|
(define x '(154))
(typecase x
     (number? (abs x))
         (list? (length x)))
|#