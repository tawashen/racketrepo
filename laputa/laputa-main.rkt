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
(struct master (Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) #:transparent)

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

;(define P007 (pages 007 "SAI007" 0 '(999) (bitmpa/file "picture/007.png") '("Ap" 050 028))

;サイコロ007関数　ここから



;ステータスチェック関数
(define (status-check env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
        (case (car Arg)
          (("Ac") (cond ((>= Ac (car (car (cdr Arg)))) (display-G (format (cdr (assoc 'status *main-messages*))
                                                                    Ac (cdr (car (cdr Arg))))) (HEK)
                             (main-read (master (cdr (car (cdr Arg)))
                                                Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
                        ((>= Ac (car (cadr (cdr Arg)))) (display-G (format (cdr (assoc 'status *main-messages*))
                                                                    Ac (cdr (cadr (cdr Arg))))) (HEK)
                             (main-read (master (cdr (cadr (cdr Arg)))
                                                Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
                        (else (display-G (format (cdr (assoc 'status *main-messages*))
                                                                    Ac (cdr (caddr (cdr Arg))))) (HEK)
                             (main-read (master (cdr (caddr (cdr Arg)))
                                                Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))))))))
        

;サイコロ関数
(define (saikoro times)
  (if (zero? times)
      0
      (+ (random 1 7) (saikoro (- times 1)))))

;確率関数
(define (kakuritu env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) ;(list-ref *page-list* Page)))
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
          (display-G "サイコロコロコロ・・")
        (let ((deme (saikoro (car Arg))))
          (if (<= deme (cadr Arg))
              (begin (HEK) (format (cdr (assoc 'kakuritu *main-messages*)) deme (caddr Arg))
                     (HEK) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
              (begin (HEK) (format (cdr (assoc 'kakuritu *main-messages*)) deme (cadddr Arg))
                     (HEK) (main-read
                            (master (cadddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))

              

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
  (filter (lambda (y) (member (car y) (map item-Iname (att-list *item-list* "Buki"))))
  ;手持ち装備品で0でないものをリストアップしたい↓
  (filter (lambda (x) ((compose not zero?) (cdr x))) lst)))



;バトル時に使用可能なリストを表示する
(define (buki-show lst)
 (for-each display  (map (match-lambda (`(,index . (,name . ,val))
                      (format "[~a:~a]" index name)))
                          (enumerate (buki-list lst) 1))))


;バトルSET関数
(define (battle-set env) 
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) ;(list-ref *page-list* Page)))
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
            (display-G (format (cdr (assoc 'select *battle-messages*)))) (newline)
            (buki-show Equip) (newline)
          (let ((Buki-num (string->number (read-line))))
            (cond ((<= Buki-num 0) (battle-set env))
                  ((> Buki-num (length (buki-list Equip))) (battle-set env))
                  (else (display-G (format "パズーは~aを構えた" (car (list-ref (buki-list Equip) (- Buki-num 1)))))
                       (battle-read (master Page Hp Ac
                                             (car (filter (lambda (buki) (string=? (car (list-ref (buki-list Equip) (- Buki-num 1)))
                                                                              (item-Iname buki))) *item-list*))
                                                            Bougu Equip Enemies Cdamage Event Cturn Choice Track))))))))

;バトルREAD
(define (battle-read env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
  (if (null? Enemies)
              (main-read (master Page Hp Ac '() Bougu (equip-change Equip (item-Iname Buki) -1) '() 0 #f 1 0 Track))
     ; (display-G "WIN")
         (begin (HEK)
                (display-G (format "~aが現れた!~%" (enemy-Ename (car Enemies))))
                (display (enemy-Eimage (car Enemies))) (newline) (wait)
               (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies 0 #t Cturn 0 Track)))))))

;バトルEVAL＆PRINT
(define (battle-eval env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
          (let ((pazuP (+ Ac (item-Point Buki) (random 1 7))) (enemyP (+ (enemy-Eac (car Enemies)) (random 1 7))))
            (display-G (format (cdr (assoc 'attack *battle-messages*)) (enemy-Ename (car Enemies)))) (sleep 1)
            (cond ((= pazuP enemyP) (display-G (cdr (assoc 'tie *battle-messages*))) (HEK)
                                    (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track)))
                  ((> pazuP enemyP) (display-G (cdr (assoc 'damagep *battle-messages*))) (HEK)
                                    (battle-loop (master Page Hp Ac Buki Bougu Equip Enemies (+ 1 Cdamage) Event (+ 1 Cturn) Choice Track)))
                  (else((display-G (cdr (assoc 'damagedp *battle-messages*))) (HEK)
                                    (battle-loop (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event (+ 1 Cturn) (+ 1 Choice) Track)))))))))

;バトルLOOP
(define (battle-loop env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
          (if (= Cturn Arg)
              (if (> Cdamage Choice)
                (begin (display-G (format (cdr (assoc 'win *battle-messages*)) (enemy-Ename (car Enemies))))
                                        (battle-read (master Page Hp Ac Buki Bougu Equip (cdr Enemies) 0 Event 0 0 Track)))
                (display-G "LOSE"))
                ;(main-read (master (cadr C-list) Hp Ac '() Bougu (equip-change Equip (item-Iname Buki) -1) '() 0 Event 1 0)))
              (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track))))))
 

;メインRead関数
(define (main-read env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
          (if (member Page Track)
             (display "main-input"); (main-input env)
              (if (not Event)
                  (display "main-input") ;(main-input env)
              (begin
                (display Pimage)
              (case Flag
                (("B") (battle-set (master Page Hp Ac Buki Bougu Equip
                                            (battle-ready-list *enemy-list* Page)
                                            0 Event 1 Choice Track))))))))))
                                    


(define env (master 152 15 15 '() '() *equip* '() 0 #t 0 0 '(152)))
(main-read env)


