#lang racket


(require 2htdp/universe 2htdp/image lang/posn)
;(require srfi/1)
;(require srfi/13)
(require racket/struct)
(require racket/match)
(require "4king-print.rkt")
(require "4king-util.rkt")
(require "4king-data.rkt")
(require "4king-mes.rkt")





(define players '(2 5 7 10))
(define phase-list (circular '(0 1 2 3)))

;整形後のPlayers配置マップを束縛（初期値）
(define players-map (split-list (map align-string (map (lambda (x) (number->string x)) (put-player *player-zero* 1 players))))) 


;テスト用インスタンス類

(define world (WORLD (list SJ DJ HJ CJ) string-map players-map phase-list players #f))




;ここにしか置けない関数

(define (go-direct direct w) ;新たなwを返す予定 COORDとplayer-mapを更新する
  (let ((current ;PLAYER構造体から座標(INT)を束縛
                  (list-ref (WORLD-COORD w) (car (WORLD-PHASE w))))) ;現在のPLYAER構造体を返す
    (cond ((and (string=? direct "r") (ue? current)) (main-eval (change-coord direct w -7)))
          ((and (string=? direct "d") (hidari? current)) (main-eval (change-coord direct w -1)))
          ((and (string=? direct "c") (sita? current)) (main-eval (change-coord direct w 7)))
          ((and (string=? direct "f") (migi? current)) (main-eval (change-coord direct w 1)))
          (else (main-read w)))))



                                                 
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
  (newline)
  (display (format (hash-ref jack-table 'mes-read) (list-ref (WORLD-PLAYERS w) (car (WORLD-PHASE w)))))
  (let ((direct (read-line)))
    (cond ((member direct  '("r" "d" "c" "f")) ((hash-ref jack-table 'direct) direct w))
          (else (main-read w)))))
  
;メインEVAL　移動後イベント発生
(define (main-eval w)
  (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) w))
  (display-map SMAP PMAP '()) (newline)
  (let ((c-card (list-ref *card-list* (list-ref (WORLD-COORD w) (car (WORLD-PHASE w))))))
  (if (CARD-ON c-card)
      ((hash-ref jack-table (CARD-KIND c-card)))
      (main-read (WORLD PLAYERS SMAP PMAP (circular PHASE) COORD WIN)))))) 

(hash-set! jack-table '
  
;メインLOOP　次のプレイヤーか自身の次ターン
;(define (main-loop w))


;(main-print world)
(main-read world)









