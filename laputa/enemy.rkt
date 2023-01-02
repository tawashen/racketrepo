#lang racket

(provide (all-defined-out))
(require 2htdp/image)

(struct enemy (Ename Eac Ehp Epage Eimage)  #:transparent) ;enemy構造体
