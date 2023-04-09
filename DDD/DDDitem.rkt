#lang racket

(require 2htdp/universe 2htdp/image lang/posn)
(require describe)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require "DDDstruct.rkt")
(require "DDDutility.rkt")
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
(define M003 (MAGIC "ホイミ" "HO" 1 "CRE" 20)) ;味方単体回復 HO
(define M004 (MAGIC "ベホマラー" "HC" 5 "CRE" 20)) ;味方全体回復 HC


  


(define test-skill `(,sleep-attack ,sleep-attack ,sleep-attack)); ,hit-attack ,hit-attack ,hit-attack ,hit-attack))
(define test-enemy (ENEMY "tawa" (bitmap/file "picture/03.png") "ELF" "FIGHTER" '(0 0 0 0 0 0) 1 '(120 . 100) 10 0 90 '(6 . 6)
                 `(,B001) `(,A001) `(,S001) `((,I001 . 1) (,I002 . 2) (,I003 . 2) (,I004 . 2)) test-skill 10 18 6 11 9 10))
(define test-hero (HERO "tawa" (bitmap/file "picture/03.png") "ELF" "FIGHTER" '(0 0 0 0 0 0) 1 '(120 . 100) 10 0 90 '(6 . 6)
                 `(,B001) `(,A001) `(,S001) `((,I001 . 1) (,I002 . 2) (,I003 . 2) (,I004 . 2)) `((,M001 . 3) (,M002 . 2) (,M003 . 3) (,M004 . 3)) 10 18 6 11 9 10))


