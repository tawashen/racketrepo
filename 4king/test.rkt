#lang racket

;(require srfi/1)
(require racket/struct)
(require racket/match)
(require "4king-data.rkt")
(require "4king-util.rkt")




;(battle-zero 2 '(1 1 2) '(1 1 2) 1 '() 1)



;;;;;ここからEvalまで本体にコピー済み

(define (taiman car-player enemy e-count)
  (match-let (((PLAYER NAME SKILLP HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) car-player))
    (match-let (((ENEMY E-NAME E-SKILLP E-HITP) (list-ref enemy (- e-count 1))))
      (let ((p-attack (+ (car SKILLP) (dice))) (e-attack (+ E-SKILLP (dice))))
        (cond ((= p-attack e-attack) (values 'battle-gokaku NAME E-NAME 0 0))
              ((> p-attack e-attack) (values 'battle-yusei NAME E-NAME 0 -2))
              (else (values 'battle-ressei NAME E-NAME -2 0)))))))

(define (bousen car-player enemy e-count)
  (match-let (((PLAYER NAME SKILLP HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) car-player))
    (match-let (((ENEMY E-NAME E-SKILLP E-HITP) (list-ref enemy (- e-count 1))))
      (let ((p-attack (+ (car SKILLP) (dice))) (e-attack (+ E-SKILLP (dice))))
        (cond ((>= p-attack e-attack) (values 'battle-kawasi NAME E-NAME 0 0))
              (else (values 'battle-ressei NAME E-NAME -2 0)))))))

(define (ippouteki car-player enemy e-count)
  (match-let (((PLAYER NAME SKILLP HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) car-player))
    (match-let (((ENEMY E-NAME E-SKILLP E-HITP) (list-ref enemy (- e-count 1))))
      (let ((p-attack (+ (car SKILLP) (dice))) (e-attack (+ E-SKILLP (dice))))
        (cond ((<= p-attack e-attack) (values 'battle-kawasare NAME E-NAME 0 0))
              (else (values 'battle-yusei NAME E-NAME 0 -2)))))))

(define (battle-zero car-player enemy car-command-list enemy-attack-list p-count e-count damage-list)
  (cond ((null? enemy-attack-list) (reverse damage-list))
        ((and (= e-count car-command-list) (= p-count (car enemy-attack-list)));タイマン通常戦闘
          (battle-zero car-player enemy car-command-list (cdr enemy-attack-list) p-count (+ 1 e-count)
           (cons (let-values (((mes name e-name p-damage e-damage) (taiman car-player enemy e-count)))
                   `(,mes ,name ,e-name ,p-damage ,e-damage)) damage-list)))
         ((= p-count (car enemy-attack-list));敵だけがこちらを攻撃
         (battle-zero car-player enemy car-command-list (cdr enemy-attack-list) p-count (+ 1 e-count)
           (cons (let-values (((mes name e-name p-damage e-damage) (bousen car-player enemy e-count)))
                   `(,mes ,name ,e-name ,p-damage ,e-damage)) damage-list)))
         ((and (not (= p-count (car enemy-attack-list))) (= e-count car-command-list));こちらだけ攻撃
          (battle-zero car-player enemy car-command-list (cdr enemy-attack-list) p-count (+ 1 e-count)
           (cons (let-values (((mes name e-name p-damage e-damage) (ippouteki car-player enemy e-count)))
                   `(,mes ,name ,e-name ,p-damage ,e-damage)) damage-list)))
         (else  (battle-zero car-player enemy car-command-list (cdr enemy-attack-list)  p-count (+ 1 e-count);どちらも狙ってない
           (cons (let-values (((mes name e-name p-damage e-damage) (values 'battle-nasi "" "" 0 0)))
                   `(,mes ,name ,e-name ,p-damage ,e-damage)) damage-list)))))


(define (battle-map players enemies command-list enemy-attack-list p-count damage-lists);player enemyはそれぞれリストのまま
  (if (null? command-list) (reverse damage-lists)
      (battle-map (cdr players) enemies (cdr command-list) enemy-attack-list (+ 1 p-count)
                  (cons (battle-zero (car players) enemies (car command-list) enemy-attack-list p-count 1 '()) damage-lists))))

;(battle-zero SJ  `(,mouse1 ,mouse2 ,mouse3 ,mouse4) 1 '(1 2 4 4) 1 1 '())

(flat-list (battle-map `(,SJ ,DJ ,HJ) `(,mouse1 ,mouse2 ,mouse3 ,mouse4) '(1 2 3) '(1 2 4 4) 1  '()) '())




;ダメージを適用したPlayerインスタンスのリストを返す単体
(define (damage-apply-player-zero car-player car-battle-result-list)
  (let ((player-total (foldl (lambda (y x) (+ x y)) 0 (map (lambda (z) (list-ref z 3)) car-battle-result-list))))
    (match-let (((PLAYER NAME SKILLP HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) car-player))
        (PLAYER NAME SKILLP (cons (+ player-total (car HITP)) (cdr HITP)) LUCKP EQUIP GOLD ITEMS SPECIAL WIN))));PLAYERインスタンス
;↑のマップ版
(define (damage-apply-player-map player battle-result-list new-players)
  (if (null? player) (reverse new-players)
      (damage-apply-player-map (cdr player) (cdr battle-result-list)
                               (cons (damage-apply-player-zero (car player) (car battle-result-list)) new-players))))

;ダメージを利用したEnemyインスタンスのリストを返す単体版
(define (damage-apply-enemy-zero car-enemy car-battle-result-list)
  (let ((enemy-total (foldl (lambda (y x) (+ x y)) 0 (map (lambda (z) (list-ref z 4)) car-battle-result-list))));縦貫通
    (match-let (((ENEMY ENAME ESKILLP EHITP) car-enemy))
      (ENEMY ENAME ESKILLP (+ enemy-total EHITP)))));ENEMYインスタンス

;↑のマップ版
(define (damage-apply-enemy-map enemy battle-result-list-v new-enemies)
  (define battle-result-list-v2 (apply map list battle-result-list-v))
  (if (null? enemy) (reverse new-enemies)
       (damage-apply-enemy-map (cdr enemy) (cdr battle-result-list-v2)
                               (cons (damage-apply-enemy-zero (car enemy) (car battle-result-list-v2)) new-enemies))))
  

(define (battle-eval player enemy world command-list)
  (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) world))
    ; (match-let (((CARD C-NAME KIND FIRST SECOND MES ENEMY C-ITEM C-GOLD ON FLIP)
            ;      (list-ref *map* (list-ref COORD (list-ref PHASE 0)))))
       (match-let (((PLAYER P-NAME P-SKILLP P-HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) (car player)))
         (match-let (((ENEMY E-NAME E-SKILLP E-HITP) (car enemy)))
		(let* ((enemy-attack-list (random-list (length player))) ;ex (1 1 2)
                        (battle-result-list (battle-map player enemy world command-list enemy-attack-list 1 '())))                      
                    (let((new-players (damage-apply-player-map player battle-result-list '())) ;ダメージの結果を各インスタンスにMapする関数                                        
                         (new-enemies (damage-apply-enemy-map enemy battle-result-list '())))
                      (battle-print new-players new-enemies world battle-result-list)))))))
;;;;ここまでコピー済み

(define (battle-print new-player new-enemies world battle-result-list)
  (display "totyuu")) 


#;
(damage-apply-player-map `(,SJ ,DJ ,HJ)
                         (battle-map `(,SJ ,DJ ,HJ) `(,mouse1 ,mouse2 ,mouse3 ,mouse4) '(1 2 3) '(1 2 3 3) 1  '()) '())

#;
(damage-apply-enemy-map `(,mouse1 ,mouse2 ,mouse3 ,mouse4)
                        (battle-map `(,SJ ,DJ ,HJ) `(,mouse1 ,mouse2 ,mouse3 ,mouse4) '(1 2 3) '(1 2 4 4) 1  '()) '())




                


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
