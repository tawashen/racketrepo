#lang racket

(require srfi/1)
(require srfi/13)

(provide (all-defined-out))

(struct item (Iname Cost Ipage Times Point Att) #:transparent)

(define I001 (item "素手" 0 0 0 0 "Buki"))
(define I002 (item "素肌" 0 0 0 0 "Bougu"))
(define I003 (item "スパナ" 0 0 0 2 "Buki"))
(define I004 (item "モンキー" 0 0 0 4 "Buki"))
(define I005 (item "レンチ" 0 0 0 3 "Buki"))
