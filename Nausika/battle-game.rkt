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



(define (place-world env)
    (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Mes Cturn Choice BG BR CR) env))
                  (match-let (((pages Cpage Flag Ppage C-list Pimage arg) (list-ref page-list Page)))
                       (match-let (((enemy Name Eac Ehp Mpage Human Eimage) (car Enemies)))
  (place-image Pimage 70 240 
              (place-image (text Mes 20 "red") 120 560
                          (place-image (rectangle 600 140 "solid" "white") 340 600
                                       (place-image Eimage 400 240
                                                   (place-image  (bitmap/file "picture/haikei1.jpeg") 340 250
                                                                (rectangle 680 680 "solid" "goldenrod"))))))))))



                   
              
;模擬戦闘ゲームワールド構造体
(struct master (Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Mes Cturn Choice BG BR CR) #:transparent)

;バトル関数に流し込むページごとの敵構造体のリストを返す
(define (battle-ready-list lst page)
  (if (null? lst)
      '()
      (if (= page (enemy-page (car lst))) ;enemy-pageは流用する
          (cons (car lst) (battle-ready-list (cdr lst) page))
          (battle-ready-list (cdr lst) page))))


;バトルGO関数
(define (battle-go env delta)
    (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Mes Cturn Choice BG BR CR) env))
            (match-let (((pages Cpage Flag Ppage C-list image arg) (list-ref page-list (master-Page env))))
    
              (if (and (string=? "B" Flag) Event) 
                   (cond 
                     ((string=? "\r" delta) (master Page Hp Ap Buki Bougu Equip (battle-ready-list enemy-list Page) Cdamage #f
                                      "start" Cturn 1 BG BR CR)) 
                     (else (master Page Hp Ap Buki Bougu Equip (battle-ready-list enemy-list Page) Cdamage #f
                                      "end" Cturn 1 BG BR CR)))
                   (battle-read (master Page Hp Ap Buki Bougu Equip (battle-ready-list enemy-list Page) Cdamage #t
                                      "other" Cturn 1 BG BR CR))))))
                  


  #|                 
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Mes Cturn Choice BG BR CR) env))
             (match-let (((pages Cpage Flag Ppage C-list image arg) (list-ref page-list Page)))
                   (if (and (string=? Flag "B") Event)
         (battle-read (master Page Hp Ap Buki Bougu Equip (battle-ready-list enemy-list Page) Cdamage Event
                              (format (cdr (assq 'appear *battle-gui-messages*)) (car (car Enemies))) Cturn Choice BG BR CR))
         (battle-input (master Page Hp Ap Buki Bougu Equip (battle-ready-list enemy-list Page) Cdamage Event
                              "end" Cturn Choice BG BR CR))))))
|#

;バトルREAD関数
(define (battle-read env)
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Mes Cturn Choice BG BR CR) env))
             (match-let (((pages Cpage Flag Ppage C-list image arg) (list-ref page-list Page)))
  (if (null? Enemies)
      (text "V V V Victory!" 20 "red")
      
      ;(master Page Hp Ap Buki Bougu Equip (battle-ready-list enemy-list Page) Cdamage #t
       ;                               "end" Cturn 1 BG BR CR)))))
       (battle-input (master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Mes Cturn Choice BG BR CR))))))

 ;なんでBattle-goだけ特別なのか？
                        
 
;バトルINPUT関数
(define (battle-input env delta) 
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Mes Cturn Choice BG BR CR) env))
                (match-let (((pages Cpage Flag Ppage C-list image arg) (list-ref page-list Page)))
                (cond ((string=? "3" delta) (master Page Hp Ap Buki Bougu Equip (battle-ready-list enemy-list Page) Cdamage #t
                               "戦闘開始" Cturn 1 BG BR CR))
                     (else (master Page Hp Ap Buki Bougu Equip (battle-ready-list enemy-list Page) Cdamage #t
                                  "戦闘終了" Cturn 1 BG BR CR))))))

#|
;バトルINPUT関数
(define (battle-input env) 
  (match-let (((master page ac hp equip enemies Cdamage Event Cturn choice) env))
      (display-G (format (cdr (assq 'turn *battle-messages*)) Cturn))
      (display-G (format (cdr (assq 'status *battle-messages*))
                      (cond ((equip? equip "剣") `(,ac "[+2]"))
                        ((equip? equip "短剣") `(,ac "[+1]"))
                        ((equip? equip "短剣(セラミック製)") `(,ac "[+1]"))
                        (else ac)) hp))
    (newline)
    (if (not (enemy-human (car enemies)))
       (let ((num (string->number
                (input (cdr (assq 'selectM *battle-messages*))))))
         (if (number? num)
         (cond ((= num 1) (battle-eval (master page ac hp equip enemies Cdamage Event Cturn num)))
              (else (battle-input env)))
         (battle-input env)))
       (let ((num (string->number
                (input (cdr (assq 'select *battle-messages*))))))
         (cond ((> num 2) (battle-input env))
              ((< num 1) (battle-input env))
              (else (battle-eval (master page ac hp equip enemies Cdamage Event Cturn num))))))))
    
|#

#|
;バトルEVAL関数
(define (battle-eval env) 
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Mes Cturn Choice BG BR CR) env))
    (match-let (((enemy name Eac Ehp Mpage human image) (car Enemies))) ;enemyは流用する
    (if (= Choice 1) ;剣で攻撃
      (let ((Cac (+ Ap (cdr Buki))))       
      (let ((damage (- (+ (dice) Cac) (+ (dice) Eac))))
        (cond ((= damage 0)(battle-print
                             (master Page Hp Ap Buki Bougu Equip Enemies 0 Event Mes (+ Cturn 1) Choice BG BR CR)))
             ((> damage 0) (battle-print
                            (master Page Hp Ap Buki  Bougu Equip
                                   (cons (enemy name Eac (- Ehp (abs damage)) Mpage human image) (cdr Enemies))
                                   damage Event Mes (+ Cturn 1) Choice BG BR CR)))
             ((< damage 0) (battle-print
                              (master Page (- Hp (- (abs damage) (abs (cdr Bougu))))
                                      Ap Buki Bougu Equip Enemies (abs damage) Event Mes (+ Cturn 1) Choice BG BR CR))))))
         (if (equip? Equip "光弾") 
                  (begin (text (format (cdr (assq 'koudan *battle-messages*))) 20 "green")
                         (newline) (place-image (bitmap/file "picture/hikaridama.png") 40 40 (empty-scene *width* *height* "white"))  (newline)
                          (battle-print (master Page Hp Ap Buki Bougu (equip-change Equip "光弾" -1)
                                              (cons (enemy name Eac (- Ehp 3) Mpage human image) (cdr Enemies))
                                              3 Event Mes (+ Cturn 1) Choice BG BR CR)))
                  (begin (text (format (cdr (assq 'tamanasi *battle-messages*))) 20 "green")
                        (battle-print (master Page (- Hp 3) Ap Buki Bougu Equip Enemies -3 Event Mes (+ Cturn 1) Choice BG BR CR))))))))
|#
#|
;バトルPRINT関数
(define (battle-print env) 
  (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Mes Cturn Choice BG BR CR) env))
    (match-let (((enemy name Eac Ehp Mpage human image) (car Enemies))) ;enemyは流用する
      (cond ((= Cdamage 0) (wait) (text (format (cdr (assq 'tie *battle-messages*))) 20 "green") (wait)
                          (battle-input env))
           ((> Cdamage 0) (place-image (bitmap/file "picture/nausika2.png") 50 50 (empty-scene *width* *height* "white"))
                          (newline) (text (format (cdr (assq 'atack *battle-messages*))) 20 "green") 
                         (newline)(wait) (text (format (cdr (assq 'damagep *battle-messages*)) (abs Cdamage)) 20 "green") (wait)
                         (battle-go env))
           ((< Cdamage 0)  (place-image image 50 50 (empty-scene *width* *height* "white"))
                           (newline) (text (format (cdr (assq 'atacked *battle-messages*)) name) 20 "green") 
                         (newline)(wait) (text (format (cdr (assq 'damagedp *battle-messages*)) (abs Cdamage)) 20 "green")
                                          (wait) (battle-go env))))))

|#

(define (change w a-key)
 (cond ((key=? a-key "\r") (battle-go w "\r"))
   ((key=? a-key " ") (battle-go w " "))
   ((key=? a-key "1") (battle-go w "1"))
   ((key=? a-key "2") (battle-go w "2"))
      ((key=? a-key "3") (battle-input w "3"))
         ((key=? a-key "4") (battle-input w "4"))
            ((key=? a-key "5") (battle-go w "5"))
               ((key=? a-key "6") (battle-go w "6"))
                  ((key=? a-key "7") (battle-go w "7"))
                     ((key=? a-key "8") (battle-go w "8"))
                        ((key=? a-key "9") (battle-go w "9"))
 ;    ((key=? a-key "\r") (battle-input w "\r"))
;   ((key=? a-key " ") (battle-input w " "))
 ;  ((key=? a-key "1") (battle-input w "1"))
#|
   ((key=? a-key "2") (battle-input w "2"))
      ((key=? a-key "3") (battle-input w "3"))
         ((key=? a-key "4") (battle-input w "4"))
            ((key=? a-key "5") (battle-input w "5"))
               ((key=? a-key "6") (battle-input w "6"))
                  ((key=? a-key "7") (battle-input w "7"))
                     ((key=? a-key "8") (battle-input w "8"))
                        ((key=? a-key "9") (battle-input w "9")) |#
   (else w)))



#|
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
|#
;(battle-read env)

;(place-image (bitmap/file "picture/hikaridama.png") 200 200 (empty-scene *width* *height* "white"))

 ; (match-let (((master Page Hp Ap Buki Bougu Equip Enemies Cdamage Event Cturn Choice BG BR CR)


(big-bang (master 044 15 15 '("" . 0) '("" . 0) *equip*
                 (battle-ready-list enemy-list 044) 0 #t
                 (format (cdr (assq 'appear *battle-gui-messages*)) "enemy")
                  0 1 "" "" "")
  (on-key change)
  (to-draw place-world)
 (name "模擬戦闘"))


#|
(place-world (master 044 15 15 '("" . 0) '("" . 0) *equip*
                 (battle-ready-list enemy-list 044) 0 #t (format (cdr (assq 'appear *battle-gui-messages*)) "enemy") 0 #t "" "" ""))
|#