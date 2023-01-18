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


;バトルINPUT関数
(define (battle-input env) 
  (match-let (((Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
      (display-G (format (cdr (assq 'turn *battle-messages*)) Cturn))
      (display-G (format (cdr (assq 'status *battle-messages*))
                    `(,Ac ,(item-Point Buki) ,Hp))                 
    (newline)
       (let ((num (string->number
                (input (cdr (assq 'select *battle-messages*))))))
         (cond ((> num 2) (battle-input env))
              ((< num 1) (battle-input env))
              (else (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn num))))))))


;バトルEVAL関数
(define (battle-eval env) 
  (match-let (((Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
    (match-let (((Ename Eac Epage Eimage) (car Enemies)))
    (if (= Choice 1)
      (let ((Cac (+ Ac (item-Point Buki))))
      (let ((damage (- (+ (dice) Cac) (+ (dice) Eac))))
        (cond ((= damage 0)(battle-print
                             (master Page Hp Ac Buki Bougu Equip Enemies 0 Event (+ Cturn 1) Choice)))
             ((> damage 0) (battle-print
                            (master Page Hp Ac Buki Bougu Equip Enemies                            
                                   damage Event (+ Cturn 1) #f))) ;Choice初期化
             ((< damage 0) (battle-print
                              (master Page (- Hp (- (abs damage) (item-Point Bougu)))
                                       Ac Buki Bougu Equip Enemies damage Event (+ Cturn 1) #f))))))))))


;バトルPRINT関数
(define (battle-print env) 
  (match-let (((Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
    (match-let (((Ename Eac Ehp Epage Eimage) (car Enemies)))
      (cond ((= Cdamage 0) (wait) (display-G (format (cdr (assq 'tie *battle-messages*)))) (wait)
                          (battle-input env))
           ((> Cdamage 0) (display (bitmap/file "picture/hero.png"))(newline)
                          (display-G (format (cdr (assq 'atack *battle-messages*)))) 
                         (newline)(wait) (display-G (format (cdr (assq 'damagep *battle-messages*)) (abs Cdamage))) (wait)
                         (battle-loop env))
           ((< Cdamage 0)  (display Eimage) (newline) (display-G (format (cdr (assq 'atacked *battle-messages*)) Ename)) 
                         (newline)(wait) (display-G (format (cdr (assq 'damagedp *battle-messages*))
                                                            `(,(abs Cdamage) ,(item-Point Bougu)))) (wait) (battle-loop env))))))

;バトルLOOP関数
(define (battle-loop env) 
  (match-let (((Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
    (match-let (((Ename Eac Ehp Epage Eimage) (car Enemies)))
         (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) (list-ref *page-list* Page)))                  
           (cond ((<= Ehp 0)
             (begin (display-G (format (cdr (assq 'win *battle-messages*)) Ename))
                   (battle-read (master Page Hp Ac Buki Bougu Equip (cdr Enemies) 0 Event Cturn #f))))
                 ((<= hp 0) (end env))
           (else (battle-input (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice))))))))
