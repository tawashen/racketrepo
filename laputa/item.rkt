#lang racket

(require srfi/1)
(require srfi/13)

(provide (all-defined-out))

(struct item (Iname Cost Ipage Times Point Att) #:transparent)

(define I001 (item "素手" 0 0 0 0 "Arm")) 