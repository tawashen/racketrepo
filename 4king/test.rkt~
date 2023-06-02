#lang racket

(require srfi/1)
(require racket/struct)
(require racket/match)
(require "4king-data.rkt")
(require "4king-util.rkt")




;(battle-zero 2 '(1 1 2) '(1 1 2) 1 '() 1)


(define (battle-zero player enemy car-command-list enemy-attack-list p-count e-count damage-list)
  (cond ((null? enemy-attack-list) (display (reverse damage-list)))
        ((and (= e-count car-command-list) (= p-count (car enemy-attack-list)));タイマン通常戦闘
          (battle-zero player enemy car-command-list (cdr enemy-attack-list) p-count (+ 1 e-count)
           (cons (let-values (((mes name e-name p-damage e-damage) (taiman player enemy e-count)))
                   `(,mes ,name ,e-name ,p-damage ,e-damage)) damage-list)))
         ((= p-count (car enemy-attack-list));敵だけがこちらを攻撃
        　(battle-zero player enemy car-command-list (cdr enemy-attack-list) p-count (+ 1 e-count)
           (cons (let-values (((mes name e-name p-damage e-damage) (bousen player enemy e-count)))
                   `(,mes ,name ,e-name ,p-damage ,e-damage)) damage-list)))
         ((and (not (= p-count (car enemy-attack-list))) (= e-count car-command-list));こちらだけ攻撃
          (battle-zero player enemy car-command-list (cdr enemy-attack-list) p-count (+ 1 e-count)
           (cons (let-values (((mes name e-name p-damage e-damage) (ippouteki player enemy e-count)))
                   `(,mes ,name ,e-name ,p-damage ,e-damage)) damage-list)))
         (else  (battle-zero player enemy car-command-list (cdr enemy-attack-list)  p-count (+ 1 e-count);どちらも狙ってない
           (cons (let-values (((mes name e-name p-damage e-damage) (values 'battle-nasi "" "" 0 0)))
                   `(,mes ,name ,e-name ,p-damage ,e-damage)) damage-list)))))


(define (taiman player enemy e-count)
  (match-let (((PLAYER NAME SKILLP HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) (car player)))
    (match-let (((ENEMY E-NAME E-SKILLP E-HITP) (list-ref enemy (- e-count 1))))
      (let ((p-attack (+ (car SKILLP) (dice))) (e-attack (+ E-SKILLP (dice))))
        (cond ((= p-attack e-attack) (values 'battle-gokaku NAME E-NAME 0 0))
              ((> p-attack e-attack) (values 'battle-yusei NAME E-NAME 0 -2))
              (else (values 'battle-ressei NAME E-NAME -2 0)))))))

(define (bousen player enemy e-count)
  (match-let (((PLAYER NAME SKILLP HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) (car player)))
    (match-let (((ENEMY E-NAME E-SKILLP E-HITP) (list-ref enemy (- e-count 1))))
      (let ((p-attack (+ (car SKILLP) (dice))) (e-attack (+ E-SKILLP (dice))))
        (cond ((>= p-attack e-attack) (values 'battle-kawasi NAME E-NAME 0 0))
              (else (values 'battle-ressei NAME E-NAME -2 0)))))))

(define (ippouteki player enemy e-count)
  (match-let (((PLAYER NAME SKILLP HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) (car player)))
    (match-let (((ENEMY E-NAME E-SKILLP E-HITP) (list-ref enemy (- e-count 1))))
      (let ((p-attack (+ (car SKILLP) (dice))) (e-attack (+ E-SKILLP (dice))))
        (cond ((<= p-attack e-attack) (values 'battle-kawasare 0 0))
              (else (values 'battle-yusei NAME E-NAME 0 -2)))))))


(battle-zero `(,SJ) `(,mouse1 ,mouse2 ,mouse3 ,mouse4) 1 '(1 1 1) 1 1 '())



(define (battle-map player enemy command-list enemy-attack-list p-count damage-lists);player enemyはそれぞれリストのまま
  (if (null? command-list) (reverse damage-lists)
      (battle-map (cdr command-list) enemy-attack-list (+ 1 p-count)
                  (cons (battle-zero player enemy (car command-list) enemy-attack-list p-count 1 '()) damage-lists))))

#|
(battle-map '(1 2 3 4) '(2 2 3 4) 1 '())


(define test-i '(1 2 3))
(define test-j '(2 2 2))

(for/list ((k (iota (length test-i) 1 1)))
(for/list ((i test-i)
           (j test-j))
     ;      (k (iota (length test-i) 1 1)))
  (cond ((and (= i k) (= j i)) (list i j k "taiman"))
        ((and (not (= i k)) (= j k))  (list i j k "bousen"))
        ((and (= i k) (not (= j k))) (list i j k "ippouteki"))
        (else (list i j k "sonota")))))
|#
