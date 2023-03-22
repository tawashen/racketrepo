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
(define B001 (BUKI "ロングソード" 15 '(1 . 6) '(1 . 8) '(19 . 2) 0 4 1 '()))
(define A001 (ARMOR "チェインメイル" 150 6 2 -5 30 20 15 40))
(define S001 (SIHELD "バックラー" 5 1 0 -1 5 5))
(define I001 (ITEM "やくそう" 10 "HS" 10)) ;回復自分　HS
(define I002 (ITEM "高級薬草" 20 "HS" 20)) ;回復自分　HS
(define I003 (ITEM "投げ薬草" 20 "HO" 10)) ;回復他人も　HO
(define I004 (ITEM "うんこ" 5 "AS" 20)) ;攻撃敵単体 AS
(define M001 (MAGIC "メラ" "AS" 1 "WIZ" 10)) ;攻撃敵単体　AS
(define M002 (MAGIC "イオ" "AC" 3 "SOR" 20)) ;攻撃敵全体　AC
(define M003 (MAGIC "ホイミ" "HO" 1 "CRE" 20)) ;見方単体回復 HO

