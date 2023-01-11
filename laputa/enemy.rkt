#lang racket

(provide (all-defined-out))
(require 2htdp/image)

(struct enemy (Ename Eac Epage Eimage) #:mutable #:transparent) ;モンスター構造体

(define E001 (enemy "兵士1" 9 152 ""))
(define E002 (enemy "兵士2" 10 152 ""))



(define *enemy-list* `(,E001 ,E002))

;*enemy-list*
