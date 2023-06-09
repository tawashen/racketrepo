#lang racket

;(require srfi/1)
(require racket/struct)
(require racket/match)
(require "4king-data.rkt")
(require "4king-util.rkt")


(define SA (CARD "♠A" 'SELECT ;初期Eval用キー ここではselectクロージャを呼び出す ;CARD-KIND
                 '(LUCK-TRY (numbing-medicine wine) (enemy SKILLP -3) (player HITP -2 24));CARD-FIRST
                 ;↑#tで続く()で必要アイテム、次の()で成功効果 最後の()で失敗効果最後の真偽はJOK(24)行きかどうか
                 '(LUCKP -2) ;存在した場合は降服可能、BATTLEで参照してメニューを出す CARD-SECIND
                 'mes-s1 (list zakura) (list rune-blade) #f #t #t))


(define (battle-read wolrd)
                 (match-let (((WORLD PLAYERS MAPLIST SMAP PMAP PHASE COORD WIN) world))
         (match-let (((CARD NAME KIND FIRST SECOND MES ENEMY ITEM GOLD ON FLIP) ;現在のカード
                                                              (list-ref test-zihuda-list (- (list-ref COORD (list-ref PHASE 0)) 1))))
                   (let* ((
                         (c-enemy (if WIN;運試しに勝ったか?
                                      (case (list-ref (list-ref FIRST 2) 1);勝った場合 ここは大幅に書き換えないと駄目
                                        ((SKILLP) (ENEMY ENAME (+ ESKILLP (list-ref (list-ref FIRST 2) 2)))))
                                      ENEMY)));負けてたらそのまま
                     (display (format "~aとの戦闘だ!" (if (< 1 (length ENEMY)) "まもののむれ" (ENEMY-NAME (car ENEMY))))) (newline)
                     (battle-read2 world ENEMY)
                     )))