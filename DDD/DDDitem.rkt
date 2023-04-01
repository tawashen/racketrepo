#lang racket

(require 2htdp/universe 2htdp/image lang/posn)
(require describe)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require "DDDstruct.rkt")
(require "DDDutility.rkt")
(provide (all-defined-out))



;アイテムインスタンス;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define B001 (BUKI "ロングソード" 15 '(1 . 6) '(1 . 8) '(19 . 2) 0 4 1 '()))
(define A001 (ARMOR "チェインメイル" 150 6 2 -5 30 20 15 40))
(define S001 (SIHELD "バックラー" 5 1 0 -1 5 5))
(define I001 (ITEM "やくそう" 10 "HS" 10)) ;回復自分　HS
(define I002 (ITEM "高級薬草" 20 "HS" 20)) ;回復自分　HS
(define I003 (ITEM "投げ薬草" 20 "HO" 10)) ;回復他人も　HO
(define I004 (ITEM "うんこ" 5 "AS" 20)) ;攻撃敵単体 AS
(define M001 (MAGIC "メラ" "AS" 1 "WIZ" 10)) ;攻撃敵単体　AS
(define M002 (MAGIC "イオ" "AC" 3 "SOR" 20)) ;攻撃敵全体　AC
(define M003 (MAGIC "ホイミ" "HO" 1 "CRE" 20)) ;味方単体回復 HO
(define M004 (MAGIC "ベホマラー" "HC" 5 "CRE" 20)) ;味方全体回復 HC

;攻撃
;(sleep poison paralsys silence stone curse)
(define sleep-attack (lambda (x) (set-CHARACTER-Ali! x `(,(random 1 3) 0 0 0 0 0))))　;xはCHARACTER
(define poison-attack (lambda (x)  (set-CHARACTER-Ali! x `(0 ,(random 1 3) 0 0 0 0))))
(define paralsys-attack (lambda (x)  (set-CHARACTER-Ali! x `(0 0 ,(random 1 3) 0 0 0))))
(define silence-attack (lambda (x)  (set-CHARACTER-Ali! x `(0 0 0 ,(random 1 3) 0 0))))
(define stone-attack (lambda (x)  (set-CHARACTER-Ali! x `(0 0 0 0 ,(random 1 3) 0))))
(define curse-attack (lambda (x)   (set-CHARACTER-Ali! x `(0 0 0 0 0 ,(random 1 3)))))

  
(define hit-attack (lambda (C-flag Attack teki-zahyo Target w Arm Str Name EName EHp EImage ERace EClass EAli
                                   ELv EAc EExp EMoney EMove EArm EArmor ESield EItem ESkill EStr EInt EWis EDex
                                   ECon EChr x x-dir y y-dir)
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
             (let ((new-target (cons (HERO EName EImage ERace EClass EAli ELv new-EHp EAc EExp EMoney EMove EArm EArmor
                        ESield EItem ESkill EStr EInt EWis EDex ECon EChr) (d-pair->posn (cons (+ x x-dir) (+ y y-dir))))))
                (set-CHARACTER-Hp!  (car (car (filter (lambda (z) (equal? teki-zahyo (cdr z))) (BATTLE-C-LIST w)))) new-EHp))))))


(define test-skill `(,sleep-attack ,poison-attack ,paralsys-attack)); ,hit-attack ,hit-attack ,hit-attack ,hit-attack))
(define test-enemy (ENEMY "tawa" (bitmap/file "picture/03.png") "ELF" "FIGHTER" '(0 0 0 0 0 0) 1 '(120 . 100) 10 0 90 '(6 . 6)
                 `(,B001) `(,A001) `(,S001) `((,I001 . 1) (,I002 . 2) (,I003 . 2) (,I004 . 2)) test-skill 10 18 6 11 9 10))
(define test-hero (HERO "tawa" (bitmap/file "picture/03.png") "ELF" "FIGHTER" '(0 0 0 0 0 0) 1 '(120 . 100) 10 0 90 '(6 . 6)
                 `(,B001) `(,A001) `(,S001) `((,I001 . 1) (,I002 . 2) (,I003 . 2) (,I004 . 2)) `((,M001 . 3) (,M002 . 2) (,M003 . 3) (,M004 . 3)) 10 18 6 11 9 10))


(define (attack-select chara target) ;CHARACTER->CHARACTER
  ((list-ref (CHARACTER-Skill chara) (random 0 (length (CHARACTER-Skill chara)))) target))
(attack-select test-enemy test-hero)
(CHARACTER-Ali test-hero)