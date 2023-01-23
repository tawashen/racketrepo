#lang racket













(struct AD&D (STR INT DEX CON CHR))
(struct Char (Name Str Int Dex Con Chr) #:transparent)

(define HUMAN (AD&D 0 0 0 0 0))
(define ELF (AD&D -2 2 0 -2 2))

(define (chara-make race)
  (match-let (((AD&D STR INT DEX CON CHR) race))
    (match-let (((list str int dex con chr)
                 (map (lambda (x) (+ x (+ (random 1 7) (random 1 7) (random 1 7)))) `(,STR ,INT ,DEX ,CON ,CHR))))
              (display (format "STR:~a INT:~a DEX:~a CON:~a CHR:~a" str int dex con chr))
      (newline) (display "[y]es or [n]o?") (newline)
      (let ((yes-no (read)))
        (if (symbol=? yes-no 'y)
            (begin (display "input your name") (newline)
                   (let ((name (read)))
                     (Char name str int dex con chr)))
            (chara-make race))))))

(chara-make ELF)







