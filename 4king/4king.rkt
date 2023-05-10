#lang racket


(require 2htdp/universe 2htdp/image lang/posn)
;(require srfi/1)
;(require srfi/13)
(require racket/struct)
(require racket/match)
(require "4king-print.rkt")



(struct CARD (SUIT NUM KIND MES ENEMY ITEM ON COORD) #:transparent)
(struct ENEMY (NAME AT HP ITEM GOLD))
(struct ITEM (NAME COST KIND POWER))
(struct PLAYER (NAME SKILLP HITP MAGICP EQUIP GOLD SPECIAL COORD WIN))
(struct WORLD (C-CARD PLAYERS MAP-S MAP-P PHASE WIN))

;テスト用インスタンス類
(define world (WORLD 'sa '(SJ) string-map players-map 0 #f))
(define SJ (PLAYER "勇者スペードのジャック" '(11 . 11) '(22 . 22) '(9 . 9) 'sord 20 #f #f #f))
(define sord (ITEM "剣" #f 'one-hand-sord 0))
(define rune-blade (ITEM "ルーンブレード" #f 'one-hand-sword 2))
(define zakura (ENEMY "戦士ザクラ" 12 12 rune-blade 0))
(define sa-mes '("untara-kantara"))
(define SA (CARD "S" "A" "BATTLE" 'sa-mes 'zakura "" #t #f))

;;;;;;;;;;;;;;;;;;カードテーブル
(define card-table (make-hash))
(hash-set! card-table 'sa SA)

;;;;;;;;;;;;;;;;;メッセージテーブル
(define mes-table (make-hash))
(hash-set! mes-table 'sa-mes "うんたらかんたら")

;;;;;;;;;;;;;;;;;アイテムテーブル
(define item-table (make-hash))
(hash-set! item-table 'sord sord)

;;;;;;;;;;;;;;;;;アイテム属性テーブル 装備コマンドの時参照する感じ？
(define item-att-table (make-hash))

;;;;;;;;;;;;;;;;;エネミーテーブル
(define enemy-table (make-hash))
(hash-set! enemy-table 'zakura zakura)

;;;;;;;;;;;;;;;;;イベントテーブル
(define event-table (make-hash))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;バトル部分
;(define (battle-print w))
;(define (battle-read w))
;(define (battle-eval w))
;(define (battl-loop w))
;(define battle (lambda (x y) ()))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;メイン部分
;メインPRINT マップ表示                             
(define (main-print w)
  (display-map (WORLD-MAP-S w) (WORLD-MAP-P w) '())
  (display (hash-ref mes-table (CARD-MES (hash-ref card-table (WORLD-C-CARD w))))))
;メインREAD マップの移動入力
;(define (main-read w))
;メインEVAL　移動後イベント発生
;(define (main-eval world event-table key arg))
;メインLOOP　次のプレイヤーか自身の次ターン
;(define (main-loop w))

;(main-print world)










