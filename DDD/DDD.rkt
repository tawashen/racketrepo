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


;テスト用バトル構造体;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define test-battle-struct (BATTLE (sort `(
         (,(HERO "tawa" (bitmap/file "picture/03.png") "ELF" "FIGHTER" "" 1 '(120 . 100) 10 0 90 '(6 . 6)
                 `(,B001) `(,A001) `(,S001) `((,I001 . 1) (,I002 . 2) (,I003 . 2) (,I004 . 2)) `((,M001 . 3) (,M002 . 2) (,M003 . 3) (,M004 . 3)) 10 18 6 11 9 10) . ,(make-posn '93 '155))
         (,(HERO "hosida" (bitmap/file "picture/03.png") "HUMAN" "FIGHTER" "" 1 '(080 . 003) 10 0 90 '(6 . 6)
                 `(,B001) `(,A001) `(,S001) `((,I001 . 2) (,I002 . 3)) `((,M001 . 1)) 17 10 12 8 15 14) . ,(make-posn '93 '93))
                                       
    
         (,(ENEMY "DEMON1" (bitmap/file "picture/04.png") "ENEMY" "" ""  1 '(100 . 100) 10 0 90 '(3 . 3) `(,B001) `(,A001) `(,S001) '() '() 10 10 10 2 10 10) . ,(make-posn '155 '155))
         (,(ENEMY "DEMON2" (bitmap/file "picture/04.png") "ENEMY" "" ""  1 '(003 . 003) 100 0 90 '(3 . 3) `(,B001) `(,A001) `(,S001) '() '() 10 10 10 2 10 10) . ,(make-posn '217 '217)))
                                   > #:key (lambda (x) (case (variant (car x))
                                                           ((HERO) (CHARACTER-Dex (car x)))
                                                           ((ENEMY) (CHARACTER-Dex (car x))))))
                                                     0 1 #f #f 0 0 #f "" #f #f #f #f))




;画面表示関連;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;汎用関数
(define (filter-hero w)
  (filter (lambda (x) (symbol=? 'HERO (variant (car x)))) (BATTLE-C-LIST w)))
(define (filter-enemy w)
  (filter (lambda (x) (symbol=? 'ENEMY (variant (car x)))) (BATTLE-C-LIST w)))
(define (hero-or-enemy w)
  (variant (car (car (BATTLE-C-LIST w)))))
;汎用関数ここまで

;Place-hero-item用補助関数
(define (magic-item w kind slotN slotL hero-list enemy-list)
                       (let-values (((l1 l2) (for/lists (l1 l2) 
                                      ((i (case kind
                                            (("HO") hero-list)
                                            (("AS") enemy-list))) (j '(80 110 140 150 180 210 240 270 300 330 360 390 420 450 480 510)))
                             (values (text (format "~a" (CHARACTER-Name (car i)))
                                                              20 "white") (make-posn 344 (+ j 70))))))
       (place-image/align (rectangle 160 30 "outline" "red") 340 (+ 150 (* 30 slotN)) "left" "bottom"
       (place-images/align l1 l2 "left" "bottom"
                           (place-image/align
                            (rectangle 160 (* 30 (length (case kind
                                                  (("HO") hero-list)
                                                  (("AS") enemy-list)))) "solid" "black")  340 (+ 120 (* 30
                                                   (length (case kind
                                                  (("HO") hero-list)
                                                  (("AS") enemy-list))
                                                   ))) "left" "bottom"
                                                                            (place-item w))))))
;;;;;;;;;;;;;;;;;;;;;;;;;




(define (place-herolist w)
  (let ((hero-list (filter-hero w))
        (enemy-list (filter-enemy w)))
         (case (hero-or-enemy w)
        ((HERO)
           (match-let (((HERO Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (car (car (BATTLE-C-LIST w)))))
    (cond ((BATTLE-ITEM w)
           (magic-item w (ITEM-Ikind (car (BATTLE-U-ITEM w))) (BATTLE-ITEM w) (BATTLE-U-ITEM w) hero-list enemy-list))
          ((BATTLE-MAGIC w)
           (magic-item w (MAGIC-Mkind (car (BATTLE-C-MAGIC w))) (BATTLE-MAGIC w) (BATTLE-C-MAGIC w) hero-list enemy-list))
          (else (place-item w)))))
           (else (place-item w)))))

;Place-item補助関数
(define (place-list-skill-item w s-or-i l1 l2) 
               (place-images/align l1 l2 "left" "bottom"
                           (place-image/align
                            (rectangle 160 (* 30 (length s-or-i)) "solid" "black")  170 (+ 60 (* 30 (length s-or-i))) "left" "bottom"
                                                                            (place-menu w))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (place-item w)
      (case (hero-or-enemy w)
        ((HERO)
           (match-let (((HERO Name Image Race Class Ali Lv Hp Ac Exp Money Move
                              Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (car (car (BATTLE-C-LIST w)))))
  (cond
    ((or (number? (BATTLE-U-ITEM w)) (and (number? (BATTLE-ITEM w)) (cons? (BATTLE-U-ITEM w))))
     (let-values (((l1 l2) (for/lists (l1 l2)
                                      ((i Item) (j '(20 50 80 110 140 150 180 210 240 270 300 330 360 390 420 450 480 510)))
                             (values (text (format "~a  ~a" (ITEM-Iname
                                                             (car i)) (cdr i)) 20 "white") (make-posn 174 (+ j 70))))))
       (cond ((number? (BATTLE-U-ITEM w))
       (place-image/align (rectangle 160 30 "outline" "red") 170 (+ 90 (* 30 (BATTLE-U-ITEM w))) "left" "bottom"
                        (place-list-skill-item w Item l1 l2)))

             ((cons? (BATTLE-U-ITEM w))
                  (place-list-skill-item w Item l1 l2))

             (else (place-menu w)))))
      ((or (number? (BATTLE-C-MAGIC w)) (and (number? (BATTLE-MAGIC w)) (cons? (BATTLE-C-MAGIC w))))
     (let-values (((l1 l2) (for/lists (l1 l2)
                                      ((i Skill) (j '(20 50 80 110 140 150 180 210 240 270 300 330 360 390 420 450 480 510)))
                             (values (text (format "~a  ~a" (MAGIC-Mname
                                                             (car i)) (cdr i)) 20 "white") (make-posn 174 (+ j 70))))))
       (cond ((number? (BATTLE-C-MAGIC w))
       (place-image/align (rectangle 160 30 "outline" "red") 170 (+ 90 (* 30 (BATTLE-C-MAGIC w))) "left" "bottom"
                          (place-list-skill-item w Skill l1 l2)))

             ((cons? (BATTLE-C-MAGIC w))
              (place-list-skill-item w Skill l1 l2))
 
                (else (place-menu w)))))
            (else (place-menu w)))))
        (else (place-waku w))))
 

(define (place-menu w)
  (if (BATTLE-MENU w)
  (place-image/align (text (format "MENU~% ~%I:アイテムを使う~%M:魔法を使う~%Y:やっぱやめる") 20 "white") 4 160 "left" "bottom"
               (place-image/align (rectangle 160 160 "outline" "white") 0 160 "left" "bottom"
                            (place-image/align (rectangle 160 160 "solid" "black") 0 160 "left" "bottom" (place-waku w))))
  (place-waku w)))


(define (place-waku w)
  (match-let (((BATTLE C-LIST PHASE TURN ITEM MAGIC MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
         (let-values (((l1 l2) (for/lists (l1 l2)
                               ([i C-LIST] [j '(48 88 128 168 208 248 288 328 368)])
                        (values (rectangle 192 40 "outline" "white")
                        (make-posn 624 j)))))
                (place-images/align l1 l2 "left" "bottom" (place-name w)))))

(define (place-name w)
        (match-let (((BATTLE C-LIST PHASE TURN ITEM MAGIC MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
   (place-images (map (lambda (x) (text (CHARACTER-Name (car x)) 13 "black")) C-LIST)
                 (map (lambda (y) (make-posn (posn-x (cdr y)) (- (posn-y (cdr y)) 20))) C-LIST)
                 (place-mes w))))


(define (place-mes w)
      (match-let (((BATTLE C-LIST PHASE TURN ITEM MAGIC MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
        (if (BATTLE-TEXT w)
            (begin (sleep 0.5) (place-image/align (text  (case (car (BATTLE-TEXT w))
                                                  (("CH") (format "~aの攻撃!~%クリティカルヒット!~%~aに~%~aのダメージ!"
                                                                  (car (BATTLE-STATUS w)) (cdr (BATTLE-STATUS w))  (cdr (BATTLE-TEXT w))))
                                                  (("H") (format "~aの攻撃!~%ヒット!~%~aに~%~aのダメージ!"
                                                                  (car (BATTLE-STATUS w)) (cdr (BATTLE-STATUS w))  (cdr (BATTLE-TEXT w))))
                                                  (("M") (format "ミス!~%~aは~%~aにダメージを与えられない!"
                                                                 (car (BATTLE-STATUS w)) (cdr (BATTLE-STATUS w)))))
                                                    20 (if (member (car (BATTLE-STATUS w))
                                                          (map (lambda (y) (CHARACTER-Name (car y)))
                                                               (filter (lambda (x) (symbol=? 'HERO (variant (car x)))) C-LIST))) 
                                                       "white"
                                                       "red")) 630 510 "left" "bottom" (place-gamen w)))
            (place-gamen w))))
         
                                                       
(define (place-gamen w)
    (match-let (((BATTLE C-LIST PHASE TURN ITEM MAGIC MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
      (let-values (((l1 l2) (for/lists (l1 l2)
                               ([i C-LIST] [j '(50 90 130 170 210 250 290 330 370)])
                        (values (text (format "~a~% HP:~a" (CHARACTER-Name (car i)) (align-num (car (CHARACTER-Hp (car i))))) 18
                                      (case (variant (car i))
                                             ((HERO) "white")
                                             ((ENEMY) "red")))        
                        (make-posn 630 j)))))
                (place-images/align l1 l2 "left" "bottom" (place-character w)))))


(define (place-character w)
  (match-let (((BATTLE C-LIST PHASE TURN ITEM MAGIC MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) w))
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
    


;キー判定関数;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
                       (cons (cdr new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))
                              (else (cons (cons
                 (HERO Name Image Race Class Ali Lv Hp Ac Exp Money
                       (cons (car new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
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
                        (cons (car new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                 (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))
                 (cdr (BATTLE-C-LIST w)))))))))

;ENEMY追跡行動
(define (key-funcE x y w Name Image Race Class Ali
                   Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
  (if (member (posn-y (d-pair->posn (cons x y))) (map posn-y (map cdr (filter (lambda (x) ;同じX軸にHEROがいるか?
                          (symbol=? 'HERO (variant (car x)))) (cdr (BATTLE-C-LIST w))))))
      (if (< (posn-x (d-pair->posn (cons x y))) (car (sort (map posn-x (map cdr (filter (lambda (x) ;X軸の右にHEROがいるか?
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




;近接戦闘処理;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (fight x x-dir y y-dir w Name Image Race Class Ali Lv
               Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
  (let* ((C-flag (if (<= (car (BUKI-Bcrit (car Arm))) (D20)) #t #f)) (Attack (Bbonus w Name Race Class Lv Hp Arm Str Dex Con))
                                           (teki-zahyo (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))                  
          (Target (car (filter (lambda (z)
                                 (equal?  (cdr z) teki-zahyo)) (BATTLE-C-LIST w)))))
    (match-let (((ENEMY EName EImage ERace EClass EAli ELv EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (car Target))) ;ENEMY情報を読み込む
      (let ((damage (if C-flag
                        (if hit? (begin
                                   (set-BATTLE-TEXT! w "CH")
                                   (+ (* (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm))))
                                         (cdr (BUKI-Bcrit (car Arm)))) (Mbonus Str)))                           
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
        (let ((new-EHp (cons (- (car EHp) damage) (cdr EHp))))
          (cond  ((< 0 (car new-EHp)) ;破壊的変更にした
                (let ((new-target (cons (HERO EName EImage ERace EClass EAli ELv new-EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))
                (set-CHARACTER-Hp! (car (car (filter (lambda (z) (equal? teki-zahyo (cdr z))) (BATTLE-C-LIST w)))) new-EHp)
                `(,@(cdr (BATTLE-C-LIST w)) ,(car (BATTLE-C-LIST w)))))
   
                 (else
         (let ((new-Clist
                (filter (lambda (z) ((compose not equal?)
                                     (cdr z) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))) (BATTLE-C-LIST w))))
           `(,@(cdr new-Clist) ,(cons
                 (HERO Name Image Race Class Ali Lv Hp Ac Exp Money
                       (cons (cdr EMove) (cdr EMove)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y))))))))))))

;近接戦闘処理ENEMY
(define (fightE x x-dir y y-dir w Name Image Race Class Ali Lv Hp Ac Exp Money Move
                Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
  (let* ((C-flag (if (<= (car (BUKI-Bcrit (car Arm))) (D20)) #t #f))
         (Attack (Bbonus w Name Race Class Lv Hp Arm Str Dex Con))
                  　(teki-zahyo (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))
          (Target (car (filter (lambda (z)
                          (equal?  (cdr z) teki-zahyo)) (BATTLE-C-LIST w)))))
    (match-let (((HERO EName EImage ERace EClass EAli ELv EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (car Target))) ;ENEMY情報を読み込む
      (let ((damage (if C-flag
                        (if hit? (begin
                                   (set-BATTLE-TEXT! w "CH")
                                   (+ (* (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm))))
                                         (cdr (BUKI-Bcrit (car Arm)))) (Mbonus Str)))                           
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
        (let ((new-EHp (cons (- (car EHp) damage) (cdr EHp)))) 
          (cond  ((< 0 (car new-EHp)) ;HPの更新を破壊的変更
              (let ((new-target (cons (HERO EName EImage ERace EClass EAli ELv new-EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))
　               (set-CHARACTER-Hp!  (car (car (filter (lambda (z) (equal? teki-zahyo (cdr z))) (BATTLE-C-LIST w)))) new-EHp)
                `(,@(cdr (BATTLE-C-LIST w)) ,(car (BATTLE-C-LIST w)))))
                 (else
         (let ((new-Clist
                (filter (lambda (z) ((compose not equal?)
                                     (cdr z) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))) (BATTLE-C-LIST w))))
           `(,@(cdr new-Clist) ,(cons
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money
                        (cons (cdr EMove) (cdr EMove)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y))))))))))))



(define (change w a-key)
  (set-BATTLE-TEXT! w #f) (set-BATTLE-STATUS! w #f)
  (case (hero-or-enemy w)
    ((HERO)
       (match-let (((HERO Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (car (car (BATTLE-C-LIST w)))))
 (let ((dir (posn->d-pair (cdr (car (BATTLE-C-LIST w))))))
  (let ((x (car dir)) (y (cdr dir)))
    (case (BATTLE-MENU w)
      ((#f) ;case BATTLE-MENU
   (BATTLE
      (cond
        ((key=? a-key "m") (set-BATTLE-MENU! w #t) (set-BATTLE-ITEM! w #f) (set-BATTLE-U-ITEM! w #f)
                           (set-BATTLE-C-MAGIC! w #f) (set-BATTLE-MAGIC! w #f) (BATTLE-C-LIST w))
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
    (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MAGIC w) (BATTLE-MONEY w)
    (BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w) (BATTLE-TEXT w)
    (BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w)))

      ((#t) ;MENUが表示されていて case BATTLE-MENU
       (cond
         ((number? (BATTLE-MAGIC w)) ;MAGICが0なら
          (case (MAGIC-Mkind (car (BATTLE-C-MAGIC w)))
            (("HO")
             (let ((hero-member (filter (lambda (x) (symbol=? 'HERO (variant (car x)))) (BATTLE-C-LIST w))))
           (BATTLE
            (cond
             ((key=? a-key "\r") ;enterで該当メンバーを特定してHPを回復してC-LIST更新
              (set-CHARACTER-Hp! (car (list-ref hero-member (BATTLE-MAGIC w)))
                 (let ((new-car-hp (+ (MAGIC-Mpower (car (BATTLE-C-MAGIC w)))
                                (car (CHARACTER-Hp (car (list-ref hero-member (BATTLE-MAGIC w)))))))
                 (old-cdr-hp (cdr (CHARACTER-Hp (car (list-ref hero-member (BATTLE-MAGIC w)))))))
             (if (< new-car-hp old-cdr-hp)
                (cons new-car-hp old-cdr-hp)
               (cons old-cdr-hp old-cdr-hp)))) ;HPの更新       
             (set-BATTLE-MENU! w #f) (set-BATTLE-MAGIC! w #f) ;MENUなどを消す
                (let ((t-i-list (car (filter (lambda (x)
                                               (string=? (MAGIC-Mname (car (BATTLE-C-MAGIC w))) (MAGIC-Mname (car x)))) Skill)))
                             (not-t-i-list (filter (lambda (x) ((compose not string=?)
                                                         (MAGIC-Mname (car (BATTLE-C-MAGIC w))) (MAGIC-Mname (car x)))) Skill)))
                  (set-CHARACTER-Skill! (car (car (BATTLE-C-LIST w))) ;アクティブHEROの使用アイテムを1減らす破壊的変更
                      `(,(cons (car t-i-list) (- (cdr t-i-list) 1)) ,@not-t-i-list))              
              `(,@(cdr (BATTLE-C-LIST w))
                ,(car (BATTLE-C-LIST w))))) ;変更したCHARACTERを後ろにつけて新たなC-LIST
               (else (BATTLE-C-LIST w)))
          (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w)
           (cond
           ((key=? a-key "up") (if (= (BATTLE-MAGIC w) 0) 0 (- (BATTLE-MAGIC w) 1)))
           ((key=? a-key "down") (if (< (+ 1 (BATTLE-MAGIC w)) (length hero-member)) (+ (BATTLE-MAGIC w) 1) (BATTLE-MAGIC w)))
           (else (BATTLE-MAGIC w)))
           (BATTLE-MONEY w)(BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w)
                 (BATTLE-TEXT w) (BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w))))
            
            (("AS")
                 (let ((enemy-member (filter (lambda (x) (symbol=? 'ENEMY (variant (car x)))) (BATTLE-C-LIST w))))
                    (match-let (((ENEMY TName TImage TRace TClass TAli TLv THp TAc TExp TMoney TMove
                                        TArm TArmor TSield TItem TSkill TStr TInt TWis TDex TCon TChr)
                                 (car (list-ref enemy-member (BATTLE-MAGIC w)))))
         (BATTLE
          (cond 
           ((key=? a-key "\r") ;enterで該当ENEMYを特定してHPを引いてC-LIST更新
             (set-CHARACTER-Hp! (car (list-ref enemy-member (BATTLE-MAGIC w)))
           (let ((new-car-hp (- (car (CHARACTER-Hp (car (list-ref enemy-member (BATTLE-MAGIC w)))))
                                (MAGIC-Mpower (car (BATTLE-C-MAGIC w)))))
                 (old-cdr-hp (cdr (CHARACTER-Hp (car (list-ref enemy-member (BATTLE-MAGIC w)))))))
             (if (< new-car-hp old-cdr-hp)
                (cons new-car-hp old-cdr-hp)
               (cons old-cdr-hp old-cdr-hp)))) ;HPの更新       
             (set-BATTLE-MENU! w #f) (set-BATTLE-MAGIC! w #f) ;MENUなどを消す
                (let ((t-i-list (car (filter (lambda (x)
                                               (string=? (MAGIC-Mname (car (BATTLE-C-MAGIC w))) (MAGIC-Mname (car x)))) Skill)))
                             (not-t-i-list (filter (lambda (x) ((compose not string=?)
                                                         (MAGIC-Mname (car (BATTLE-C-MAGIC w))) (MAGIC-Mname (car x)))) Skill)))
                  (set-CHARACTER-Skill! (car (car (BATTLE-C-LIST w))) ;アクティブHEROの使用アイテムを1減らす破壊的変更
                      `(,(cons (car t-i-list) (- (cdr t-i-list) 1)) ,@not-t-i-list))              
              `(,@(cdr (BATTLE-C-LIST w))
                ,(car (BATTLE-C-LIST w))))) ;変更したCHARACTERを後ろにつけて新たなC-LIST
           (else (BATTLE-C-LIST w)))
          (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w)
           (cond
           ((key=? a-key "up") (if (= (BATTLE-MAGIC w) 0) 0 (- (BATTLE-MAGIC w) 1)))
           ((key=? a-key "down") (if (< (+ 1 (BATTLE-MAGIC w)) (length enemy-member)) (+ (BATTLE-MAGIC w) 1) (BATTLE-MAGIC w)))
           (else (BATTLE-MAGIC w)))
           (BATTLE-MONEY w)(BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w)
                 (BATTLE-TEXT w) (BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w)))))
            (else (BATTLE-C-LIST w)))) ;MAGICが0ここまで
       
                                     
         ((cons? (BATTLE-C-MAGIC w)) ;C-MAGICがConsなら
          (BATTLE
               (case (MAGIC-Mkind (car (BATTLE-C-MAGIC w))) ;C-LIST
                 (("AC") ;ConsでACなら全体攻撃 
                  (set-BATTLE-MENU! w #f)
                  (for-each (lambda (y) (set-CHARACTER-Hp! (car y)
                                  (cons (- (car (CHARACTER-Hp (car y)))
                                           (MAGIC-Mpower (car (BATTLE-C-MAGIC w)))) (cdr (CHARACTER-Hp (car y))))))
                            (filter (lambda (x) (symbol=? 'ENEMY (variant (car x)))) (BATTLE-C-LIST w)))
        (let ((t-i-list (car (filter (lambda (x) (string=? (MAGIC-Mname (car (BATTLE-C-MAGIC w))) (MAGIC-Mname (car x)))) Skill)))
                             (not-t-i-list (filter (lambda (x) ((compose not string=?)
                                                         (MAGIC-Mname (car (BATTLE-C-MAGIC w))) (MAGIC-Mname (car x)))) Skill)))
                  (set-CHARACTER-Skill! (car (car (BATTLE-C-LIST w))) ;アクティブHEROの使用MAGICを1減らす破壊的変更
                      `(,(cons (car t-i-list) (- (cdr t-i-list) 1)) ,@not-t-i-list))
                  `(,@(cdr (filter (lambda (x) (< 0 (car (CHARACTER-Hp (car x))))) (BATTLE-C-LIST w))) ,(car (BATTLE-C-LIST w)))))
                ; (("HC")  );全体回復                 
                 (("HO") (set-BATTLE-MAGIC! w 0) (BATTLE-C-LIST w)) ;個別回復
                 (("AS") (set-BATTLE-MAGIC! w 0) (BATTLE-C-LIST w)) ;個別攻撃
                 (else (BATTLE-C-LIST w)))
               (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MAGIC w)
              (BATTLE-MONEY w) (BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w) (BATTLE-TEXT w)
              (BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w)))

         
       
       ((number? (BATTLE-C-MAGIC w)) ;BATTLE-C-MAGICに0がセットされたら
          (BATTLE
            (BATTLE-C-LIST w)  (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MAGIC w) (BATTLE-MONEY w)
    (BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w) (BATTLE-TEXT w)  (BATTLE-MENU w) (BATTLE-U-ITEM w)
         (cond ((key=? a-key "up") (if (= (BATTLE-C-MAGIC w) 0) 0 (- (BATTLE-C-MAGIC w) 1)))
          ((key=? a-key "down") (if (< (+ 1 (BATTLE-C-MAGIC w)) (length Skill)) (+ (BATTLE-C-MAGIC w) 1) (BATTLE-C-MAGIC w)))
          ((key=? a-key "\r") (list-ref Skill (BATTLE-C-MAGIC w))) ;Enterを押すとSkillの該当部分をBATTLE-C-MAGICにセット (magic . 回数)
          (else (BATTLE-C-MAGIC w))))) ;ここまでC-MAGICが Numberなら
         

          ((number? (BATTLE-ITEM w)) ;BATTLE-ITEMに0がセットされていれば
               (let ((hero-member (filter (lambda (x) (symbol=? 'HERO (variant (car x)))) (BATTLE-C-LIST w))))
                  (match-let (((HERO TName TImage TRace TClass TAli TLv THp TAc TExp TMoney TMove
                                     TArm TArmor TSield TItem TSkill TStr TInt TWis TDex TCon TChr)
                   (car (list-ref hero-member (BATTLE-ITEM w)))))
              (BATTLE
                (case (ITEM-Ikind (car (BATTLE-U-ITEM w)))
                  (("HO")
                  (cond 
          　((key=? a-key "\r") ;enterで該当メンバーを特定してHPを回復してC-LIST更新
             (set-CHARACTER-Hp! (car (list-ref hero-member (BATTLE-ITEM w)))
           (let ((new-car-hp (+ (ITEM-Ipower (car (BATTLE-U-ITEM w)))
                                (car (CHARACTER-Hp (car (list-ref hero-member (BATTLE-ITEM w)))))))
                 (old-cdr-hp (cdr (CHARACTER-Hp (car (list-ref hero-member (BATTLE-ITEM w)))))))
             (if (< new-car-hp old-cdr-hp)
                (cons new-car-hp old-cdr-hp)
               (cons old-cdr-hp old-cdr-hp)))) ;HPの更新       
             (set-BATTLE-MENU! w #f) (set-BATTLE-ITEM! w #f) ;MENUなどを消す
                (let ((t-i-list (car (filter (lambda (x)
                                               (string=? (ITEM-Iname (car (BATTLE-U-ITEM w))) (ITEM-Iname (car x)))) Item)))
                             (not-t-i-list (filter (lambda (x) ((compose not string=?)
                                                         (ITEM-Iname (car (BATTLE-U-ITEM w))) (ITEM-Iname (car x)))) Item)))
                  (set-CHARACTER-Item! (car (car (BATTLE-C-LIST w))) ;アクティブHEROの使用アイテムを１減らす破壊的変更
                      `(,(cons (car t-i-list) (- (cdr t-i-list) 1)) ,@not-t-i-list))                
              `(,@(cdr (BATTLE-C-LIST w)) ,(car (BATTLE-C-LIST w)))))　;変更したCHARACTERを後ろにつけて新たなC-LIST
                                     
         　 (else (BATTLE-C-LIST w))))  ;入力がない場合
                  (else (BATTLE-C-LIST w))) ;"HO"ではない場合
                       (BATTLE-PHASE w) (BATTLE-TURN w)
                       ;以下(BATTLE-ITEM w)相当
                   (cond
　　　　　　((key=? a-key "up") (if (= (BATTLE-ITEM w) 0) 0 (- (BATTLE-ITEM w) 1)))
          　((key=? a-key "down") (if (< (+ 1 (BATTLE-ITEM w)) (length hero-member)) (+ (BATTLE-ITEM w) 1) (BATTLE-ITEM w)))
         　 (else (BATTLE-ITEM w)))
                 (BATTLE-MAGIC w) (BATTLE-MONEY w)(BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w)
                 (BATTLE-TEXT w) (BATTLE-MENU w)　(BATTLE-U-ITEM w) (BATTLE-C-MAGIC w))))) ;BATTLE-ITEM 0 ここまで


             ((cons? (BATTLE-U-ITEM w)) ;U-ITEMが Consなら
              (BATTLE
               (case (ITEM-Ikind (car (BATTLE-U-ITEM w))) 
                 (("HS") ;ConsでHSなら
                  (let ((new-car-hp (+ (ITEM-Ipower (car (BATTLE-U-ITEM w))) (car Hp))))
                  (set-BATTLE-MENU! w #f) 
                    `(,@(cdr (BATTLE-C-LIST w)) ,(cons
                 (HERO Name Image Race Class Ali Lv (if (< new-car-hp (cdr Hp)) (cons new-car-hp (cdr Hp))
                                                      (cons (cdr Hp) (cdr Hp))) Ac Exp Money
                       Move Arm Armor Sield
                       ;Item 使用したアイテムの個数を1減らす
                       (let ((t-i-list (car (filter (lambda (x)
                                                      (string=? (ITEM-Iname (car (BATTLE-U-ITEM w))) (ITEM-Iname (car x)))) Item)))
                             (not-t-i-list (filter (lambda (x) ((compose not string=?)
                                                         (ITEM-Iname (car (BATTLE-U-ITEM w))) (ITEM-Iname (car x)))) Item)))
                         `(,(cons (car t-i-list) (- (cdr t-i-list) 1)) ,@not-t-i-list)) ;アイテム減らすここまで
                       Skill Str Int Wis Dex Con Chr) ;ここまでNew-hero
                  (d-pair->posn (cons x y)))))) ;ここで座標をCons
                 (("HO") (set-BATTLE-ITEM! w 0) (BATTLE-C-LIST w));HOの場合はBATTLE-ITEMに0（True)
                (else (BATTLE-C-LIST w)));C-LISTおこまで
              (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MAGIC w)
              (BATTLE-MONEY w) (BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w) (BATTLE-TEXT w)
              (BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w)))

          ((number? (BATTLE-U-ITEM w)) ;U-ITEMが Number なら
             (BATTLE
              (BATTLE-C-LIST w)  (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MAGIC w) (BATTLE-MONEY w)
    (BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w) (BATTLE-TEXT w)  (BATTLE-MENU w)
         (cond ((key=? a-key "up") (if (= (BATTLE-U-ITEM w) 0) 0 (- (BATTLE-U-ITEM w) 1)))
          ((key=? a-key "down") (if (< (+ 1 (BATTLE-U-ITEM w)) (length Item)) (+ (BATTLE-U-ITEM w) 1) (BATTLE-U-ITEM w)))
          ((key=? a-key "\r") (list-ref Item (BATTLE-U-ITEM w))) ;Enterを押すとItemの該当部分をBATTLE-U-ITEMにセット (item . 個数)
          (else (BATTLE-U-ITEM w)))
                (BATTLE-C-MAGIC w))) ;ここまでU-ITEMが Numberなら


               
             (else ;U-ITEM False
              (BATTLE  (BATTLE-C-LIST w) (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MAGIC w) (BATTLE-MONEY w)
                         (BATTLE-EXP w) (BATTLE-E-ZAHYO w) (BATTLE-STATUS w) (BATTLE-TEXT w)
                  (cond ((key=? a-key "y") #f)
                         (else (BATTLE-MENU w)))
                  (cond ((key=? a-key "i") (if (null? (filter (lambda (x) (< 0 (cdr x))) Item)) #f 0))
                         (else (BATTLE-U-ITEM w)))
                  (cond ((key=? a-key "m") (if (null? (filter (lambda (x) (< 0 (cdr x))) Skill)) #f 0))
                         (else (BATTLE-C-MAGIC w)))))))
            (else w)))))))) ;case BATTLE-MENU


(define (end w) ;終了条件
 (or
  (null? (map variant (map car (filter (lambda (x) (symbol=? 'ENEMY (variant (car x))))  (BATTLE-C-LIST w)))))
  (null? (map variant (map car (filter (lambda (x) (symbol=? 'HERO (variant (car x))))  (BATTLE-C-LIST w)))))))

(define (ending w) ;終了画面
      (if (null? (map variant (map car (filter (lambda (x) (symbol=? 'ENEMY (variant (car x))))  (BATTLE-C-LIST w)))))
     (place-image (text (format "敵を殲滅した!

   ~aゴールドと経験値~aを得た!" (BATTLE-MONEY w) (BATTLE-EXP w))

  15 "white")
         300
         200
         (empty-scene *width* *height* "black"))
          (place-image (text (format "君たちは全滅した! すべてを失った!")

  15 "white")
         300
         200
         (empty-scene *width* *height* "black"))))

(define (set-on-tick w) ;On-tickでの処理
   (let ((dir (posn->d-pair (cdr (car (BATTLE-C-LIST w))))))
     (let ((x (car dir)) (y (cdr dir)))
    (cond ((symbol=? (hero-or-enemy w) 'ENEMY)
      (match-let (((ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (car (car (BATTLE-C-LIST w)))))
           (BATTLE 
           (key-funcE x y w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
            (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MAGIC w) (BATTLE-MONEY w)
    (BATTLE-EXP w) #f (BATTLE-STATUS w) (BATTLE-TEXT w)(BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w))))
          (else
           (BATTLE
            (BATTLE-C-LIST w)                                                         
            (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MAGIC w) (BATTLE-MONEY w)
    (BATTLE-EXP w) #f (BATTLE-STATUS w) (BATTLE-TEXT w)(BATTLE-MENU w) (BATTLE-U-ITEM w) (BATTLE-C-MAGIC w)))))))
          

;メインBig-bang
(define (big-test x)
(big-bang x 
 (to-draw place-herolist)
  (on-tick set-on-tick 1/2)
  (on-key change)
  (stop-when end ending) 
 (name "DD&D") 
))


(big-test test-battle-struct)
#;

 (BATTLE-C-LIST (let ((w test-battle-struct))
 (for-each (lambda (x) (set-CHARACTER-Hp! (car x)
                                                     (if (> (car (CHARACTER-Hp (car x))) (cdr (CHARACTER-Hp (car x))))
                                                         (cons (cdr (CHARACTER-Hp (car x))) (cdr (CHARACTER-Hp (car x))))
                                                         (CHARACTER-Hp (car x))))) (BATTLE-C-LIST w)) w))

