#lang racket

(require 2htdp/universe 2htdp/image lang/posn)
(require describe)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require "DDDstruct.rkt")
(provide (all-defined-out))



;アイテムインスタンス;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define B001 (BUKI "ロングソード" 15 (random 1 6) (random 1 8) 19 0 4 1 '()))
(define A001 (ARMOR "チェインメイル" 150 6 2 -5 30 20 15 40))
(define S001 (SIHELD "バックラー" 5 1 0 -1 5 5))

