#lang racket

(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require 2htdp/image)

(require "util.rkt")
(require "messages.rkt")
(require "enemy.rkt")
(require "item.rkt")
(require "page.rkt")


;master構造体(常に持ち歩く用)
(struct master (Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) #:transparent)

;ツール関係;;ページからリスト作成関数
(define (page-lst page)
  (filter (lambda (x) (= page (item-Ipage x))) *item-list*))

;indexからitem構造体を返す関数
(define (return-struct itemlist index)
  (if (null? itemlist)
     '()
     (if (string=? index (item-Iname (car itemlist)))
        (car itemlist)
        (return-struct (cdr itemlist) index))))

;確率関数
(define (kakuritu env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) (list-ref *page-list* Page)))
          (display-G "確率計算の結果・・")
          (if (kakuritu? (car Arg) (cadr Arg))
              (begin (HEK) (format (cdr (assoc 'kakuritu *main-messages*)) (caddr Arg))
                     (HEK) (main-read (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice)))
              (begin (HEK) (format (cdr (assoc 'kakuritu *main-messages*)) (cadddr Arg))
                     (HEK) (main-read (master (cadddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice)))))))
              
              



