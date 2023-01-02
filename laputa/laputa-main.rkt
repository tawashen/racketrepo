#lang racket

(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require 2htdp/image)

;ツール関係;;ページからリスト作成関数
(define (page-lst page)
  (filter (lambda (x) (= page (item-page x))) item-list))

;indexからitem構造体を返す関数
(define (return-struct itemlist index)
  (if (null? itemlist)
     '()
     (if (string=? index (item-name (car itemlist)))
        (car itemlist)
        (return-struct (cdr itemlist) index))))

;master構造体(常に持ち歩く用)
(struct master (Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn choice) #:transparent)

;バトル関数に流し込むページごとの敵構造体のリストを返す
(define (battle-ready-list lst page)
  (if (null? lst)
      '()
      (if (= page (enemy-page (car lst)))
          (cons (car lst) (battle-ready-list (cdr lst) page))
          (battle-ready-list (cdr lst) page))))

