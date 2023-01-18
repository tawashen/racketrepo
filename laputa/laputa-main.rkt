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

#|
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
   |#          
              

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
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) ;(list-ref *page-list* Page)))
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
            (display (format (cdr (assoc 'select *battle-messages*)))) (newline)
            (buki-show Equip) (newline)
          (let ((Buki-num (string->number (read-line))))
            (cond ((<= Buki-num 0) (battle-set env))
                  ((> Buki-num (length (buki-list Equip))) (battle-set env))
                  (else (display (format "パズーは~aを構えた" (car (list-ref (buki-list Equip) (- Buki-num 1)))))
                        (display "to read")))))))


#|
  (if (null? Enemies)
      (display "win")
          ; (main-read (master (car C-list) Hp Ac Buki Bougu Equip Enemies 0 #t 1 #f))
         (begin (HEK)
                (display-G (format "~aが現れた!~%" (enemy-Ename (car Enemies))))
                (display (enemy-Eimage (car Enemies))) (newline) (wait) (display "start battle"))))))))))))
               ; (battle-input (master Page Hp Ac Buki Bougu Equip Enemies 0 #t Cturn #f)))))))
|#
(define env (master 152 15 15 '() '() *equip* (battle-ready-list *enemy-list* 152) 0 #t 1 #f))
(battle-set env)


