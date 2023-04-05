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

;数字の表示桁数揃える関数
(define (align-num num)
      (cond
                     ((= 1 (string-length (number->string num))) (string-append "00" (number->string num)))
                     ((= 2 (string-length (number->string num))) (string-append "0" (number->string num)))
                     ((= 3 (string-length (number->string num))) (number->string num))))

;リスト内の要素を
(define (list-satisfies? lst pred)
  (cond
    [(empty? lst) #t] ; リストが空の場合は常に真を返す
    [(pred (first lst)) (list-satisfies? (rest lst) pred)] ; 要素が述語を満たす場合は、残りのリストに再帰する
    [else #f])) ; それ以外の場合は偽を返す