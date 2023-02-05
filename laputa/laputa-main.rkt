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


;master構造体(常に持ち歩く用) OK
(struct master (Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) #:transparent)

;ツール関係;;ページからリスト作成関数 OK
(define (page-lst page)
  (filter (lambda (x) (= page (item-Ipage x))) *item-list*))

;indexからitem構造体を返す関数 OK
(define (return-struct itemlist index)
  (if (null? itemlist)
     '()
     (if (string=? index (item-Iname (car itemlist)))
        (car itemlist)
        (return-struct (cdr itemlist) index))))



;サイコロ関数 OK
(define (saikoro times)
  (if (zero? times)
      0
      (+ (random 1 7) (saikoro (- times 1)))))


;(define P007 (pages 007 "SAI007" 0 '(999) (bitmap/file "picture/007.png") '("Ac" 050 028)))
;サイコロ007関数 OK
(define (sai007 env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
        (newline)
                 (display-G "サイコロコロコロ・・")
        (let ((deme (saikoro 2)))
          (if (>= deme Ac)
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (cadr Arg)))
                     (HEK) (main-read
                            (master (cadr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (caddr Arg)))
                     (HEK) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))


;(define P006 (pages 006 "SAI006" 0 '(999) (bitmap/file "picture/006.png") '(3 10 053 040)))
(define (sai006 env) ;OK
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*)))) (newline)
                 (display-G "サイコロコロコロ・・")
        (let ((deme (saikoro (car Arg))))
          (if (>= deme (cadr Arg))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (caddr Arg)))
                     (HEK) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (cadddr Arg)))
                     (HEK) (main-read
                            (master (cadddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))



;(define P020 (pages 020 "SAI022" 0 '(999) (bitmap/file "picture/020.png") '('ZORO '(3 11) 29 34)))
(define (sai022 env) ;OK
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*)))) (newline)
                 (display-G "サイコロコロコロ・・")
        (let* ((deme1 (saikoro 1)) (deme2 (saikoro 1)) (deme3 (+ deme1 deme2)))
          (if (or (= deme1 deme2) (member deme3 (cdr Arg)))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu2 *main-messages*)) deme1 deme2 (caddr Arg)))
                (HEK) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu2 *main-messages*)) deme1 deme2 (cadddr Arg)))
                (HEK) (main-read
                            (master (cadddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))


;(define P033 (pages 033 "KAKU" 0 '(999) (bitmap/file "picture/033.png") '(1 '(3 4 5) 20 54)))

;test
(define (sai033 env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*)))) (newline)
                 (display-G "サイコロコロコロ・・")
        (let ((deme (saikoro (car Arg))))
          (if (member deme (cadr Arg))
             (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (caddr Arg)))
                     (HEK) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (cadddr Arg)))
                     (HEK) (main-read
                            (master (cadddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))            


(define (sai153 env) ;OK
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*)))) (newline)
        (let ((deme (saikoro 1)))
         (display-G (format (cdr (assoc 'saikoro *main-messages*)) deme)) (HEK)
          (case deme
            ((1 2 3) (main-read (master (car C-list) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track))))
            ((4 5) (main-read (master (cadr C-list) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track))))
            ((6) (main-read (master (caddr C-list) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track)))))))))


(define (saioe env) ;OK
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*)))) (newline)
        (let ((deme (saikoro 1)))
         (display-G (format (cdr (assoc 'saikoro *main-messages*)) deme)) (HEK)
          (if (odd? deme)
              (main-read (master (car Arg) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track)))
              (main-read (master (cadr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track))))))))
 
;ステータスチェック関数 OK
(define (check-status env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
        (newline)
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

;(define P018 (pages 018 "YESNO" 0 '(999) (bitmap/file "picture/018.png") '("戦うか? [y]es or [n]o" 018001 073)))
;YESNO関数 OK
(define (yes-no env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
               (newline) (display-G (format (car Arg)))(newline) 
       (let ((yesno (read)))
          (case yesno
            ((y) (main-read
                            (master (cadr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
            ((n) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
            (else (yes-no env)))))))



;数字入力関数 OK
(define (input-num env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
           (newline)
        (display-G (format (cdr (assoc 'input *main-messages*))))
               (let ((num (read))) 
                     (cond (((compose not member) num C-list)
                             (display (format (cdr (assoc 'miss *main-messages*)))) (newline) (HEK)
                             (input-num env))
                          (else (main-read
                                 (master num Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))



;(define P151 (pages 151 "G" 0 '(156) (bitmap/file "picture/151.png") '(("ブラックジャック" . 1))))
;(define P1391 (pages 1391 "G" 1391 '(079 134) (bitmap/file "picture/139.png") '(("P139の鍵A" . 41) ("P139の鍵B" . 35))))
;アイテムゲット関数 OK
(define (get-itemR env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
     (let ((new-equip
            (let loop ((Equip Equip))
              (if (null? Equip) '()
                  (if (assoc (car (car Equip)) Arg)
                      (alist-cons (car (car Equip)) (+ (cdr (assoc (car (car Equip)) Arg)) (cdr (car Equip)))
                                  (alist-delete (car (car Equip)) (loop (cdr Equip))))
                      (alist-cons (car (car Equip)) (cdr (car Equip)) (loop (cdr Equip))))))))
       (display new-equip)))))


(define (get-itemM env) ;失敗
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
     (let ((new-equip
            (map (lambda (x) (if (assoc (car x) Arg)
                                 (alist-cons (car x) (+ (cdr (assoc (car x) Arg)) (cdr x)) (alist-delete (car x) '()))
                                 (alist-cons (car x) (cdr x) '()))) Arg)))
       (display new-equip)))))

(define (get-item env) ;FOLDR版　成功
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
     (let ((new-equip
            (foldr (lambda (x y) (if (assoc (car x) Arg)
                                 (alist-cons (car x) (+ (cdr (assoc (car x) Arg)) (cdr x)) (alist-delete (car x) y))
                                 (alist-cons (car x) (cdr x) y))) '() Equip)))
       (master Page Hp Ac Buki Bougu new-equip Enemies Cdamage #f Cturn Choice Track)))))


;アイテムドロップ関数 使わない
(define (drop-item env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
           (newline) (display (format (cdr (assoc 'droped *main-messages*)) (car Arg)))
           (HEK)
           (let ((new-equip 
           (match-let ((`(,index . ,val) (assoc (car Arg) Equip)));ArgのCarをキーにしてEquipから連想リストの形でLetする
             (alist-cons index (+ (cdr Arg) val) (alist-delete index Equip))))) 
           (main-read (master Page Hp Ac Buki Bougu new-equip Enemies Cdamage Event Cturn Choice Track))))))

(define (drop-itemT env) ;使わない
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
           (newline) (display (format (cdr (assoc 'droped *main-messages*)) (car Arg)))
           (HEK)
           (let ((new-equip
                  (map (lambda (x) (if (assoc (car x) Equip)
                                       (alist-cons `,(car x) (+ (cdr (assoc (car x) Equip)) (cdr x)) (alist-delete (car x) Equip))
                                       Equip)))))
              (main-read (master Page Hp Ac Buki Bougu new-equip Enemies Cdamage Event Cturn Choice Track))))))

;(define P057 (pages 057 "C" 0 '(999) (bitmap/file "picture/057.png") '("ポムじいさん" 071 048)))
;アイテムチェック関数 OK
(define (check-item env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
        (HEK) (newline)
        (if (<= 1 (cdr (assoc (car Arg) Equip)))
            (main-read (master (cadr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track)))
            (main-read (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track)))))))


;(define P055 (pages 055 "HPAC" 055 '(011) (bitmap/file "picture/055.png") '(0 0 "火薬ビン" . -1)))
;HPAC関数 OK
(define (hp-ac env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
        (match Arg
          ((list hp ac)
           (main-read
           (master Page (if (< 15 (+ Hp hp)) 15 (+ Hp hp)) (if (< 12 (+ Ac ac)) 12 (+ Ac ac))
                   Buki Bougu Equip Enemies Cdamage #f Cturn Choice Track)))
          ((list hp ac item val)
           (main-read
           (master Page (if (< 15 (+ Hp hp)) 15 (+ Hp hp)) (if (< 12 (+ Ac ac)) 12 (+ Ac ac)) Buki Bougu
                   (equip-change Equip item val) Enemies Cdamage #f Cturn Choice Track)))))))

;END関数 OK
(define (end env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
                   (display-G "おびただしいりゅうけつ！　パズーの冒険はここまでだ・・"))))


;(define P125 (pages 125 "RESET" 0 '(102) (bitmap/file "picture/125.png") '("スパナ" "モンキー" "レンチ")))
;RESET-Buki関数 OK
(define (reset env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
        (foldr (lambda (x y) (alist-cons x 1 (alist-delete x y))) Equip Arg))))


;(define P253 (pages 253 "SAIDO" 0 '(246) (bitmap/file "picture/253.png") '(220 246)))
;SAIDO関数 OK
(define (saido env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
        (newline)
        (for-each display (map (match-lambda (`(,index . ,page) (format "[~a:~a]" index page))) (enumerate Arg 1)))
        (newline)
        (let ((num (read)))
          (cond (((compose not number?) num) saido env)
                 ((> num (length Arg)) saido env)
                 ((<= num 0) saido env)
                 (else (main-read (master (list-ref Arg (- num 1))
                                          Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track)))))))))


;(define P241 (pages 241 "SC" 0 '(222) (bitmap/file "picture/241.png") '("ランチャーの弾" . (254 226)))
;ランチャー選択肢特殊処理関数 OK
(define (special-check env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
        (newline)
        (if (>= 0 (cdr (assoc (car Arg) Equip))) ;ランチャーの弾が切れてれば行った所と不要な所のみ選択可能
            (begin
      (for-each display (map (match-lambda (`(,index . ,num) (format "[~a:~a]" index num)))
                                           (enumerate (flatten (cons C-list (filter (lambda (x) (member x (cdr Arg))) Track))) 1)))
        (newline)
        (let ((num (read)))
          (case num
            ((compose not number) (special-check env))
            ((or (<= num 0) (> num (length (flatten (cons C-list (filter (lambda (x) (member x (cdr Arg))) Track)))))) (special-check env))
            (else (master (list-ref (flatten (cons C-list (filter (lambda (x) (member x (cdr Arg))) Track))) (- num 1))
                          Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track)))))
           (begin
              (for-each display (map (match-lambda (`(,index . ,num) (format "[~a:~a]" index num)))
                                           (enumerate (flatten (cons C-list (cdr Arg))) 1))) (newline)
               (let ((num (read)))
          (case num
            ((compose not number) (special-check env))
            ((or (<= num 0) (> num (flatten (length (filter (lambda (x) (member x Track)) C-list))))) (special-check env))
            (else (master (list-ref (flatten (cons C-list (cdr Arg))) (- num 1))
                          Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track)))))))))

;op OK
(define (start)
  (display (bitmap/file "laputa/op01.png"))(HEK)
  (display (bitmap/file "picture/op01.png"))(HEK)
    (display (bitmap/file "picture/op02.png"))(HEK)
    (display (bitmap/file "picture/op3-4.png"))(HEK)
    (display (bitmap/file "picture/op05.png"))(HEK)
    (display (bitmap/file "picture/op6-7.png"))(HEK)
  (main-read (master (001 15 10 '() '() *equip* '() 0 #t 1 '() '()))))
  
 ;(start)


;バトル関数に流し込むページごとの敵構造体のリストを返す OK
(define (battle-ready-list lst page)
  (if (null? lst)
      '()
      (if (= page (enemy-Epage (car lst)))
          (cons (car lst) (battle-ready-list (cdr lst) page))
          (battle-ready-list (cdr lst) page))))

;特定属性のitem構造体リストを作る OK
(define (att-list lst att)
  (filter (lambda (a) (string=? att (item-Att a))) lst))

;バトル時に使用可能武器を表示する OK
(define (buki-list lst) ;lstはmaster-Equip
  ;item構造体のリストを返したい↓
  (filter (lambda (y) (member (car y) (map item-Iname (att-list *item-list* "Buki"))))
  ;手持ち装備品で0でないものをリストアップしたい↓
  (filter (lambda (x) ((compose not zero?) (cdr x))) lst)))



;バトル時に使用可能なリストを表示する OK
(define (buki-show lst)
 (for-each display  (map (match-lambda (`(,index . (,name . ,val))
                      (format "[~a:~a]" index name)))
                          (enumerate (buki-list lst) 1))))


;バトルSET関数 OK
(define (battle-set env) 
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
          (newline)
            (display-G (format (cdr (assoc 'select *battle-messages*)))) 
            (buki-show Equip) (newline)
          (let ((Buki-num (read)))
            (cond ((<= Buki-num 0) (battle-set env))
                  ((> Buki-num (length (buki-list Equip))) (battle-set env))
                  (else (display-G (format "パズーは~aを構えた" (car (list-ref (buki-list Equip) (- Buki-num 1)))))
                       (battle-read (master Page Hp Ac
                                             (car (filter (lambda (buki) (string=? (car (list-ref (buki-list Equip) (- Buki-num 1)))
                                                                              (item-Iname buki))) *item-list*))
                                                            Bougu Equip Enemies Cdamage #t Cturn Choice Track))))))))

;バトルREAD OK
(define (battle-read env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
  (if (null? Enemies)
              (begin (newline) (display-G (format "パズーはすべての敵を打ち倒した！~aへ"　(car C-list))) (HEK)
                     (main-read (master (car C-list) Hp Ac '() Bougu (equip-change Equip (item-Iname Buki) -1) '() 0 #t 1 0 Track)))
         (begin (wait) (newline)
                (display (enemy-Eimage (car Enemies))) (newline)
                (display-G (format "~aが現れた!" (enemy-Ename (car Enemies)))) (newline)
                (sleep 2)
             (case Page-num
                    ((259) (battle-eval-M (master Page Hp Ac Buki Bougu Equip Enemies 0 #t Cturn 0 Track))) ;ムスカ
                     (else (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies 0 #t Cturn 0 Track)))))))))

;バトルEVAL&PRINT ムスカ用 OK
(define (battle-eval-M env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
          (let ((tama (cdr (assoc "ランチャーの弾" Equip))))
            (cond ((> tama 0)
                (begin (display (format "[1:武器で殴りかかる] [2:ランチャーをぶっ放す]")) (newline)
                (let ((num (read)))
                (case num
            ((compose not number) (battle-eval-M env))
            ((or (<= num 0) (> num (length (filter (lambda (x) (member x Track)) C-list)))) (battle-eval-M env))
            ((= num 2) (display (bitmap/file "picture/pazul.png")) (newline)
             (display-G (cdr (assoc 'damagep *battle-messages*))) (sleep 1)
                                    (battle-loop (master Page Hp Ac Buki Bougu
                           (equip-change Equip "ランチャーの弾" -1) Enemies (+ 1 Cdamage) #f (+ 1 Cturn) Choice Track)))
            ((= num 1)
             (battle-eval env))))))
           ((<= tama 0) (battle-eval env)))))))



        
;バトルEVAL＆PRINT OK
(define (battle-eval env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
          (let ((pazuP (+ Ac (item-Point Buki) (random 1 7))) (enemyP (+ (enemy-Eac (car Enemies)) (random 1 7))))
            (display-G (format (cdr (assoc 'attack *battle-messages*)) (enemy-Ename (car Enemies)))) (sleep 1) (newline)
            (display (format "パズー:~a VS ~a:~a~%" pazuP (enemy-Ename (car Enemies)) enemyP)) (sleep 2)
            (cond ((= pazuP enemyP) 
                   (display-G (cdr (assoc 'tie *battle-messages*))) (newline) (sleep 2)
                                    (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track)))
                  ((> pazuP enemyP) (display (bitmap/file "picture/pazu.png")) (newline)
                   (display-G (cdr (assoc 'damagep *battle-messages*))) (newline) (sleep 2) 
                                    (battle-loop (master Page Hp Ac Buki Bougu Equip Enemies (+ 1 Cdamage) Event (+ 1 Cturn) Choice Track)))
                  (else (display (bitmap/file "picture/pazu3.png")) (newline) (sleep 2)
                   (display-G (cdr (assoc 'damagedp *battle-messages*))) (newline) (sleep 2)
                                    (battle-loop (master Page Hp Ac Buki Bougu Equip
                                                         Enemies Cdamage Event (+ 1 Cturn) (+ 1 Choice) Track))))))))

;バトルLOOP OK
(define (battle-loop env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
          (if (or (= Arg Cdamage) (= Arg Choice))
              (if (> Cdamage Choice)
                (begin (display-G (format (cdr (assoc 'win *battle-messages*)) (enemy-Ename (car Enemies))))
                                        (battle-read (master Page Hp Ac Buki Bougu Equip (cdr Enemies) 0 #t 0 0 Track)))
                (begin (display-G (format "パズーは敵に打倒された・・~aへ" (cadr C-list))) (HEK)
                         (main-read (master (cadr C-list) Hp Ac '() Bougu
                                                       (equip-change Equip (item-Iname Buki) -1) '() 0 #t 1 0 Track))))
                   (if (= Page-num 259)
                       (battle-eval-M (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track))
                      (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track)))))))
 

;メインRead関数
(define (main-read env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
          (if (member Page Track)
             (begin (newline) (main-input (master Page Hp Ac Buki Bougu Equip Enemies 0 #f 1 0 Track)))
              (if (not Event)
                  (begin (newline) (main-input (master Page Hp Ac Buki Bougu Equip Enemies 0 #f 1 0 Track)))
              (begin
                (display Pimage)
              (case Flag
                (("B") (battle-set (master Page Hp Ac Buki Bougu Equip
                                            (battle-ready-list *enemy-list* Page)
                                            0 Event 1 Choice Track)))
                (("STATUS") (check-status env))
                (("YESNO") (yes-no env))
                (("NO") (input-num env))
                (("G") (get-item env))
                (("C") (check-item env))
                (("HPAC") (hp-ac env))
                (("END") (end env))
                (("RESET") (reset env))
                (("SAIDO") (saido env))
                (("SC") (special-check env))
                (("SAI007") (sai007 env))
                (("SAI006") (sai006 env))
                (("SAI022") (sai022 env))
                (("SAI033") (sai033 env))
                (("SAI153") (sai153 env))
                (("SAIoe") (saioe env))
                (("N") (main-read (master Page Hp Ac Buki Bougu Equip
                                            '()
                                            0 #f 1 Choice Track))))))))))
                
(define (main-input env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) *page-list*))))
          (display Pimage) (newline)
          (display (format "[基本点:~a] [行動点:~a]~%" Hp Ac))
          (for-each display (cons "[0:アイテムを見る]" (map (match-lambda (`(,index . ,num) (format "[~a:~a]" index num)))
                                 (enumerate C-list 1)))) (newline)
               (let ((num (read)))
                (case num
            ((compose not number) (main-input env))
            ((or (< num 0) (> num (length C-list))) (main-input env))
            ((= 0 num) (for-each display
                                 (filter (lambda (x) ((compose not zero?) (cdr x))) Equip)) (newline)
                       (display "[AnyKey:戻る]") (newline)
                       (let ((end (read)))
                         (cond (((compose not null?) end)  (main-input env)) (else (main-input env)))))
            (else (main-read (master (list-ref C-list (- num 1))
                                     Hp Ac Buki Bougu Equip '() 0 #t 1 0 (cons Ppage Track)))))))))


(define env (master 152 12 10 '() '() *equip* '() 0 #t 0 0 '(254)))
(main-read env)


