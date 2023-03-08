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
         (,(HERO "tawa" (bitmap/file "picture/03.png") "ELF" "FIGHTER" "" 1 6 10 0 90 '(6 . 6) `(,B001) `(,A001) `(,S001) '() '() 10 18 6 11 9 10) . ,(make-posn '93 '155))
         (,(HERO "hosida" (bitmap/file "picture/03.png") "HUMAN" "FIGHTER" "" 1 1 10 0 90 '(6 . 6) `(,B001) `(,A001) `(,S001) '() '() 17 10 12 8 15 14) . ,(make-posn '93 '93))
                                       
    
         (,(ENEMY "DEMON1" (bitmap/file "picture/04.png") "ENEMY" "" ""  1 100 10 0 90 '(3 . 3) '() '() '() '() '() 10 10 10 2 10 10) . ,(make-posn '155 '155))
         (,(ENEMY "DEMON2" (bitmap/file "picture/04.png") "ENEMY" "" ""  1 1 100 0 90 '(3 . 3) '() '() '() '() '() 10 10 10 2 10 10) . ,(make-posn '217 '217)))
                                   > #:key (lambda (x) (case (variant (car x))
                                                           ((HERO) (CHARACTER-Dex (car x)))
                                                           ((ENEMY) (CHARACTER-Dex (car x))))))
                                                     0 1 '() 0 0 #f))
                                                   

;utility

;種族選択
(define (chara-make-zero)
  (displayln "race?")
  (let ((race-zero (read-line)))
    (case race-zero
      (("ELF" "elf" "E" "e") (chara-make ELF))
      (("HUMAN" "human" "H" "h") (chara-make HUMAN)))))
    
;種族を引数にして能力値とか
(define (chara-make race)
  (match-let (((ABILITY RACE STR INT WIS DEX CON CHR) race))
    (match-let (((list str int wis dex con chr)
                 (map (lambda (x) (+ x (+ (random 1 7) (random 1 7) (random 1 7)))) `(,STR ,INT ,WIS ,DEX ,CON ,CHR))))
      (let* ((hp1 (+ (random 1 10) CON)) (hp (if (<= hp1 0) 1 hp1))
                                         (ac (- 10 DEX)) (money (* 10 (random 5 15))) (move (+ (random 5 8) DEX)))
        (let ((ness-abi-list (case RACE
                      (("ELF") `(,str ,int ,dex))
                      (("HUMAN") `(,str ,int ,wis ,dex)))))
               (if (for/or ((i ness-abi-list)) (i . > . 12))
                   (disp-class-menu `(,str ,int ,wis ,dex ,con ,chr ,hp ,ac ,money ,move ,RACE))
                   (chara-make race)))))))

(define (disp-class-menu env)
  (match-let (((list str int wis dex con chr hp ac money move RACE) env))
              (display (format "STR:~a INT:~a WIS:~a DEX:~a CON:~a CHR:~a" str int wis dex con chr))
        (newline)
              (display (format "HP:~a AC:~a MONEY:~a MOVE:~a" hp ac money move))
      (newline) (display "[y]es or [n]o?") (newline)
      (let ((yes-no (read-line)))
        (if (string=? yes-no "y")
            (begin (display "input your name") (newline)
                   (let ((name (read-line)))
                     (class-check
                     (HERO name "" RACE "" "" 1 hp ac 0 money (cons move move) '() '() '() '() str int wis dex con chr))))
            (case RACE
                       (("ELF") (chara-make ELF))
                       (("HUMAN") (chara-make HUMAN)))))))

(define (class-check chara)
  (match-let (((HERO Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr) chara))
    (let* ((class-list '())
          (ability-list (filter (lambda (abi) (>= (cdr abi) 13))
                                                 `((Str . ,Str) (Int . ,Int) (Wis . ,Wis) (Dex . ,Dex))))
          (capable-list (map CLASS-NAME (flatten (map (lambda (x)
                                         (filter (lambda (y) (symbol=? (car x) (CLASS-REQUIRE y)))
                                                 (case Race
                                                   (("HUMAN") *class-list-human*)
                                                   (("ELF") *class-list-elf*)))) ability-list)))))
      
      (cond ((null? capable-list) (display "君はどの職業にも就くことが出来ない！") (sleep 3) (newline)
                                  (chara-make (case Race
                                                (("ELF") (chara-make ELF))
                                                (("HUMAN") (chara-make HUMAN)))))
            (else
                 (for-each display
                              (map (match-lambda (`(,index . ,name)
                                   (format "[~a:~a]" index name)))         
                          (enumerate capable-list 1))) (newline)
      (display "No?") (newline)
      (let ((choice-class (string->number (read-line))))
        (cond (((compose not number?) choice-class) (class-check chara))
              ((> choice-class (length capable-list)) (class-check chara))
              ((< choice-class 1) (class-check chara))
              (else (to-chara-list
                     (HERO Name (list-ref *images* 2) Race (list-ref capable-list (- choice-class 1))
                                Ali Lv Hp Ac Exp Money (cons Move Move) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))))))))))

(define (to-chara-list chara)
  (match-let (((HERO Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr) chara))
    (display "confirm [y]es or [n]o?") (newline)
      (let ((yes-no (read-line)))
        (if (string=? yes-no "y")
            (cons chara *chara-list*)
            (chara-make
             (case Race
               (("ELF") (chara-make ELF))
               (("HUMAN") (chara-make HUMAN))))))))


;最初期メニュー
(define (first-menu)
  (displayln "[C]reate character")
  (displayln "[A]dd character")
  (displayln "[B]egin adventure")
  (let ((choice (read-line)))
    (case choice
      (("A" "a") (display "add"))
      (("C" "c") (chara-make-zero)))))



;キャラクター配置関数
(define (place-character w)
  (match-let (((BATTLE C-LIST PHASE TURN ITEM MONEY EXP E-ZAHYO) w))
    (if E-ZAHYO
    (place-image (circle 32 "solid" "red") (posn-x (BATTLE-E-ZAHYO w)) (posn-y (BATTLE-E-ZAHYO w)) (place-image (square 64 "outline" "red") (posn-x (cdr (car C-LIST))) (posn-y (cdr (car C-LIST)))
    (foldr (lambda (data initial) (place-image (car data) (cadr data) (caddr data) initial)) *background*
    (map (lambda (x) 
         `(,(if (< 0 (CHARACTER-Hp (car x))) (CHARACTER-Image (car x)) "")
           ,(posn-x (cdr x))
           ,(posn-y (cdr x))))
         C-LIST))))
    (place-image (square 64 "outline" "red") (posn-x (cdr (car C-LIST))) (posn-y (cdr (car C-LIST)))
    (foldr (lambda (data initial) (place-image (car data) (cadr data) (caddr data) initial)) *background*
    (map (lambda (x) 
         `(,(if (< 0 (CHARACTER-Hp (car x))) (CHARACTER-Image (car x)) "")
           ,(posn-x (cdr x))
           ,(posn-y (cdr x))))
         C-LIST))))))
    


;キー判定関数
(define (key-func x x-dir y y-dir w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
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
                 (HERO Name Image Race Class Ali Lv Hp Ac Exp Money (cons (cdr new-move) (cdr new-move)) Arm Armor Item Sield Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))
                              (else (cons (cons
                 (HERO Name Image Race Class Ali Lv Hp Ac Exp Money (cons (car new-move) (cdr new-move)) Arm Armor Item Sield Skill Str Int Wis Dex Con Chr)
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
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money (cons (cdr new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y)))))
                                 ((member (cons (+ x x-dir) (+ y y-dir))  *map-posn*) ;移動先が石なら移動しないで次のキャラへ
                                  `(,@(cdr (BATTLE-C-LIST w)) ,(cons 
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money (cons (cdr Move) (cdr Move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y)))))
                                  (else ;移動できるが残り移動力が0なら移動後に移動力をリセットして次のキャラへ
                                 `(,@(cdr (BATTLE-C-LIST w)) ,(cons 
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money (cons (cdr new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))))
                         (else ;動いても移動力が残っている場合
                               (cond
                                 ((member (d-pair->posn (cons (+ x x-dir) (+ y y-dir))) ;移動先がENEMYなら移動しないで次のキャラへ
                    (map cdr (filter (lambda (x)
                          (symbol=? 'ENEMY (variant (car x)))) (cdr (BATTLE-C-LIST w)))))
                                  `(,@(cdr (BATTLE-C-LIST w)) ,(cons 
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money (cons (cdr new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y)))))
                                 ((member (cons (+ x x-dir) (+ y y-dir))  *map-posn*) ;移動先が石なら移動しないで次のキャラへ
                                  `(,@(cdr (BATTLE-C-LIST w)) ,(cons 
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money (cons (cdr new-move) (cdr new-move)) Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y)))))
                                 (else ;移動できて移動力が残っているなら左右へ動く
                                 (cons (cons
                 (ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money (cons (car new-move) (cdr new-move)) Arm Armor Item Sield Skill Str Int Wis Dex Con Chr)
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
(define (fight x x-dir y y-dir w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
  (let* ((C-flag (if (<= (BUKI-Bcrit (car Arm)) (D20)) #t #f)) (Attack (Bbonus w Name Race Class Lv Hp Arm Str Dex Con))
                                                               (teki-zahyo (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))
                                                      ;↓移動先のキャラを特定して読み込む
          (Target (car (filter (lambda (z)
                                 (equal?  (cdr z) teki-zahyo)) (BATTLE-C-LIST w)))))
    (match-let (((ENEMY EName EImage ERace EClass EAli ELv EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (car Target))) ;ENEMY情報を読み込む
      (let ((damage (if C-flag
                        (if hit? (+ (* (BUKI-BdamageM (car Arm)) (BUKI-Bcrit (car Arm))) (Mbonus Str))                           
                            (+ (BUKI-BdamageM (car Arm)) (Mbonus Str)))
                        (if hit? (+ (BUKI-BdamageM (car Arm)) (Mbonus Str)) 0)))) 
        (if (< 0 damage) (set-BATTLE-E-ZAHYO! w teki-zahyo) (set-BATTLE-E-ZAHYO! w #f))
        (let ((new-EHp (- EHp damage))) 
          (cond  ((< 0 new-EHp)
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
                 (HERO Name Image Race Class Ali Lv Hp Ac Exp Money (cons (cdr EMove) (cdr EMove)) Arm Armor Item Sield Skill Str Int Wis Dex Con Chr)
                  (d-pair->posn (cons x y))))))))))))


(define (change w a-key)
  (set-BATTLE-E-ZAHYO! w #f)
 (let ((dir (posn->d-pair (cdr (car (BATTLE-C-LIST w))))))
  (let ((x (car dir)) (y (cdr dir)))
   (BATTLE (cond
             ((symbol=? (variant (car (car (BATTLE-C-LIST w)))) 'HERO)
     (match-let (((HERO Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (car (car (BATTLE-C-LIST w)))))
      (cond
     ;((key=? a-key "/r") menu表示
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
     (else (BATTLE-C-LIST w)))))
                 
                 ((symbol=? (variant (car (car (BATTLE-C-LIST w)))) 'ENEMY)
      (match-let (((ENEMY Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr)
                  (car (car (BATTLE-C-LIST w)))))
           (key-funcE x y w Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr))))
    (BATTLE-PHASE w) (BATTLE-TURN w) (BATTLE-ITEM w) (BATTLE-MONEY w) (BATTLE-EXP w) (BATTLE-E-ZAHYO w)))))

(define (end w)
  ((compose not member) 'ENEMY (map variant (map car (filter (lambda (x) (symbol=? 'ENEMY (variant (car x))))  (BATTLE-C-LIST w))))))

    (define (ending w)
     (place-image (text (format "敵を殲滅した！

   ~aゴールドと経験値~aを得た！" (BATTLE-MONEY w) (BATTLE-EXP w))

  15 "white")
         300
         200
         (empty-scene *width* *height* "black")))

;#;
(big-bang test-battle-struct
 (to-draw place-character)
  (on-key change)
  (stop-when end ending) 
 (name "DD&D") 
)

;(define tawa
;(begin (set-BATTLE-E-ZAHYO! test-battle-struct #t) (BATTLE-E-ZAHYO test-battle-struct)) 


