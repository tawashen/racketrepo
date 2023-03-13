#lang racket

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
      
      (cond ((null? capable-list) (display "君はどの職業にも就くことが出来ない!") (sleep 3) (newline)
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

(first-menu)