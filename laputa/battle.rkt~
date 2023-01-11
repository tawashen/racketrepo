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
                (display-G (format "~aが現れた!~%" (enemy-Name (car Enemies))))
                (display (enemy-Eimage (car Enemies))) (newline) (wait)
                (battle-input (master Page Hp Ac Buki Bougu Equip Enemies 0 #t Cturn #f)))))))

;バトルINPUT関数 次はこの続きから、ただしItem構造体をデザインする
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
    (match-let (((Ename Eac Ehp Epage Eimage) (car Enemies)))
    (if (= Choice 1)
      (let ((Cac (+ Ac (item-Point Buki))))
      (let ((damage (- (+ (dice) Cac) (+ (dice) Eac))))
        (cond ((= damage 0)(battle-print
                             (master Page Hp Ac Buki Bougu Equip Enemies 0 Event (+ Cturn 1) Choice)))
             ((> damage 0) (battle-print
                            (master Page Hp Ac Buki Bougu Equip
                                    (cons (enemy Ename Eac (- Ehp (abs damage)) Epage Eimage) (cdr Enemies))
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
