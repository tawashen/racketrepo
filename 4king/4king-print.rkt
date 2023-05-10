#lang racket

(require 2htdp/universe 2htdp/image lang/posn)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(provide (all-defined-out))


(define suit '("S" "D" "H" "C"))
(define num '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "J" "Q" "K"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PRINT関連
(define *map-zero* (apply append '(
                     (0 0 0 0 0 0 0)
                     (0 0 0 0 0 0 0)
                     (0 0 1 1 1 0 0)
                     (0 0 1 2 1 0 0)
                     (0 0 1 1 1 0 0)
                     (0 0 0 0 0 0 0)
                     (0 0 0 0 0 0 0)
                     )))



(define card-list (map string->symbol (for*/list ((s suit) (n num)) (string-append s n))))


(define num-list '(#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))
(define q-to-k-list '(#\Q #\K))
(define zihuda (shuffle (filter (lambda (x) (member (string-ref (symbol->string x) 1) num-list)) card-list)))
(define q-to-k (shuffle (filter (lambda (x) (member (string-ref (symbol->string x) 1) q-to-k-list)) card-list)))


;元マップに対して字札・絵札・JOKを配置する
(define (narabi a b c d)
  (if (null? c)
     (reverse d)
      (cond ((= (car c) 0)  (narabi (cdr a) b (cdr c) (cons (car a) d)))
            ((= (car c) 1) (narabi a (cdr b) (cdr c) (cons (car b) d)))
            (else (narabi a b (cdr c) (cons 'JOK d))))))

;字札・絵札・JOKを配置したマップ
(define *map* (narabi zihuda q-to-k *map-zero* '()))

;リストを7つの要素ごとに分割する
(define (split-list lst)
  (if (null? lst)
      '()
      (cons (take lst 7) (split-list (drop lst 7)))))

;表示桁数揃える関数
(define (align-string string)
      (cond
         ((string= "0" string) "_____")
                     ((= 2 (string-length string)) (string-append string "___" ))
                     ((= 3 (string-length string)) (string-append string "__" ))
                     ((= 1 (string-length string)) (string-append string "____" ))))
                    

;プレイヤー配置マップ空状態
(define *player-zero* (apply append '(
                     (0 0 0 0 0 0 0)
                     (0 0 0 0 0 0 0)
                     (0 0 0 0 0 0 0)
                     (0 0 0 0 0 0 0)
                     (0 0 0 0 0 0 0)
                     (0 0 0 0 0 0 0)
                     (0 0 0 0 0 0 0)
                     )))

;仮のプレイヤー座標データ
(define players '(12 5 19 29)) 

;プレイヤー配置関数 多人数プレイ対応
(define (put-player map num players)
  (if (null? players)
      map
      (put-player (list-set map (car players) num) (+ 1 num) (cdr players))))

;整形後のPlayers配置マップを束縛
(define players-map (split-list (map align-string (map (lambda (x) (number->string x)) (put-player *player-zero* 1 players))))) 

;整形後のカードマップ
(define string-map (split-list (map align-string (map (lambda (x)  (symbol->string x)) *map*))))

;カードマップとPlayersマップと行ごとに交互に合体させて7要素ごとに整形
(define (display-map map players combine)
  (if (null? map)
      (display-lines (split-list (flatten (reverse combine))))
      (display-map (cdr map) (cdr players) (cons (list (car map) (car players)) combine))))


