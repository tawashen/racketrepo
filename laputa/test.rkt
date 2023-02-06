#lang racket

(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require 2htdp/image)

#|
(require "util.rkt")
(require "messages.rkt")
(require "enemy.rkt")
(require "item.rkt")
(require "page.rkt")
|#

#;
(define *test1-list*
  '(("A" . 100) ("B" . 200) ("C" . 300)))
(define *hash* (#;#; make-hash *test1-list*))
(define *hash-list* (#;hash-map *hash* (lambda (x y)  (cons x (* y 5)))))
*hash-list*

