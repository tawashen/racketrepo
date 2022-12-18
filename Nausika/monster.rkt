#lang racket

(provide (all-defined-out))
(require 2htdp/image)

(struct enemy (name ac hp page human image) #:mutable #:transparent) ;モンスター構造体

(define usiabu18a (enemy  "ウシアブA" 10 20 262 #f (bitmap/file "picture/usiabu1.png"))) ;以下モンスターインスタンス
(define usiabu18b (enemy "ウシアブB" 5 6 262 #f (bitmap/file "picture/usiabu2.png")))
(define eihei44 (enemy "衛兵" 10 9 44 #t (bitmap/file "picture/heisi1.png")))
(define hamusi103a (enemy "翅蟲A" 6 10 235 #f (bitmap/file "picture/hanemusi.png")))
(define hamusi103b (enemy "翅蟲B"6 11 235 #f (bitmap/file "picture/hanemusi.png")))
(define eihei111 (enemy "衛兵"10 9 111 #t (bitmap/file "picture/heisi1.png")))
(define heisi131a (enemy "兵士" 9 9 131 #t (bitmap/file "picture/heisi2.png")))
(define heisi131b(enemy "兵士" 10 8 131 #t (bitmap/file "picture/heisi2.png")))
(define heisi135a (enemy "兵士" 11 10 239 #t (bitmap/file "picture/heisi2.png")))
(define heisi135b (enemy "兵士" 12 10 239 #t (bitmap/file "picture/heisi2.png")))
(define heisi135c (enemy "兵士"12 12 239 #t (bitmap/file "picture/heisi2.png")))
(define eihei162 (enemy "衛兵" 9 9 162 #t (bitmap/file "picture/heisi1.png")))
(define heisi178a (enemy "兵士" 11 9 178 #t (bitmap/file "picture/heisi2.png")))
(define heisi178b (enemy "兵士" 12 10 178 #t (bitmap/file "picture/heisi2.png")))
(define heisi251 (enemy "兵士" 12 10 251 #t (bitmap/file "picture/heisi2.png")))
(define eihei190 (enemy "衛兵" 10 10 190 #t (bitmap/file "picture/heisi1.png")))
(define heisi199a (enemy "兵士" 10 10 199 #t (bitmap/file "picture/heisi2.png")))
(define heisi199b (enemy "兵士" 10 11 199 #t (bitmap/file "picture/heisi2.png")))
(define heisi199c (enemy "兵士" 11 11 199 #t (bitmap/file "picture/heisi2.png")))
(define heisi205a (enemy "兵士" 10 9 205 #t (bitmap/file "picture/heisi2.png")))
(define heisi205b (enemy "兵士" 10 10 205 #t (bitmap/file "picture/heisi2.png")))
(define heisi208 (enemy "兵士" 11 9 208 #t (bitmap/file "picture/heisi2.png")))
(define hamusi277 (enemy "翅蟲A" 6 10 277 #f (bitmap/file "picture/hanemusi.png")))
(define kusyana128 (enemy "クシャナ様" 15 20 128 #t (bitmap/file "picture/kusyana1.png")))

;敵のリスト
(define enemy-list `(
,usiabu18a
,usiabu18b
,eihei44
,hamusi103a
,hamusi103b
,eihei111
,heisi131a
,heisi131b
,heisi135a
,heisi135b
,heisi135c
,eihei162
,heisi178a
,heisi178b
,heisi251
,eihei190
,heisi199a
,heisi199b
,heisi199c
,heisi205a
,heisi205b
,heisi208
,hamusi277
,kusyana128))
