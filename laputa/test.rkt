#lang racket

(provide (all-defined-out))

(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require 2htdp/image)

(require "laputa-main.rkt")
(require "util.rkt")
(require "messages.rkt")
(require "enemy.rkt")
(require "item.rkt")
(require "page.rkt")

;バトル関数に流し込むページごとの敵構造体のリストを返す
(define (battle-ready-list lst page)
  (if (null? lst)
      '()
      (if (= page (enemy-Epage (car lst)))
          (cons (car lst) (battle-ready-list (cdr lst) page))
          (battle-ready-list (cdr lst) page))))

;特定属性のitem構造体リストを作る
(define (att-list lst att)
  (filter (lambda (a) (string=? att (item-Att a))) lst))

;バトル時に使用可能武器を表示する
(define (buki-list lst) ;lstはmaster-Equip
  ;item構造体のリストを返したい↓
  (filter (lambda (y) ((compose not (compose not member)) (car y) (map item-Iname (att-list *item-list* "Buki"))))
  ;手持ち装備品で0でないものをリストアップしたい↓
  (filter (lambda (x) ((compose not zero?) (cdr x))) lst)))

#|
;バトル時に使用可能なリストを表示する
(define (buki-show lst)
 (for-each display  (map (match-lambda (`(,index . (,name . ,val))
                      (format "[~a:~a]" index name)))
                          (enumerate (buki-list lst) 1))))
|#

;バトルREAD関数
(define (battle-read env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) ;(list-ref *page-list* Page)))
                     (filter (lambda (x) (member Page (pages-Page-num x))) *page-list*)))
  (if (null? Enemies)
      (display "win")
          ; (main-read (master (car C-list) Hp Ac Buki Bougu Equip Enemies 0 #t 1 #f))
         (begin (HEK)
                (display-G (format "~aが現れた!~%" (enemy-Ename (car Enemies))))
                (display (enemy-Eimage (car Enemies))) (newline) (wait) (display "battle start"))))))
               ; (battle-input (master Page Hp Ac Buki Bougu Equip Enemies 0 #t Cturn #f)))))))

(define env (master 152 15 15 '() '() '() '() 0 #t 1 #f))
(battle-read env)