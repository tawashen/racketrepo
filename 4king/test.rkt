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


(define (battle-zero car-command-list enemy-attack-list counter damage-list);counterは一つ上のLoopで1から増やす
  (cond ((null? enemy-attack-list) (reverse damage-list))
        ((= (+ counter car-command-list)  (car enemy-attack-list))
         (battle-zero car-command-list (cdr enemy-attack-list) counter
                      (cons "taiman" damage-list)))
        ((and (not (equal? car-command-list (car enemy-attack-list))) (= counter (car enemy-attack-list)))
         (battle-zero car-command-list (cdr enemy-attack-list) counter
         (cons "bousen" damage-list)))
        ((and (not (equal? car-command-list (car enemy-attack-list))) (not (equal? 
        ((and (not (equal? car-command-list (car enemy-attack-list))) (not (equal? (+ 1 counter) (car enemy-attack-list))))
         (battle-zero car-command-list (cdr enemy-attack-list) counter
         (cons "ippouteki" damage-list)))
        (else 

;(battle-zero 2 '(2 3 1) 1 '())

(define (battle-map command-list enemy-attack-list counter damage-lists)
  (if (null? command-list) (reverse damage-lists)
      (battle-map (cdr command-list) enemy-attack-list (+ 1 counter)
                  (cons (battle-zero (car command-list) enemy-attack-list counter '()) damage-lists))))

(battle-map '(1 1 2 3) '(2 1 3 3) 0 '())