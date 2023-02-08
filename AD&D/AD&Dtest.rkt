#lang racket

;utility
;Enumerate
(define enumerate
 (case-lambda
  ((seq) (enumerate seq 0))
  ((seq start) (map (lambda (x y)
           (cons x y))
          (range start (+ (length seq) start))
          seq))))

;選択肢の毎回の省略
(define (sentakusi-num? num lst) 
  (cond ((or (< num 0) (> num (length lst))) #f)
        (else #t)))

;構造体とインスタンス作成
(struct ABILITY (RACE STR INT WIS DEX CON CHR))
(struct CHARACTER (Name Race Class Ali Lv Hp Ac Exp Money Move Str Int Wis Dex Con Chr) #:transparent)

(define HUMAN (ABILITY "HUMAN" 0 0 0 0 0 0))
(define ELF (ABILITY "ELF" -2 2 0 0 -2 2))

(define *chara-list* '())
(define *member-list* '())

;種族を引数にして能力値とか
(define (chara-make race)
  (match-let (((ABILITY RACE STR INT WIS DEX CON CHR) race))
    (match-let (((list str int wis dex con chr)
                 (map (lambda (x) (+ x (+ (random 1 7) (random 1 7) (random 1 7)))) `(,STR ,INT ,WIS ,DEX ,CON ,CHR))))
      (let ((hp (+ (random 1 10) CON)) (ac (- 10 DEX)) (money (random 50 150)) (move (+ (random 5 8) DEX)))
              (display (format "STR:~a INT:~a WIS:~a DEX:~a CON:~a CHR:~a" str int wis dex con chr))
        (newline)
              (display (format "HP:~a AC:~a MONEY:~a MOVE:~a" hp ac money move))
      (newline) (display "[y]es or [n]o?") (newline)
      (let ((yes-no (read)))
        (if (symbol=? yes-no 'y)
            (begin (display "input your name") (newline)
                   (let ((name (symbol->string (read))))
                     (class-check
                     (CHARACTER name RACE "" "" 0 hp ac 0 money move str int wis dex con chr))))
   
            (chara-make race)))))))

(struct CLASS (NAME REQUIRE))
(define FIGHTER (CLASS "FIGHTER" 'Str))
(define MAGIC-USER (CLASS "MAGIC-USER" 'Int))
(define CLERIC (CLASS "CLERIC" 'Wis))
(define THIEF (CLASS "THIEF" 'Dex))
(define *class-list-human* `(,FIGHTER ,MAGIC-USER ,CLERIC ,THIEF))
(define *class-list-elf* `(,FIGHTER ,MAGIC-USER ,THIEF))




#|
(define (check-status lst)
  (if (>= (cadr lst) 13)
      (car lst) #f))
|#

(define (class-check chara)
  (match-let (((CHARACTER Name Race Class Ali Lv Hp Ac Exp Money Move Str Int Wis Dex Con Chr) chara))
    (let* ((class-list '())
          (ability-list (filter (lambda (abi) (>= (cdr abi) 13))
                                                 `((Str . ,Str) (Int . ,Int) (Wis . ,Wis) (Dex . ,Dex))))
          (list (map CLASS-NAME (flatten (map (lambda (x)
                                         (filter (lambda (y) (symbol=? (car x) (CLASS-REQUIRE y)))
                                                 *class-list*)) ability-list)))))
      (case Race
         (("HUMAN") (for-each display
                              (map (match-lambda (`(,index . ,name)
                                   (format "[~a:~a]" index name)))         
                          (enumerate list 1))))
        (("ELF") (for-each display
                              (map (match-lambda (`(,index . ,name)
                                   (format "[~a:~a]" index name)))         
                          (enumerate list 1))))))))
#|    
      (display ("No?")) (newline)
      (let ((choice-class (read)))
        (cond ((sentakusi-num? choice-class (map CLASS-NAME (flatten (map (lambda (x)
                                         (filter (lambda (y) (symbol=? (car x) (CLASS-REQUIRE y)))
                                                 *class-list*)) ability-list))))
        )))) |#
      ;  (display "NO")))))
        
(chara-make HUMAN)

;(map CLASS-NAME (flatten (chara-make HUMAN)))








