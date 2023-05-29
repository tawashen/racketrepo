#lang racket

(require racket/struct)
(require racket/match)
(require "4king-data.rkt")

;(random 3)


(define (list-index num lst count)
  (cond ((null? lst) #f)
         ((= num (car lst)) count)
         (else (list-index num (cdr lst) (+ 1 count)))))

;(list-index 3 '(1 2 3 4) 0)


;LIST内の特定の要素の場所を返す
(define (list-index2 num lst count)
  (cond ((null? lst) #f)
         ((= num (car lst)) count)
         (else (list-index num (cdr lst) (+ 1 count)))))


;(battle-zero 2 '(1 1 2) '(1 1 2) 1 '() 1)

(define (battle-zero car-command-list enemy-attack-list p-count e-count damage-list);counterは一つ上のLoopで1から増やす
  (cond ((null? enemy-attack-list) (reverse damage-list))
        ((and (= e-count car-command-list) (= p-count (car enemy-attack-list)));taiman
         (battle-zero car-command-list (cdr enemy-attack-list) p-count (+ 1 e-count)
                      (cons "taiman" damage-list)))
              ((= p-count (car enemy-attack-list))
         (battle-zero car-command-list (cdr enemy-attack-list) p-count (+ 1 e-count)
         (cons "bousen" damage-list)))
              ((and (not (= p-count (car enemy-attack-list))) (= e-count car-command-list))  
              (battle-zero car-command-list (cdr enemy-attack-list) p-count (+ 1 e-count)
         (cons "ippouteki" damage-list)))
        (else  (battle-zero car-command-list (cdr enemy-attack-list)  p-count (+ 1 e-count)
         (cons "nanimonai" damage-list)))))

(battle-zero 1 '(3 2 1) 1 1 '())

(define (battle-map command-list enemy-attack-list p-count damage-lists)
  (if (null? command-list) (reverse damage-lists)
      (battle-map (cdr command-list) enemy-attack-list (+ 1 p-count)
                  (cons (battle-zero (car command-list) enemy-attack-list p-count 1 '()) damage-lists))))

(battle-map '(1 2 3 4) '(2 2 3 4) 1 '())