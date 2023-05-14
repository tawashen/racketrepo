#lang racket


(require 2htdp/universe 2htdp/image lang/posn)
;(require srfi/1)
;(require srfi/13)
(require racket/struct)
(require racket/match)
(require "4king-print.rkt")
(require "4king-util.rkt")



(struct CARD (SUIT NUM KIND MES ENEMY ITEM ON FLIP) #:transparent)
(struct ENEMY (NAME AT HP ITEM GOLD))
(struct ITEM (NAME COST KIND POWER))
(struct PLAYER (NAME SKILLP HITP MAGICP EQUIP GOLD ITEMS SPECIAL WIN))
(struct WORLD (PLAYERS SMAP PMAP PHASE COORD WIN))

(define players '(12 15 29 34))　
;整形後のPlayers配置マップを束縛（初期値）
(define players-map (split-list (map align-string (map (lambda (x) (number->string x)) (put-player *player-zero* 1 players))))) 


;テスト用インスタンス類
(define world (WORLD (list SJ DJ HJ CJ) string-map players-map (circular-list 0 1 2 3) '(12 15 29 34) #f))

(define SJ (PLAYER "勇者スペードのジャック" '(11 . 11) '(22 . 22) '(9 . 9) 'sword 20 #f 'win-sj))
(define DJ (PLAYER "恋人ダイヤのジャック" '(10 . 10) '(20 . 20) '(10 . 10) 'sword 20 '() 'skill-miracle 'win-dj))
(define HJ (PLAYER "弟子ハートのジャック" '(9 . 9) '(18 . 18) '(11 . 11) 'sword 20 '() 'skill-ilusion 'win-hj))
(define CJ (PLAYER "悪魔クラブのジャック" '(10 . 10) '(20 . 20) '(9 . 9) 'sword 20 '() 'skill-recover 'win-cj))

(define sord (ITEM "剣" #f 'one-hand-sword 0))
(define rune-blade (ITEM "ルーンブレード" #f 'one-hand-sword 2))
(define silver-short-sord (ITEM "銀の短剣" 10 'sacred-weapon 0))
(define war-hammer (ITEM "ウォーハンマー" 35 'physical-slayer 0))
(define long-sword (ITEM "ロングソード" 30 'two-handed-sword 1))
(define throwing-knife (ITEM "投げナイフ" 'preemptive-strike 2))
(define magic-gloves (ITEM "魔法の手袋" 'glove 1))
(define shield (ITEM "盾" 'shield 0))
(define chain-mail (ITEM "鎖かたびら" 40 'armor 1))
(define horse (ITEM "馬" 40 'speed-up 0))
(define numbing-medicine(ITEM "しびれ薬" 5 'numbing 0))
(define anesthetic (ITEM "眠り薬" 5 'anesthetic 0))
(define medicinal-herb (ITEM "薬草" 3 'heal 4))
(define skill-herb (ITEM "技の薬" 15 'skill 0))
(define power-herb (ITEM "力の薬" 15 'power 0))
(define luck-herb (ITME "ツキの薬" 15 'luck 0))

(define zakura (ENEMY "戦士ザクラ" 12 12 'item-rune-blade 0))
(define SA (CARD 'S 'A 'BATTLE 'mes-sa 'enemy-zakura "" #t #t))
(define S2 (CARD 'S 2 'SHOP 'mes-s1 #f '(silver-short-sord war-hammer long-sord throwing-knife) #t #f))
(define S3 (CARD 'S 3 'SHOP 'mes-s2 #f '(magic-gloves shield chain-mail) #t #f))
(define S4 (CARD 'S 4 'SHOP 'mes-s3 #f '(horse) #t #f))
(define S5 (CARD 'S 5 'SHOP 'mes-s4 #f '(numbing-medicine anesthetic medicinal-herb skill-herb power-herb luck-herb) #t #f))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;関数
(define (change-coord direct w num)
  (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) w))
    (let* ((new-coord (list-set COORD PHASE (+ (list-ref COORD PHASE) num)))
           (new-pmap (make-players-map new-coord)))
      (WORLD PLAYERS SMAP new-pmap PHASE new-coord WIN))))
  
  
(define (go-direct direct w) ;新たなwを返す予定 COORDとplayer-mapを更新する
  (let ((current ;PLAYER構造体から座標(INT)を束縛
                  (list-ref (WORLD-COORD w) (car (WORLD-PHASE w))))) ;現在のPLYAER構造体を返す
    (cond ((and (string=? direct "r") (ue? current)) (main-read (change-coord direct w -7)))
          ((and (string=? direct "d") (hidari? current)) (main-read (change-coord direct w -1)))
          ((and (string=? direct "c") (sita? current)) (main-read (change-coord direct w 7)))
          ((and (string=? direct "f") (migi? current)) (main-read (change-coord direct w 1)))
          (else (main-read w)))))

;整形後のPlayers配置マップを作る関数、これで移動後にworldを作り直す
(define (make-players-map new-coord)
  (split-list (map align-string (map (lambda (x) (number->string x)) (put-player *player-zero* 1 new-coord)))))
   



                                                 

;;;;;;;;;;;;;;;;;;;4人のジャックテーブル
(define jack-table (make-hash))
;;;;;;;;;;;;;;;;;;カードテーブル
;(hash-set! jack-table 'card-sa SA)

;;;;;;;;;;;;;;;;;メッセージテーブル
(hash-set! jack-table 'mes-read "~aのターン　どこへ移動する？北[r] 西[d] 南[c] 東[f]")
(hash-set! jack-table 'mes-sa "うんたらかんたら")

;;;;;;;;;;;;;;;;;アイテムテーブル
(hash-set! jack-table 'item-sord sord)

;;;;;;;;;;;;;;;;;アイテム属性テーブル 装備コマンドの時参照する感じ？


;;;;;;;;;;;;;;;;;エネミーテーブル
(hash-set! jack-table 'enemy-zakura zakura)

;;;;;;;;;;;;;;;;;イベントテーブル
(hash-set! jack-table 'direct go-direct)













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;バトル部分
;(define (battle-print w))
;(define (battle-read w))
;(define (battle-eval w))
;(define (battl-loop w))
;(define battle (lambda (x y) ()))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;メイン部分
;メインPRINT マップ表示                             
;(define (main-map-print w)

  ;(display (hash-ref jack-table (CARD-MES (PLAYER-COORD (WORLD-PLAYERS w))))))
;メインREAD マップの移動入力
(define (main-read w)
  (display-map (WORLD-SMAP w) (WORLD-PMAP w) '())
  (display (format (hash-ref jack-table 'mes-read) (list-ref (WORLD-PLAYERS w) (car (WORLD-PHASE w)))))
  (let ((direct (read-line)))
    (cond ((member direct  '("r" "d" "c" "f")) ((hash-ref jack-table 'direct) direct w))
          (else (main-read w)))))
  
;メインEVAL　移動後イベント発生
(define (main-eval w)
    (display-map (WORLD-SMAP w) (WORLD-PMAP w) '())
  (if (CARD-ON (list-ref *card-list* (list-ref (WORLD-COORD w) (car (WORLD-PHASE w)))))
      
  
;メインLOOP　次のプレイヤーか自身の次ターン
;(define (main-loop w))


;(main-print world)
;(main-read world)









