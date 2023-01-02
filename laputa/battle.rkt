#lang racket


(provide (all-defined-out))

(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require 2htdp/image)

(require "util.rkt")
(require "messages.rkt")
(require "monster.rkt")
(require "item.rkt")
(require "page.rkt")


;バトル関数に流し込むページごとの敵構造体のリストを返す
(define (battle-ready-list lst page)
  (if (null? lst)
      '()
      (if (= page (enemy-page (car lst)))
          (cons (car lst) (battle-ready-list (cdr lst) page))
          (battle-ready-list (cdr lst) page))))


;バトルREAD関数
(define (battle-read env)
  (match-let (((Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
        (match-let (((Page-num Flag Ppage C-list Pimage Arg) (list-ref *page-list* Page)))
  (if (null? Enemies)
     (if (not (zero?  (car Arg)))
        (if (< Cturn (car Arg))
           (main-read (master (cadr Arg) Hp Ac Buki Bougu Equip Enemies 0 #t 1 #f))
           (main-read (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies 0 #t 1 #f)))
        (main-read (master Page Hp Ac Buki Bougu Equip Enemies Cdamage #f 1 Choice)))
         (begin (HAK)
    (display-G (format "~aが現れた!~%" (enemy-name (car enemies))))
                (display (enemy-image (car enemies))) (newline) (wait)
  (battle-input (master page ac hp equip enemies 0 #t Cturn #f)))))))

;バトルINPUT関数 次はこの続きから、ただしItem構造体をデザインする
(define (battle-input env) 
  (match-let (((Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
      (display-G (format (cdr (assq 'turn *battle-messages*)) Cturn))
      (display-G (format (cdr (assq 'status *battle-messages*))
                    `(,Ac ,(Item-point Buki) ,Hp))                 
    (newline)
       (let ((num (string->number
                (input (cdr (assq 'select *battle-messages*))))))
         (cond ((> num 2) (battle-input env))
              ((< num 1) (battle-input env))
              (else (battle-eval (master page ac hp equip enemies Cdamage Event Cturn num))))))))

