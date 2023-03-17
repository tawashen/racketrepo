#lang racket

;ライブラリとか;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 2htdp/universe 2htdp/image lang/posn)
(require describe)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require "DDDitem.rkt")
(require "DDDstruct.rkt")
(require "DDDval.rkt")
(require "DDDutility.rkt")


;テスト用バトル構造体
(define test-battle-struct (BATTLE (sort `(
         (,(HERO "tawa" (bitmap/file "picture/03.png") "ELF" "FIGHTER" "" 1 '(100 . 100) 10 0 90 '(6 . 6)
                 `(,B001) `(,A001) `(,S001) `((,I001 . 1) (,I002 . 2) (,I002 . 2) (,I002 . 2)) `(,M001 ,M002) 10 18 6 11 9 10) . ,(make-posn '93 '155))
         (,(HERO "hosida" (bitmap/file "picture/03.png") "HUMAN" "FIGHTER" "" 1 '(003 . 003) 10 0 90 '(6 . 6)
                 `(,B001) `(,A001) `(,S001) `((,I001 . 2) (,I002 . 3)) `(,M001) 17 10 12 8 15 14) . ,(make-posn '93 '93))
                                       
    
         (,(ENEMY "DEMON1" (bitmap/file "picture/04.png") "ENEMY" "" ""  1 '(100 . 100) 10 0 90 '(3 . 3) `(,B001) `(,A001) `(,S001) '() '() 10 10 10 2 10 10) . ,(make-posn '155 '155))
         (,(ENEMY "DEMON2" (bitmap/file "picture/04.png") "ENEMY" "" ""  1 '(003 . 003) 100 0 90 '(3 . 3) `(,B001) `(,A001) `(,S001) '() '() 10 10 10 2 10 10) . ,(make-posn '217 '217)))
                                   > #:key (lambda (x) (case (variant (car x))
                                                           ((HERO) (CHARACTER-Dex (car x)))
                                                           ((ENEMY) (CHARACTER-Dex (car x))))))
                                                     0 1 '() 0 0 #f "" #f #f #f #f))
                                                   
(define (place-item w)
    (match-let (((BATTLE C-LIST PHASE TURN ITEM MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
           (match-let (((HERO Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (car (car (BATTLE-C-LIST w)))))
  (if (number? (BATTLE-U-ITEM w))
     (let-values (((l1 l2) (for/lists (l1 l2)
                                      ((i Item) (j '(20 50 80 110 140 150 180 210 240 270 300 330 360 390 420 450 480 510)))
                             (values (text (format "~a  ~a" (ITEM-Iname (car i)) (cdr i)) 20 "white") (make-posn 174 (+ j 70))))))
       (place-image/align (rectangle 160 30 "outline" "red") 170 (+ 90 (* 30 (BATTLE-U-ITEM w))) "left" "bottom"
       (place-images/align l1 l2 "left" "bottom"
                           (place-image/align
                            (rectangle 160 (* 30 (length Item)) "solid" "black")  170 (+ 60 (* 30 (length Item))) "left" "bottom"
                                                                            (place-menu w)))))
     (place-menu w)))))
 


(define (place-menu w)
  (if (BATTLE-MENU w)
  (place-image/align (text (format "MENU~% ~%I:アイテムを使う~%M:魔法を使う~%Y:やっぱやめる") 20 "white") 4 160 "left" "bottom"
               (place-image/align (rectangle 160 160 "outline" "white") 0 160 "left" "bottom"
                            (place-image/align (rectangle 160 160 "solid" "black") 0 160 "left" "bottom" (place-waku w))))
  (place-waku w)))


(define (place-waku w)
  (match-let (((BATTLE C-LIST PHASE TURN ITEM MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
         (let-values (((l1 l2) (for/lists (l1 l2)
                               ([i C-LIST] [j '(48 88 128 168 208 248 288 328 368)])
                        (values (rectangle 192 40 "outline" "white")
                        (make-posn 624 j)))))
                (place-images/align l1 l2 "left" "bottom" (place-name w)))))

(define (place-name w)
        (match-let (((BATTLE C-LIST PHASE TURN ITEM MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
   (place-images (map (lambda (x) (text (CHARACTER-Name (car x)) 13 "black")) C-LIST)
                 (map (lambda (y) (make-posn (posn-x (cdr y)) (- (posn-y (cdr y)) 20))) C-LIST)
                 (place-mes w))))


(define (place-mes w)
      (match-let (((BATTLE C-LIST PHASE TURN ITEM MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
        (if (BATTLE-TEXT w)
            (begin (sleep 0.5) (place-image/align (text  (case (car (BATTLE-TEXT w))
                                                  (("CH") (format "~aの攻撃！~%クリティカルヒット！~%~aに~%~aのダメージ！"
                                                                  (car (BATTLE-STATUS w)) (cdr (BATTLE-STATUS w))  (cdr (BATTLE-TEXT w))))
                                                  (("H") (format "~aの攻撃！~%ヒット！~%~aに~%~aのダメージ!"
                                                                  (car (BATTLE-STATUS w)) (cdr (BATTLE-STATUS w))  (cdr (BATTLE-TEXT w))))
                                                  (("M") (format "ミス！~%~aは~%~aにダメージを与えられない！"
                                                                 (car (BATTLE-STATUS w)) (cdr (BATTLE-STATUS w)))))
                                                    20 (if (member (car (BATTLE-STATUS w))
                                                          (map (lambda (y) (CHARACTER-Name (car y)))
                                                               (filter (lambda (x) (symbol=? 'HERO (variant (car x)))) C-LIST))) 
                                                       "white"
                                                       "red")) 630 510 "left" "bottom" (place-gamen w)))
            (place-gamen w))))
         
                                                       
        


(define (place-gamen w)
    (match-let (((BATTLE C-LIST PHASE TURN ITEM MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
      (let-values (((l1 l2) (for/lists (l1 l2)
                               ([i C-LIST] [j '(50 90 130 170 210 250 290 330 370)])
                        (values (text (format "~a~% HP:~a" (CHARACTER-Name (car i)) (align-num (car (CHARACTER-Hp (car i))))) 18
                                      (case (variant (car i))
                                             ((HERO) "white")
                                             ((ENEMY) "red")))        
                        (make-posn 630 j)))))
                (place-images/align l1 l2 "left" "bottom" (place-character w)))))



;キャラクター配置関数
(define (place-character w)
  (match-let (((BATTLE C-LIST PHASE TURN ITEM MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
    (if E-ZAHYO
    (place-image (circle 31 "solid" "red") (posn-x (BATTLE-E-ZAHYO w))
                 (posn-y (BATTLE-E-ZAHYO w))
                 (place-image (square 62 "outline" "red") (posn-x (cdr (car C-LIST))) (posn-y (cdr (car C-LIST)))
    (foldr (lambda (data initial) (place-image (car data) (cadr data) (caddr data) initial)) *background*
    (map (lambda (x) 
         `(,(if (< 0 (car (CHARACTER-Hp (car x)))) (CHARACTER-Image (car x)) "")
           ,(posn-x (cdr x))
           ,(posn-y (cdr x))))
         C-LIST))))
    (place-image (square 62 "outline" "red") (posn-x (cdr (car C-LIST))) (posn-y (cdr (car C-LIST)))
    (foldr (lambda (data initial) (place-image (car data) (cadr data) (caddr data) initial)) *background*
    (map (lambda (x) 
         `(,(if (< 0 (car (CHARACTER-Hp (car x)))) (CHARACTER-Image (car x)) "")
           ,(posn-x (cdr x))
           ,(posn-y (cdr x))))
         C-LIST))))))
    


;キー判定関数
(define (key-func x x-dir y y-dir w Name Image Race Class Ali
                  Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
        (cond
             ((member (d-pair->posn (cons (+ x x-dir) (+ y y-dir))) ;移動先がHEROなら移動しない
                    (map cdr (filter (lambda (x)
                          (symbol=? 'HERO (variant (car x)))) (cdr (BATTLE-C-LIST w))))) (BATTLE-C-LIST w))
             ((member (cons (+ x x-dir) (+ y y-dir))  *map-posn*) (BATTLE-C-LIST w)) ;移動先が石なら移動しない
             ((member (d-pair->posn (cons (+ x x-dir) (+ y y-dir))) ;移動先がENEMYなら攻撃
                    (map cdr (filter (lambda (x)
                          (symbol=? 'ENEMY (variant (car x)))) (cdr (BATTLE-C-LIST w)))))
              (fight x x-dir y y-dir w Name Image Race Class Ali Lv Hp Ac
                     Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))
              (else (let ((new-move (cons (- (car Move) 1) (cdr Move)))) ;何もなければ移動
                          (case (car new-move)
                              ((0) `(,@(cdr (BATTLE-C-LIST w)) ,(cons
                 (HERO Name Image Race Class Ali Lv Hp Ac Exp Money
                       (cons (cdr new-move) (cdr new-move)) Arm Armor Item Sield Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))
                              (else (cons (cons
                 (HERO Name Image Race Class Ali Lv Hp Ac Exp Money
                       (cons (car new-move) (cdr new-move)) Arm Armor Item Sield Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons (+ x x-dir) (+ y y-dir)))) (cdr (BATTLE-C-LIST w)))))))))



;ENEMY移動先チェック関数
(define (to-check x x-dir y y-dir w Name Image Race Class Ali
                  Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
          (let ((new-move (cons (- (car Move) 1) (cdr Move))))
              (case (car new-move)
                       ((0) ;動いたら移動力ゼロの場合
                              (cond
                                 ((member (d-pair->posn (cons (+ x x-dir) (+ y y-dir))) ;移動先がENEMYなら移動しないで次のキャラへ
                    (map cdr (filter (lambda (x)
                          (symbol=? 'ENEMY (variant (car x)))) (cdr (BATTLE-C-LIST w)))))
                                  `(,@(cdr (BATTLE-C-LIST w)) ,(cons 
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money
                        (cons (cdr new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y)))))
                                 ((member (cons (+ x x-dir) (+ y y-dir))  *map-posn*) ;移動先が石なら移動しないで次のキャラへ
                                  `(,@(cdr (BATTLE-C-LIST w)) ,(cons 
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money
                        (cons (cdr Move) (cdr Move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y)))))
                                  ((member (d-pair->posn (cons (+ x x-dir) (+ y y-dir))) ;移動先がHEROなら攻撃
                    (map cdr (filter (lambda (x)
                          (symbol=? 'HERO (variant (car x)))) (cdr (BATTLE-C-LIST w)))))
              (fightE x x-dir y y-dir w Name Image Race Class Ali Lv Hp Ac
                     Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))
                                  (else ;移動できるが残り移動力が0なら移動後に移動力をリセットして次のキャラへ
                                 `(,@(cdr (BATTLE-C-LIST w)) ,(cons 
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money
                        (cons (cdr new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))))
                         (else ;動いても移動力が残っている場合
                               (cond
                                 ((member (d-pair->posn (cons (+ x x-dir) (+ y y-dir))) ;移動先がENEMYなら移動しないで次のキャラへ
                    (map cdr (filter (lambda (x)
                          (symbol=? 'ENEMY (variant (car x)))) (cdr (BATTLE-C-LIST w)))))
                                  `(,@(cdr (BATTLE-C-LIST w)) ,(cons 
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money
                        (cons (cdr new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y)))))
                                 ((member (cons (+ x x-dir) (+ y y-dir))  *map-posn*) ;移動先が石なら移動しないで次のキャラへ
                                  `(,@(cdr (BATTLE-C-LIST w)) ,(cons 
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money
                        (cons (cdr new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y)))))
                                 ((member (d-pair->posn (cons (+ x x-dir) (+ y y-dir))) ;移動先がHEROなら攻撃
                    (map cdr (filter (lambda (x)
                          (symbol=? 'HERO (variant (car x)))) (cdr (BATTLE-C-LIST w)))))
              (fightE x x-dir y y-dir w Name Image Race Class Ali Lv Hp Ac
                     Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))
                                 (else ;移動できて移動力が残っているなら左右へ動く
                                 (cons (cons
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money
                        (cons (car new-move) (cdr new-move)) Arm Armor Item Sield Skill Str Int Wis Dex Con Chr)
                 (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))
                 (cdr (BATTLE-C-LIST w)))))))))

;ENEMY追跡行動
(define (key-funcE x y w Name Image Race Class Ali
                   Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
  (if (member (posn-y (d-pair->posn (cons x y))) (map posn-y (map cdr (filter (lambda (x) ;同じX軸にHEROがいるか？
                          (symbol=? 'HERO (variant (car x)))) (cdr (BATTLE-C-LIST w))))))
      (if (< (posn-x (d-pair->posn (cons x y))) (car (sort (map posn-x (map cdr (filter (lambda (x) ;X軸の右にHEROがいるか？
                          (symbol=? 'HERO (variant (car x)))) (cdr (BATTLE-C-LIST w))))) <)))
          (to-check x 1 y 0 w Name Image Race Class Ali
                    Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
　　　　　(to-check x -1 y 0 w Name Image Race Class Ali
               Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)) 
            (if (< (posn-y (d-pair->posn (cons x y))) (car (sort (map posn-y (map cdr (filter (lambda (x) ;Y軸の下にHEROがいるなら
                          (symbol=? 'HERO (variant (car x)))) (cdr (BATTLE-C-LIST w))))) <)))
                (to-check x 0 y 1 w Name Image Race Class Ali Lv Hp Ac
                          Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                (to-check x 0 y -1 w Name Image Race Class Ali Lv Hp Ac
                          Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))))




;近接戦闘処理
(define (fight x x-dir y y-dir w Name Image Race Class Ali Lv
               Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
  (let* ((C-flag (if (<= (BUKI-Bcrit (car Arm)) (D20)) #t #f)) (Attack (Bbonus w Name Race Class Lv Hp Arm Str Dex Con))
                                           (teki-zahyo (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))                  
          (Target (car (filter (lambda (z)
                                 (equal?  (cdr z) teki-zahyo)) (BATTLE-C-LIST w)))))
    (match-let (((ENEMY EName EImage ERace EClass EAli ELv EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (car Target))) ;ENEMY情報を読み込む
      (let ((damage (if C-flag
                        (if hit? (begin
                                   (set-BATTLE-TEXT! w "CH")
                                   (+ (* (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm))))
                                         (BUKI-Bcrit (car Arm))) (Mbonus Str)))                           
                            (begin
                                   (set-BATTLE-TEXT! w "H")
                                   (+ (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm)))) (Mbonus Str))))
                        (if hit? (begin
                                   (set-BATTLE-TEXT! w "H")
                                   (+ (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm)))) (Mbonus Str)))
                            (begin
                                   (set-BATTLE-TEXT! w "M") 0)))))
        (set-BATTLE-TEXT! w (cons (BATTLE-TEXT w) damage)) (set-BATTLE-STATUS! w (cons Name EName))
        (if (< 0 damage) (set-BATTLE-E-ZAHYO! w teki-zahyo) (set-BATTLE-E-ZAHYO! w #f))
        (let ((new-EHp (cons (- (car EHp) damage) EHp))) 
          (cond  ((< 0 (car new-EHp))
              (let ((new-target (cons (ENEMY EName EImage ERace EClass EAli ELv new-EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))
                    (let loop ((Clist (BATTLE-C-LIST w)) (new-list '()))
      (if (null? Clist)
          (let ((top (car (reverse new-list))) (tail (cdr (reverse new-list)))) `(,@tail ,top))
          (loop (cdr Clist) (if (equal? (d-pair->posn (cons (+ x x-dir) (+ y y-dir))) (cdr (car Clist)))
                                (cons new-target new-list) (cons (car Clist) new-list)))))))
                 (else
         (let ((new-Clist
                (filter (lambda (z) ((compose not equal?)
                                     (cdr z) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))) (BATTLE-C-LIST w))))
           `(,@(cdr new-Clist) ,(cons
                 (HERO Name Image Race Class Ali Lv Hp Ac Exp Money
                       (cons (cdr EMove) (cdr EMove)) Arm Armor Item Sield Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y))))))))))))

;近接戦闘処理ENEMY
(define (fightE x x-dir y y-dir w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
  (let* ((C-flag (if (<= (BUKI-Bcrit (car Arm)) (D20)) #t #f)) (Attack (Bbonus w Name Race Class Lv Hp Arm Str Dex Con))
                                                               (teki-zahyo (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))
          (Target (car (filter (lambda (z)
                                 (equal?  (cdr z) teki-zahyo)) (BATTLE-C-LIST w)))))
    (match-let (((HERO EName EImage ERace EClass EAli ELv EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (car Target))) ;ENEMY情報を読み込む
      (let ((damage (if C-flag
                        (if hit? (begin
                                   (set-BATTLE-TEXT! w "CH")
                                   (+ (* (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm))))
                                         (BUKI-Bcrit (car Arm))) (Mbonus Str)))                           
                            (begin
                                   (set-BATTLE-TEXT! w "H")
                                   (+ (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm)))) (Mbonus Str))))
                        (if hit? (begin
                                   (set-BATTLE-TEXT! w "H")
                                   (+ (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm)))) (Mbonus Str)))
                            (begin
                                   (set-BATTLE-TEXT! w "M") 0)))))
        (set-BATTLE-TEXT! w (cons (BATTLE-TEXT w) damage)) (set-BATTLE-STATUS! w (cons Name EName))
        (if (< 0 damage) (set-BATTLE-E-ZAHYO! w teki-zahyo) (set-BATTLE-E-ZAHYO! w #f))
        (let ((new-EHp (cons (- (car EHp) damage) EHp))) 
          (cond  ((< 0 (car new-EHp))
              (let ((new-target (cons (HERO EName EImage ERace EClass EAli ELv new-EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))
                    (let loop ((Clist (BATTLE-C-LIST w)) (new-list '()))
      (if (null? Clist)
          (let ((top (car (reverse new-list))) (tail (cdr (reverse new-list)))) `(,@tail ,top))
          (loop (cdr Clist) (if (equal? (d-pair->posn (cons (+ x x-dir) (+ y y-dir))) (cdr (car Clist)))
                                (cons new-target new-list) (cons (car Clist) new-list)))))))
                 (else
         (let ((new-Clist
                (filter (lambda (z) ((compose not equal?)
                                     (cdr z) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))) (BATTLE-C-LIST w))))
           `(,@(cdr new-Clist) ,(cons
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money (cons (cdr EMove) (cdr EMove)) Arm Armor Item Sield Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y))))))))))))



(define (change w a-key)
  (set-BATTLE-TEXT! w #f) (set-BATTLE-STATUS! w #f) 
       (match-let (((HERO Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (car (car (BATTLE-C-LIST w)))))
 (let ((dir (posn->d-pair (cdr (car (BATTLE-C-LIST w))))))
  (let ((x (car dir)) (y (cdr dir)))
    (case (BATTLE-MENU w)
      ((#f)
   (BATTLE
      (cond
        ((key=? a-key "m") (set-BATTLE-MENU! w #t) (BATTLE-C-LIST w))
     ((key=? a-key " ") `(,@(cdr (BATTLE-C-LIST w)) ,(car (BATTLE-C-LIST w))))
     ((key=? a-key "left")
      (key-func x -1 y 0 w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))
     ((key=? a-key "right")
      (key-func x 1 y 0 w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))
     ((= (string-length a-key) 1) (BATTLE-C-LIST w))
     ((key=? a-key "up")
      (key-func x 0 y -1 w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))
     ((key=? a-key "down")
      (key-func x 0 y 1 w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))
     (else (BATTLE-C-LIST w)))
    (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MONEY w)
    (BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w) (BATTLE-TEXT w)
    (BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w)))

      ((#t) ;MENUが表示されていて
       (if (BATTLE-U-ITEM w)
             (BATTLE  (BATTLE-C-LIST w) (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MONEY w)
    (BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w) (BATTLE-TEXT w)  (BATTLE-MENU w)
         (cond ((key=? a-key "up") (if (= (BATTLE-U-ITEM w) 0) 0 (- (BATTLE-U-ITEM w) 1)))
          ((key=? a-key "down") (if (< (+ 1 (BATTLE-U-ITEM w)) (length Item)) (+ (BATTLE-U-ITEM w) 1) (BATTLE-U-ITEM w)))
          (else (BATTLE-U-ITEM w)))
                (BATTLE-C-MAGIC w))
             
               (BATTLE  (BATTLE-C-LIST w) (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MONEY w)
    (BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w) (BATTLE-TEXT w)
    (cond ((key=? a-key "y") #f)
          (else (BATTLE-MENU w)))
    (cond ((key=? a-key "i") 0)
          (else (BATTLE-U-ITEM w)))
    (cond ((key=? a-key "m") #t)
          (else (BATTLE-C-MAGIC w))))))
      (else w))))))

  
  


(define (end w)
 (or
  (null? (map variant (map car (filter (lambda (x) (symbol=? 'ENEMY (variant (car x))))  (BATTLE-C-LIST w)))))
  (null? (map variant (map car (filter (lambda (x) (symbol=? 'HERO (variant (car x))))  (BATTLE-C-LIST w)))))))

(define (ending w)
      (if (null? (map variant (map car (filter (lambda (x) (symbol=? 'ENEMY (variant (car x))))  (BATTLE-C-LIST w)))))
     (place-image (text (format "敵を殲滅した！

   ~aゴールドと経験値~aを得た！" (BATTLE-MONEY w) (BATTLE-EXP w))

  15 "white")
         300
         200
         (empty-scene *width* *height* "black"))
          (place-image (text (format "君たちは全滅した! すべてを失った!")

  15 "white")
         300
         200
         (empty-scene *width* *height* "black"))))

(define (set-on-tick w)
   (let ((dir (posn->d-pair (cdr (car (BATTLE-C-LIST w))))))
     (let ((x (car dir)) (y (cdr dir)))
    (cond ((symbol=? (variant (car (car (BATTLE-C-LIST w)))) 'ENEMY)
      (match-let (((ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (car (car (BATTLE-C-LIST w)))))
           (BATTLE 
           (key-funcE x y w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
            (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MONEY w)
    (BATTLE-EXP w) #f (BATTLE-STATUS w) (BATTLE-TEXT w)(BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w))))
          (else
           (BATTLE (BATTLE-C-LIST w) (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MONEY w)
    (BATTLE-EXP w) #f (BATTLE-STATUS w) (BATTLE-TEXT w)(BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w)))))))
          

;メインBig-bang
(define (big-test x)
(big-bang x 
 (to-draw place-item)
  (on-tick set-on-tick 1/2)
  (on-key change)
  (stop-when end ending) 
 (name "DD&D") 
))


(big-test test-battle-struct)
