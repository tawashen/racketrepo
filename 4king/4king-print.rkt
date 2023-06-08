#lang racket

(require 2htdp/universe 2htdp/image lang/posn)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(provide (all-defined-out))
;(require "4king-data.rkt")


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



;(define *card-list* (map string->symbol (for*/list ((s suit) (n num)) (string-append s n))))
#;
(define *zihuda-list* `(,SA ,S2 ,S3 ,S4 ,S5 ,S6 ,S7 ,S8 ,S9 ,S10
                            ,DA ,D2 ,D3 ,D4 ,D5 ,D6 ,D7 ,D8 ,D9 ,D10
                            ,HA ,H2 ,H3 ,H4 ,H5 ,H6 ,H7 ,H8 ,H9 ,H10
                            ,CA ,C2 ,C3 ,C4 ,C5 ,C6 ,C7 ,C8 ,C9 ,C10))
#;(define *q&k-list* `(,SQ ,SK ,DQ ,DK ,HQ ,HK ,CQ ,CK))



;(define num-list '(#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9))
;(define q-to-k-list '(#\Q #\K))
;(define zihuda (filter (lambda (x) (member (string-ref (symbol->string x) 1) num-list)) *card-list*))
;(define q-to-k (filter (lambda (x) (member (string-ref (symbol->string x) 1) q-to-k-list)) *card-list*))


;元マップに対して字札・絵札・JOKを配置する
(define (narabi zihuda q-to-k map-zero new-list)
  (if (null? map-zero)
     (reverse new-list)
      (cond ((= (car map-zero) 0)  (narabi (cdr zihuda) q-to-k (cdr map-zero) (cons (car zihuda) new-list)))
            ((= (car map-zero) 1) (narabi zihuda (cdr q-to-k) (cdr map-zero) (list (car q-to-k) new-list)))
            (else (narabi zihuda q-to-k (cdr map-zero) (list 'JOK new-list))))))

;字札・絵札・JOKを配置したマップ
;(define *map* (narabi zihuda q-to-k *map-zero* '()))

;リストを7つの要素ごとに分割する
(define (split-list lst)
  (if (null? lst)
      '()
      (cons (take lst 7) (split-list (drop lst 7)))))

;表示桁数揃える関数　全角版
(define (align-string string)
      (cond
         ((string=? "0" string) "＿＿＿＿＿")
                     ((= 2 (string-length string)) (string-append string "＿＿＿" ))
                     ((= 3 (string-length string)) (string-append string "＿＿" ))
                     ((= 1 (string-length string)) (string-append string "＿＿＿＿" ))))
                    

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



;プレイヤー配置関数 多人数プレイ対応
(define (put-player map num players)
  (if (null? players)
      map
      (put-player (list-set map (car players) num) (+ 1 num) (cdr players))))





;カードマップとPlayersマップと行ごとに交互に合体させて7要素ごとに整形
(define (display-map map players combine)
  (if (null? map)
      (display-lines (split-list (flatten (reverse combine))))
      (display-map (cdr map) (cdr players) (cons (list (car map) (car players)) combine))))


