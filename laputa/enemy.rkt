#lang racket

(provide (all-defined-out))
(require 2htdp/image)

(struct enemy (Ename Eac Epage Eimage) #:mutable #:transparent) ;エネミー構造体

(define E001 (enemy "兵士1" 9 152 ""))
(define E002 (enemy "兵士2" 10 152 ""))
(define E003 (enemy "武装兵1" 15 018001 ""))
(define E004 (enemy "武装兵2" 16 018001 ""))
(define E005 (enemy "武装兵3" 17 018001 ""))
(define E006 (enemy "海賊の男" 12 029001 ""))
(define E007 (enemy "兵士2" 10 1581 ""))
(define E008 (enemy "兵士3" 11 1581 ""))
(define E009 (enemy "兵士1" 9 1582 ""))
(define E010 (enemy "兵士3" 11 1582 ""))
(define E011 (enemy "兵士1" 9 1583 ""))
(define E012 (enemy "兵士2" 10 1583 ""))
(define E013 (enemy "兵士1" 10 1581 ""))
(define E014 (enemy "兵士" 8 163 ""))
(define E015 (enemy "ムスカ" 9 236 ""))
(define E999 (enemy "ムスカ" 12 259 ""))




(define *enemy-list* (list E001 E002 E003 E004 E005 E006 E007 E008 E009 E010 E011 E012 E013 E014 E015 E999))

;*enemy-list*
