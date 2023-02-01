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

;(item-get (master 151 10 10 '() '() *equip* '() 0 #t 1 '() '()))
;*equip*

;サイコロ関数 OK
(define (saikoro times)
  (if (zero? times)
      0
      (+ (random 1 7) (saikoro (- times 1)))))


 ; (map (match-lambda (`(,index . ,page) (format "[~a:~a]" index page)))
     ;          (enumerate '(a b c d e) 1))

 ; (map (lambda (x) (match-let ((`(,index . ,page) x)) (format "[~a:~a]" index page)))
      ;         (enumerate '(a b c d e) 1))


(define c-list '(100 101 102 103))
(define track '(100 103))

    (for-each display (map (match-lambda (`(,index . ,num) (format "[~a:~a]" index num)))
                                           (enumerate (filter (lambda (x) (member x track)) c-list) 1)))



