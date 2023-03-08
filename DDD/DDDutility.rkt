#lang racket

(require 2htdp/universe 2htdp/image lang/posn)
(require describe)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require "DDDstruct.rkt")
(require "DDDval.rkt")
(provide (all-defined-out))


(define (d-pair->posn d-pair)
 (hash-ref *d-pairs->posns-table* d-pair))

(define (posn->d-pair posn)
 (hash-ref *posns->d-pairs-table* posn))


;Enumerate
(define enumerate
 (case-lambda
  ((seq) (enumerate seq 0))
  ((seq start) (map (lambda (x y)
           (cons x y))
          (range start (+ (length seq) start))
          seq))))


;D20
(define D20 (case-lambda
              (() (random 1 21))
              ((x) (do ((x1 x (- x1 1)) (p 0 (+ p (random 1 21)))) ((= x1 0) p)))))

;筋力ボーナス関数
(define (Mbonus Str)
  (cond ((<= 18 Str) 3)
        ((<= 16 Str) 2)
        ((<= 14 Str) 1)
        (else 0)))
  
;攻撃ボーナス関数
(define (Bbonus w Name Race Class Lv Hp Arm Str Dex Con)
  (case Class
    (("FIGHTER") (+ 10 Lv (Mbonus Str)  0 (D20)))))

;命中判定
(define (hit? Attack EName ERace EClass ELv EHp EAc EArm EArmor ESield ESkill EStr EDex ECon)
  (if (< EAc Attack) #t #f))