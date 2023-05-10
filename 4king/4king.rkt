#lang racket


(require 2htdp/universe 2htdp/image lang/posn)
;(require srfi/1)
;(require srfi/13)
(require racket/struct)
(require racket/match)
(require "4king-print.rkt")
(require "4king-util.rkt")



(struct CARD (SUIT NUM KIND MES ENEMY ITEM ON COORD) #:transparent)
(struct ENEMY (NAME AT HP ITEM GOLD))
(struct ITEM (NAME COST KIND POWER))
(struct PLAYER (NAME SKILLP HITP MAGICP EQUIP GOLD SPECIAL COORD WIN))
(struct WORLD (PLAYERS SMAP PMAP PHASE WIN))

;テスト用インスタンス類
(define world (WORLD '(SJ) string-map players-map 0 #f))
(define SJ (PLAYER "勇者スペードのジャック" '(11 . 11) '(22 . 22) '(9 . 9) 'sord 20 #f SA #f))
(define sord (ITEM "剣" #f 'one-hand-sord 0))
(define rune-blade (ITEM "ルーンブレード" #f 'one-hand-sword 2))
(define zakura (ENEMY "戦士ザクラ" 12 12 rune-blade 0))
(define SA (CARD "S" "A" "BATTLE" 'mes-sa 'enemy-zakura "" #t #f))


;;;;;;;;;;;;;;;;;;;4人のジャックテーブル
(define jack-table (make-hash))
;;;;;;;;;;;;;;;;;;カードテーブル
;(hash-set! jack-table 'card-sa SA)

;;;;;;;;;;;;;;;;;メッセージテーブル
(hash-set! jack-table 'mes-read "~aのターン　どこへ移動する？北[r] 西[d] 南[c] 東[f]")
(hash-set! jack-table 'mes-sa "うんたらかんたら")

;;;;;;;;;;;;;;;;;アイテムテーブル
(hash-set! jack-table 'item-sord sord)

;;;;;;;;;;;;;;;;;アイテム属性テーブル 装備コマンドの時参照する感じ？


;;;;;;;;;;;;;;;;;エネミーテーブル
(hash-set! jack-table 'enemy-zakura zakura)

;;;;;;;;;;;;;;;;;イベントテーブル
(hash-set! jack-table 'direct go-direct)









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;バトル部分
;(define (battle-print w))
;(define (battle-read w))
;(define (battle-eval w))
;(define (battl-loop w))
;(define battle (lambda (x y) ()))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;メイン部分
;メインPRINT マップ表示                             
;(define (main-map-print w)

  ;(display (hash-ref jack-table (CARD-MES (PLAYER-COORD (WORLD-PLAYERS w))))))
;メインREAD マップの移動入力
(define (main-read w)
  (display-map (WORLD-SMAP w) (WORLD-PMAP w) '())
  (display (format (hash-ref jack-table 'mes-read) (list-ref (WORLD-PLAYERS w) (WORLD-PHASE w))))
  (let ((direct (read-line)))
    (cond ((string=? direct (or "r" "d" "c" "f")) ((hash-ref jack-tale 'direct) direct))
          (else (main-read w)))))
  
;メインEVAL　移動後イベント発生　ゲーム最初は任意の場所からスタートするので初期化後はまずここへ来る
;(define (main-eval world event-table key arg))
;メインLOOP　次のプレイヤーか自身の次ターン
;(define (main-loop w))


;(main-print world)










