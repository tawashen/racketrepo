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
(define (hit? Attack EAc Target)
  (if (< 0 (list-ref (CHARACTER-Ali (car Target)) 0)) #t ;sleepとparalsysなら必中
  (cond ((< EAc Attack) #t)
        (else #f))))

;数字の表示桁数揃える関数
(define (align-num num)
      (cond
                     ((= 1 (string-length (number->string num))) (string-append "00" (number->string num)))
                     ((= 2 (string-length (number->string num))) (string-append "0" (number->string num)))
                     ((= 3 (string-length (number->string num))) (number->string num))))

;リスト内の要素を探索して全部が要求を満たせば#t
(define (list-satisfies? lst pred)
  (cond
    [(empty? lst) #t] ; リストが空の場合は常に真を返す
    [(pred (first lst)) (list-satisfies? (rest lst) pred)] ; 要素が述語を満たす場合は、残りのリストに再帰する
    [else #f])) ; それ以外の場合は偽を返す


(define hit-attack (lambda (C-flag Attack teki-zahyo Target w Arm Str Name EName EHp EImage ERace EClass EAli
                                   ELv EAc EExp EMoney EMove EArm EArmor ESield EItem ESkill EStr EInt EWis EDex
                                   ECon EChr x x-dir y y-dir)
      (let* ((damage-pre (if C-flag ;ダメージ計算
                        (if (hit? Attack EAc Target)
                            (begin
                                   (set-BATTLE-TEXT! w "CH")
                                   (+ (* (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm))))
                                         (cdr (BUKI-Bcrit (car Arm)))) (Mbonus Str)))                           
                            (begin
                                   (set-BATTLE-TEXT! w "H")
                                   (+ (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm)))) (Mbonus Str))))
                        (if (hit? Attack EAc Target) (begin
                                   (set-BATTLE-TEXT! w "H")
                                   (+ (random (car (BUKI-BdamageM (car Arm))) (cdr (BUKI-BdamageM (car Arm)))) (Mbonus Str)))
                            (begin
                                   (set-BATTLE-TEXT! w "M") 0))))
             (damage (if (< 0 (list-ref (CHARACTER-Ali (car Target)) 0)) ;スリープ状態か？
                         
                                (* 2 damage-pre) damage-pre))) ;sleep状態ならダメージ倍
        (set-BATTLE-TEXT! w (cons (BATTLE-TEXT w) damage)) (set-BATTLE-STATUS! w (cons Name EName))
        (if (< 0 damage) (begin (set-CHARACTER-Ali! (car Target) '(0 0 0 0 0 0)) ;攻撃がヒットすると目が覚める
                                (set-BATTLE-E-ZAHYO! w teki-zahyo)) (set-BATTLE-E-ZAHYO! w #f))
       (let ((new-EHp (cons (- (car EHp) damage) (cdr EHp)))) 
             (let ((new-target (cons (HERO EName EImage ERace EClass EAli ELv new-EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))
                (set-CHARACTER-Hp!  (car (car (filter (lambda (z) (equal? teki-zahyo (cdr z))) (BATTLE-C-LIST w)))) new-EHp))))))


(define (attack-select chara target) ;CHARACTER->CHARACTER
  ((list-ref (CHARACTER-Skill chara) (random 0 (length (CHARACTER-Skill chara)))) target))


;攻撃
;(sleep poison paralsys silence stone curse)
(define sleep-attack (lambda (x) (set-CHARACTER-Ali! x `(,(random 5 9) 0 0 0 0 0)))) ;xはCHARACTER
(define poison-attack (lambda (x)  (set-CHARACTER-Ali! x `(0 ,(random 1 3) 0 0 0 0))))
(define paralsys-attack (lambda (x)  (set-CHARACTER-Ali! x `(0 0 ,(random 1 3) 0 0 0))))
(define silence-attack (lambda (x)  (set-CHARACTER-Ali! x `(0 0 0 ,(random 1 3) 0 0))))
(define stone-attack (lambda (x)  (set-CHARACTER-Ali! x `(0 0 0 0 ,(random 1 3) 0))))
(define curse-attack (lambda (x)   (set-CHARACTER-Ali! x `(0 0 0 0 0 ,(random 1 3)))))


