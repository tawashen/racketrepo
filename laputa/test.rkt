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

;(assoc "ブラックジャック" '(("ブラックジャック" . 1)))

;master構造体(常に持ち歩く用)
(struct master (Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) #:transparent)


;アイテムゲット関数
(define (item-get env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
           (let ((new-equip 
             (car (map (lambda (x) (if (assoc (car x) Equip)
                                        (alist-cons `,(car (car Arg)) (+ (cdr x) (cdr (assoc (car x) Equip)))
                                              (alist-delete (car x) Equip))
                                        (alist-cons (car Arg) (cdr Arg) Equip))) Arg))))
            (master Page Hp Ac Buki Bougu new-equip Enemies Cdamage #f Cturn Choice Track)))))

(item-get (master 151 10 10 '() '() *equip* '() 0 #t 1 '() '()))
*equip*
