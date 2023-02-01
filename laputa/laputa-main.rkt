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


;サイコロ007関数 test
(define (sai007 env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
                 (display-G "サイコロコロコロ・・")
        (let ((deme (saikoro 2)))
          (if (<= deme Ac)
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (cadr Arg)))
                     (HEK) (main-read
                            (master (cadr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (caddr Arg)))
                     (HEK) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))


(define P006 (pages 006 "SAI006" 0 '(999) (bitmap/file "picture/006.png") '(3 10 053 040)))

;test
(define (sai006 env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
                 (display-G "サイコロコロコロ・・")
        (let ((deme (saikoro (car Arg))))
          (if (<= deme (cadr Arg))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (caddr Arg)))
                     (HEK) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (cadddr Arg)))
                     (HEK) (main-read
                            (master (cadddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))


;(define P022 (pages 022 "SAI22" 0 '(999) (bitmap/file "picture/022.png") '('ZORO '(3 11) 29 34)))

;test
(define (sai022 env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
                 (display-G "サイコロコロコロ・・")
        (let* ((deme1 (saikoro 1)) (deme2 (saikoro 1)) (deme3 (+ deme1 deme2)))
          (if (or (= deme1 deme2) (member deme3 (cdr Arg)))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu2 *main-messages*)) deme1 deme2 (caddr Arg)))
                (HEK) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu2 *main-messages*)) deme1 deme2 (caddr Arg)))
                (HEK) (main-read
                            (master (cadddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))


;(define P033 (pages 033 "KAKU" 0 '(999) (bitmap/file "picture/033.png") '(1 '(3 4 5) 20 54)))

;test
(define (sai033 env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
                 (display-G "サイコロコロコロ・・")
        (let ((deme (saikoro (car Arg))))
          (if (member deme (cadr Arg))
             (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (caddr Arg)))
                     (HEK) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
              (begin (HEK) (display-G (format (cdr (assoc 'kakuritu *main-messages*)) deme (cadddr Arg)))
                     (HEK) (main-read
                            (master (cadddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))            

;test
(define (sai153 env) 
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
                 (display-G "サイコロコロコロ・・")
        (let ((deme (saikoro 1)))
          (case deme
            ((1 2 3) (main-read (master (car C-list) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track))))
            ((4 5) (main-read (master (cadr C-list) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track))))
            ((6) (main-read (master (caddr C-list) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track)))))))))


 
;ステータスチェック関数 test
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
       
;YESNO関数 test
(define (yes-no env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
        (newline)
        (let ((yesno (read)))
          (case yesno
            (('y) (main-read
                            (master (cadr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
            (('n) (main-read
                            (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track))))
            (else (yes-no env)))))))



;数字入力関数 test
(define (input-num env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
           (newline)
               (let ((num (string->number (input (format (cdr (assoc 'input *main-messages*)))))))
                     (cond (((compose not member) num C-list)
                             (display (format (cdr (assoc 'miss *main-messages*)))) (newline) (HEK)
                             (input-num env))
                          (else (main-read
                                 (master (cadr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage #t Cturn Choice (cons Page Track)))))))))



;(define P151 (pages 151 "G" 0 '(156) (bitmap/file "picture/151.png") '(("ブラックジャック" . 1))))

;アイテムゲット関数 test
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


;アイテムドロップ関数 test
(define (drop-item env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
           (newline) (display (format (cdr (assoc 'droped *main-messages*)) (car Arg)))
           (HEK)
           (let ((new-equip 
           (match-let ((`(,index . ,val) (assoc (car Arg) Equip)));ArgのCarをキーにしてEquipから連想リストの形でLetする
             (alist-cons index (+ (cdr Arg) val) (alist-delete index Equip))))) 
           (main-read (master Page Hp Ac Buki Bougu new-equip Enemies Cdamage Event Cturn Choice Track))))))

(define (drop-itemT env) ;test
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
           (newline) (display (format (cdr (assoc 'droped *main-messages*)) (car Arg)))
           (HEK)
           (let ((new-equip
                  (map (lambda (x) (if (assoc (car x) Equip)
                                       (alist-cons `,(car x) (+ (cdr (assoc (car x) Equip)) (cdr x)) (alist-delete (car x) Equip))
                                       Equip)))))
              (main-read (master Page Hp Ac Buki Bougu new-equip Enemies Cdamage Event Cturn Choice Track))))))


;アイテムチェック関数 test
(define (item-check env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
        (if (>= 1 (cdr (assoc (car Arg) Equip)))
            (main-read (master (cadr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track)))
            (main-read (master (caddr Arg) Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track)))))))

;HPAC関数 test
(define (hp-ac env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
        (match Arg
          ((list hp ac)
           (main-read (master Page (+ Hp hp) (+ Ac ac) Buki Bougu Equip Enemies Cdamage #f Cturn Choice Track)))
          ((list hp ac item val)
           (main-read (master Page (+ Hp hp) (+ Ac ac) Buki Bougu
                   (equip-change Equip item val) Enemies Cdamage #f Cturn Choice Track)))))))

;END関数 test
(define (end env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
                   (display-G "おびただしいりゅうけつ！　あたなはしにました"))))


;(define P125 (pages 125 "RESET" 0 '(102) (bitmap/file "picture/125.png") '("スパナ" "モンキー" "レンチ")))

;RESET-Buki関数 test
(define (reset env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
        (map (lambda (x) (alist-cons x 1 (alist-delete x Equip))) Arg))))


;(define P253 (pages 253 "SAIDO" 0 '(246) (bitmap/file "picture/253.png") '(220 246)))

;SAIDO関数 test
(define (saido env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
        (for-each display (map (match-lambda (`(,index . ,page) (format "[~a:~a]" index page))) Arg))
        (let ((num (read)))
          (cond (((compose not number?) num) saido env)
                 ((> num (length Arg)) saido env)
                 ((<= num 0) saido env)
                 (else (main-read (master (list-ref Arg (- num 1))
                                          Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice (cons Page Track)))))))))


;(define P241 (pages 241 "CS" 0 '(254 226 222) (bitmap/file "picture/241.png") '("ランチャーの弾")))
;ランチャー選択肢特殊処理関数
(define (special-check env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
      (match-let (((pages Page-num Flag Ppage C-list Pimage Arg)
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
        (if (>= 0 (cdr (assoc (car Arg) Equip))) ;ランチャーの弾が切れてれば行った所のみ選択可能
      ;  (cond
       ;   ((>= 0 (cdr (assoc (car Arg) Equip)))
            (begin
      (for-each display (map (match-lambda (`(,index . ,num) (format "[~a:~a]" index num)))
                                           (enumerate (filter (lambda (x) (member x Track)) C-list) 1)))
        (newline)
        (let ((num (read)))
          (case num
            ((compose not number) (special-check env))
            ((or (<= num 0) (> num (length (filter (lambda (x) (member x Track)) C-list)))) (special-check env))
            (else (master (list-ref (filter (lambda (x) (member x Track)) C-list) (- num 1))
                          Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track)))))
         ;  (else 
           (begin
              (for-each display (map (match-lambda (`(,index . ,num) (format "[~a:~a]" index num)))
                                           (enumerate C-list) 1))
               (let ((num (read)))
          (case num
            ((compose not number) (special-check env))
            ((or (<= num 0) (> num (length (filter (lambda (x) (member x Track)) C-list)))) (special-check env))
            (else (master (list-ref (filter (lambda (x) (member x Track)) C-list) (- num 1))
                          Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track)))))))))
            


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

;バトルREAD OK
(define (battle-read env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
  (if (null? Enemies)
              (main-read (master Page Hp Ac '() Bougu (equip-change Equip (item-Iname Buki) -1) '() 0 #f 1 0 Track))
         (begin (HEK)
                (display-G (format "~aが現れた!~%" (enemy-Ename (car Enemies))))
                (display (enemy-Eimage (car Enemies))) (newline) (wait)
             (if (= 259 Page) ;ムスカのページだったら専用Evalへ
               (battle-eval-M (master Page Hp Ac Buki Bougu Equip Enemies 0 #t Cturn 0 Track))
               (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies 0 #t Cturn 0 Track))))))))

;バトルEVAL&PRINT ムスカ用 test
(define (battle-eval-M env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
          (let ((tama (cdr (assoc "ランチャーの弾" Equip))))
            (if (> tama 0)
                (display (format "[1:武器で殴りかかる] [2:ランチャーをぶっ放す]") (newline)
                (let ((num (read)))
                (case num
            ((compose not number) (special-check env))
            ((or (<= num 0) (> num (length (filter (lambda (x) (member x Track)) C-list)))) (special-check env))
            ((= num 2) (display-G (cdr (assoc 'damagep *battle-messages*))) (HEK)
                                    (battle-loop (master Page Hp Ac Buki Bougu Equip Enemies (+ 1 Cdamage) Event (+ 1 Cturn) Choice Track)))
            (else ;通常戦闘と一緒
             (let ((pazuP (+ Ac (item-Point Buki) (random 1 7))) (enemyP (+ (enemy-Eac (car Enemies)) (random 1 7))))
            (display-G (format (cdr (assoc 'attack *battle-messages*)) (enemy-Ename (car Enemies)))) (sleep 1)
            (cond ((= pazuP enemyP) (display-G (cdr (assoc 'tie *battle-messages*))) (HEK)
                                    (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track)))
                  ((> pazuP enemyP) (display-G (cdr (assoc 'damagep *battle-messages*))) (HEK)
                                    (battle-loop (master Page Hp Ac Buki Bougu Equip Enemies (+ 1 Cdamage) Event (+ 1 Cturn) Choice Track)))
                  (else((display-G (cdr (assoc 'damagedp *battle-messages*))) (HEK)
                                    (battle-loop (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event (+ 1 Cturn) (+ 1 Choice) Track))))))))))
            
          (let ((pazuP (+ Ac (item-Point Buki) (random 1 7))) (enemyP (+ (enemy-Eac (car Enemies)) (random 1 7))))
            (display-G (format (cdr (assoc 'attack *battle-messages*)) (enemy-Ename (car Enemies)))) (sleep 1)
            (cond ((= pazuP enemyP) (display-G (cdr (assoc 'tie *battle-messages*))) (HEK)
                                    (battle-eval (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track)))
                  ((> pazuP enemyP) (display-G (cdr (assoc 'damagep *battle-messages*))) (HEK)
                                    (battle-loop (master Page Hp Ac Buki Bougu Equip Enemies (+ 1 Cdamage) Event (+ 1 Cturn) Choice Track)))
                  (else((display-G (cdr (assoc 'damagedp *battle-messages*))) (HEK)
                                    (battle-loop (master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event (+ 1 Cturn) (+ 1 Choice) Track)))))))))))


        
;バトルEVAL＆PRINT OK
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

;バトルLOOP OK
(define (battle-loop env)
  (match-let (((master Page Hp Ac Buki Bougu Equip Enemies Cdamage Event Cturn Choice Track) env))
        (match-let (((pages Page-num Flag Ppage C-list Pimage Arg) 
                     (car (filter (lambda (x) (= (pages-Page-num x) Page)) page-list))))
          (if (= Cturn Arg)
              (if (> Cdamage Choice)
                (begin (display-G (format (cdr (assoc 'win *battle-messages*)) (enemy-Ename (car Enemies))))
                                        (battle-read (master Page Hp Ac Buki Bougu Equip (cdr Enemies) 0 Event 0 0 Track)))
                (main-read (master (cadr C-list) Hp Ac '() Bougu (equip-change Equip (item-Iname Buki) -1) '() 0 Event 1 0)))
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


