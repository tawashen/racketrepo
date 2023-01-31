#lang racket

(require srfi/1)
(require srfi/13)

(provide (all-defined-out))

(require "util.rkt")
;(require "messages.rkt")
;(require "enemy.rkt")


(struct item (Iname Cost Ipage Times Point Att) #:transparent)

(define I001 (item "素手" 0 0 0 0 "Buki"))
(define I002 (item "素肌" 0 0 0 0 "Bougu"))
(define I003 (item "スパナ" 0 0 0 2 "Buki"))
(define I004 (item "モンキー" 0 0 0 4 "Buki"))
(define I005 (item "レンチ" 0 0 0 3 "Buki"))
(define I006 (item "ブラックジャック" 0 0 0 5 "Buki"))


(define *item-list* `(,I001 ,I002 ,I003 ,I004 ,I005 ,I006))

(define *equip* '(
                  ("素手" . +inf.0)
                  ("素肌" . +inf.0)
                  ("スパナ" . 1)
                  ("モンキー" . 1)
                  ("レンチ" . 1)
                  ("火薬ビン" . 0)
                  ("ランチャーの弾" . 3)
                  ("ブラックジャック" . 0)
                  ("ポムじいさん" . 0)
                  ))


;特定属性のitem構造体リストを作る
(define (att-list lst att)
  (filter (lambda (a) (string=? att (item-Att a))) lst))

;バトル時に使用可能武器の構造体を返す
(define (buki-list lst) ;lstはmaster-Equip
  ;item構造体のリストを返したい↓
  (filter (lambda (y) ((compose not (compose not member)) (car y) (map item-Iname (att-list *item-list* "Buki"))))
  ;手持ち装備品で0でないものをリストアップしたい↓
  (filter (lambda (x) ((compose not zero?) (cdr x))) lst)))

;バトル時に使用可能なリストを表示する
(define (buki-show lst)
 (for-each display  (map (match-lambda (`(,index . (,name . ,val))
                      (format "[~a:~a]" index name)))
                          (enumerate (buki-list lst) 1))))

;(buki-show *equip*)
