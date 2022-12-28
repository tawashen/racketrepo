#lang racket

(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require 2htdp/image)
(require lang/posn)

(require "util.rkt")
(require "message.rkt")
(require "monster.rkt")
(require "item.rkt")
(require "page.rkt")

(require 2htdp/universe 2htdp/image)
(define *width* 680)
(define *height* 500)
(define *window* (empty-scene *width* *height* "Medium Gray"))

(define (place-back back scene)
 (if back
  (place-image (bitmap/file back)
       (/ *width* 2)
       (/ *height* 2)
       scene)
  scene))

(define (message-area scene)
 (place-image
  (rectangle 840 100 "solid" "white")
  (/ *width* 2)
  (* (/ *height* 4) 3)
  scene))

#|
(define (change w a-key)
 (cond ((key=? a-key "\r") (world-go w "\r"))
   ((key=? a-key " ") (world-go w " "))
   ((key=? a-key "1") (world-go w "1"))
   ((key=? a-key "2") (world-go w "2"))
   ((key=? a-key "y") (world-go w "y"))
   ((key=? a-key "n") (world-go w "n"))
   ((key=? a-key "up") (world-go w "up"))
   ((key=? a-key "down") (world-go w "down"))
   (else w)))
|#
;(place-back "picture/hikaridama.png" *window*)

;(message-area *window*)

;(define (place-world w)


(define (place-world w)
 (battle-read w))


;(empty-scene *width* *height* "white")

;模擬戦闘ゲームワールド構造体
(struct master (Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR) #:transparent)

;バトル関数に流し込むページごとの敵構造体のリストを返す
(define (battle-ready-list lst page)
  (if (null? lst)
      '()
      (if (= page (enemy-page (car lst))) ;enemy-pageは流用する
          (cons (car lst) (battle-ready-list (cdr lst) page))
          (battle-ready-list (cdr lst) page))))

(define env (master 044 20 20 '("" . 0) '("" . 0) *equip*  (battle-ready-list enemy-list 044) 0 #t 1 #f "" "" ""))


;バトルREAD関数
(define (battle-read env)
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR) env))
  (if (null? Enemies)
      (text "V V V Victory!" 20 "red")
      (begin   
                (place-image  (text (format "~aが現れた!~%" (enemy-name (car Enemies)))
                               20 "green") 50 50 (rectangle 200 200 "solid" "gray"))
                             ; (enemy-image (car Enemies)) 100 100 (rectangle 680 500 "solid" "goldenrod"))
                (battle-input (master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR)))))
 
;バトルINPUT関数
(define (battle-input env) 
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR) env))
      (text (format (cdr (assq 'turn *battle-messages*)) Cturn) 20 "white")
      (text (format (cdr (assq 'statusB *battle-messages*)) (cdr Buki) (cdr Bougu) Hp) 20 "white") ;武器防具は連想リストの予定
    (if (not (enemy-human (car Enemies)))
       (let ((num (string->number ;monsterの場合
                (input (cdr (assq 'selectM *battle-messages*)))))) ;guiでread-lineとかどうなるんだろう？
         (if (number? num)
             (cond ((= num 1) (battle-eval (master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn num BG BR CR)))
              (else (battle-input env)))
             (battle-input env)))
       (let ((num (string->number　;人間タイプの場合
                (input (cdr (assq 'select *battle-messages*))))))
         (cond ((> num 2) (battle-input env))
              ((< num 1) (battle-input env))
              (else (battle-eval (master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn num BG BR CR))))))))


;バトルEVAL関数
(define (battle-eval env) 
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR) env))
    (match-let (((enemy name Eac Ehp Mpage human image) (car Enemies))) ;enemyは流用する
    (if (= Choice 1) ;剣で攻撃
      (let ((Cac (+ Ap (cdr Buki))))       
      (let ((damage (- (+ (dice) Cac) (+ (dice) Eac))))
        (cond ((= damage 0)(battle-print
                             (master Page Hp Ap Buki Bougu Equip Enemies 0 Event (+ Cturn 1) Choice BG BR CR)))
             ((> damage 0) (battle-print
                            (master Page Hp Ap Buki  Bougu Equip
                                   (cons (enemy name Eac (- Ehp (abs damage)) Mpage human image) (cdr Enemies))
                                   damage Event (+ Cturn 1) Choice BG BR CR)))
             ((< damage 0) (battle-print
                              (master Page (- Hp (- (abs damage) (abs (cdr Bougu))))
                                      Ap Buki Bougu Equip Enemies (abs damage) Event (+ Cturn 1) Choice BG BR CR))))))
         (if (equip? Equip "光弾") 
                  (begin (text (format (cdr (assq 'koudan *battle-messages*))) 20 "green")
                         (newline) (place-image (bitmap/file "picture/hikaridama.png") 40 40 (empty-scene *width* *height* "white"))  (newline)
                          (battle-print (master Page Hp Ap Buki Bougu (equip-change Equip "光弾" -1)
                                              (cons (enemy name Eac (- Ehp 3) Mpage human image) (cdr Enemies))
                                              3 Event (+ Cturn 1) Choice BG BR CR)))
                  (begin (text (format (cdr (assq 'tamanasi *battle-messages*))) 20 "green")
                        (battle-print (master Page (- Hp 3) Ap Buki Bougu Equip Enemies -3 Event (+ Cturn 1) Choice BG BR CR))))))))

;バトルPRINT関数
(define (battle-print env) 
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR) env))
    (match-let (((enemy name Eac Ehp Mpage human image) (car Enemies))) ;enemyは流用する
      (cond ((= Cdamage 0) (wait) (text (format (cdr (assq 'tie *battle-messages*))) 20 "green") (wait)
                          (battle-input env))
           ((> Cdamage 0) (place-image (bitmap/file "picture/nausika2.png") 50 50 (empty-scene *width* *height* "white"))
                          (newline) (text (format (cdr (assq 'atack *battle-messages*))) 20 "green") 
                         (newline)(wait) (text (format (cdr (assq 'damagep *battle-messages*)) (abs Cdamage)) 20 "green") (wait)
                         (battle-loop env))
           ((< Cdamage 0)  (place-image image 50 50 (empty-scene *width* *height* "white"))
                           (newline) (text (format (cdr (assq 'atacked *battle-messages*)) name) 20 "green") 
                         (newline)(wait) (text (format (cdr (assq 'damagedp *battle-messages*)) (abs Cdamage)) 20 "green")
                                          (wait) (battle-loop env))))))

;バトルLOOP関数
(define (battle-loop env) 
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR) env))
    (match-let (((enemy name Eac Ehp Mpage human image) (car Enemies))) ;enemyは流用する
         (match-let (((pages Cpage Flag Ppage C-list image arg) (list-ref page-list Page)))
      (if (string?  (car arg)) ;ここからクシャナ戦用判定
         (cond ((<= Ehp 10) (text "victory" 20 "green"))
                ;(main-read (master (cadr arg) Hp Ap Buki Bougu Equip Enemies 0 #t 1 Choice BG BR CR)))
              ((<= Hp 2) (text "lose" 20 "red"))
               ;(main-read (master (caddr arg) Hp Ap Buki Bougu Equip Enemies 0 #t 1 Choice BG BR CR)))
              (else (battle-input (master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR))))                   
      (cond ((<= Ehp 0) ;以前からある通常戦闘用判定
             (begin (text (format (cdr (assq 'win *battle-messages*)) name) 20 "green")
                   (battle-read (master Page Hp Ap Buki Bougu Equip (cdr Enemies) 0 Event Cturn Choice BG BR CR)))
             ((<= Hp 0) (text "lose" 20 "red"))
             ((> Hp 0) (battle-input (master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG  BR CR))))))))))


;(battle-read env)

;(place-image (bitmap/file "picture/hikaridama.png") 200 200 (empty-scene *width* *height* "white"))

 ; (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR)
#|
(big-bang (master 044 15 15 '("" . 0) '("" . 0) *equip* (battle-ready-list enemy-list 044) 0 #t 0 #f "" "" "")
 (to-draw place-world)

 (name "模擬戦闘"))
|#

