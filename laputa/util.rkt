#lang racket


(require srfi/1)
(require srfi/13)

(provide (all-defined-out))

;戦闘中の一瞬の間を作る
(define (wait)
  (sleep 1))

;戦闘用サイコロ
(define (dice) 
  (random 1 7))

;cametanさん製Enumrate関数
(define enumerate
 (case-lambda
  ((seq) (enumerate seq 0))
  ((seq start) (map (lambda (x y)
           (cons x y))
          (range start (+ (length seq) start))
          seq))))

;プロンプト付きINPUT関数
(define input
 (case-lambda
  (() (input ""))
  ((prompt) (display prompt)(newline)
       (read-line))))

;Equip更新関数 Cametanさん提供版
(define (equip-change lst index num)
 (match-let ((`(,index . ,val) (assoc index lst)))
  (alist-cons index (+ num val) (alist-delete index lst))))



;Equip更新関数
(define (equip-changeT lst index num)
  (if (null? lst)
     '()
     (if (string=? index (car (car lst)))
        (cons `(,index . ,(+ num (cdr (car lst)))) (equip-changeT (cdr lst) index num))
        (cons `(,(car (car lst)) . ,(cdr (car lst))) (equip-changeT (cdr lst) index num)))))



;リスト作成用関数
(define (make-dot-list str end)
  (map (lambda (x) (cond
                     ((= 1 (string-length (number->string x))) (string-append "" str "00" (number->string x)))
                     ((= 2 (string-length (number->string x))) (string-append "" str "0" (number->string x)))
                     ((= 3 (string-length (number->string x))) (string-append "" str (number->string x)))))
                     (range 1 (+ end 1))))

;(for-each display (make-dot-list "P" 220))


#|
;Equipしてるかチェック述語
(define (equip? equip index)
  (let ((Cequip-list  (filter (lambda (x) ((compose not zero?) (cdr x))) equip)))
  (if (null? Cequip-list)
     #f
     (if (string=? index (car (car Cequip-list)))
        #t
        (equip? (cdr equip) index)))))
|#


;Equipしてるかチェックする述語Cametanさん提供
(define (equip? equip index)
  (let ((Cequip-list (filter (lambda (x)
                               ((compose not zero?) (cdr x))) equip)))
    (and ((compose not null?) Cequip-list)
        (or (string=? index (caar Cequip-list))
           (equip? (cdr equip) index)))))

;ドラクエ風に文字を表示する
(define (display-G str)
 (string-for-each (lambda (x) (sleep 0.05) (flush-output) (display x)) str))


;Hit any key関数
(define (HAK)
  (newline)
  (display "Hit Enter-key!")
  (newline)
  (let ((key (read-line)))
    (if (string=? "" key) (newline)
        HAK)))


