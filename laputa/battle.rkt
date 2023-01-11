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

;バトル時に使用可能なリストを表示する
(define (buki-show lst)
 (for-each display  (map (match-lambda (`(,index . (,name . ,val))
                      (format "[~a:~a]" index name)))
                          (enumerate (buki-list lst) 1))))


;バトルREAD関数
(define (battle-read env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) (list-ref *page-list* Page)))
  (if (null? Enemies)
           (main-read (master (car C-list) Hp Ac Buki Bougu Equip Enemies 0 #t 1 #f))
         (begin (HAK)
                (display-G (format "~aが現れた!~%" (enemy-Ename (car Enemies))))
                (display (enemy-Eimage (car Enemies))) (newline) (wait)
                (battle-input (master Page Hp Ac Buki Bougu Equip Enemies 0 #t Cturn #f)))))))

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
