#lang racket

(require "4king-data.rkt")
(require "4king-print.rkt")
(provide (all-defined-out))


;プロンプト付きINPUT関数
(define input
 (case-lambda
  (() (input ""))
  ((prompt) (display prompt)(newline)
       (read-line))))


;;;;;;;;;;;;;;;;;;移動用チェック述語
(define (hidari-ue? current)
  (if (= 0 current) #f #t))
(define (migi-ue? current)
  (if (= 6 current) #f #t))
(define (hidari-sita? current)
  (if (= 42 current) #f #t))
(define (migi-sita? current)
  (if (= 48 current) #f #t))
(define (hidari? current)
  (if (= 0 (modulo current 7)) #f #t))
(define (migi? current)
  (if (= 0 (modulo (+ 1 current) 7)) #f #t))
(define (ue? current)
  (if (> 7 current) #f #t))
(define (sita? current)
  (if (< 42 current) #f #t))



;PHASE用Circular関数
(define (circular lst)
  (flatten (cons (cdr lst) (car lst))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;関数
(define (change-coord direct w num)
  (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) w))
    (let* ((new-coord (list-set COORD PHASE (+ (list-ref COORD PHASE) num)))
           (new-pmap (make-players-map new-coord)))
      (WORLD PLAYERS SMAP new-pmap PHASE new-coord WIN))))
  
  


;整形後のPlayers配置マップを作る関数、これで移動後にworldを作り直す
(define (make-players-map new-coord)
  (split-list (map align-string (map (lambda (x) (number->string x)) (put-player *player-zero* 1 new-coord)))))

;判定用サイコロ関数
(define (dice)
  (+ (+ 1 (random 6)) (+ 1 (random 6))))
   
;LIST内の特定の要素の場所を返す
(define (list-index num lst count)
  (cond ((null? lst) #f)
         ((= num (car lst)) count)
         (else (list-index num (cdr lst) (+ 1 count)))))


;敵ごとにランダムで味方へ攻撃対象を決める(IndexのListで)
(define (random-list e-num p-num e-attack-list)
	(if (null? e-num) (reverse e-attack-list)
		(random-list (cdr e-num) p-num (cons (random (length p-num)) e-attack-list))))

;多次元リストを1次元リストに
(define (flat-list lst new-list)
  (if (null? lst) (reverse new-list)
      (flat-list (cdr lst) (append
      (let loop ((lst2 (car lst)) (new-list0 '()))
        (if (null? lst2) new-list0
            (loop (cdr lst2) (cons (car lst2) new-list0))))
            new-list))))


#;
(flatten-list '(((battle-ressei "勇者スペードのジャック" "大ねずみA" -2 0) (battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0))
  ((battle-nasi "" "" 0 0) (battle-ressei "恋人ダイヤのジャック" "大ねずみB" -2 0) (battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0))
  ((battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0) (battle-kawasare "弟子ハートのジャック" "大ねずみC" 0 0) (battle-nasi "" "" 0 0))))

#;
(flat-list '(((battle-ressei "勇者スペードのジャック" "大ねずみA" -2 0) (battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0))
  ((battle-nasi "" "" 0 0) (battle-ressei "恋人ダイヤのジャック" "大ねずみB" -2 0) (battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0))
  ((battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0) (battle-kawasare "弟子ハートのジャック" "大ねずみC" 0 0) (battle-nasi "" "" 0 0))) '())

(define lst2 '(((battle-ressei "勇者スペードのジャック" "大ねずみA" -2 0) (battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0))
  ((battle-nasi "" "" 0 0) (battle-ressei "恋人ダイヤのジャック" "大ねずみB" -2 0) (battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0))
  ((battle-nasi "" "" 0 0) (battle-nasi "" "" 0 0) (battle-kawasare "弟子ハートのジャック" "大ねずみC" 0 0) (battle-nasi "" "" 0 0))))


            
  


