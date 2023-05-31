#lang racket

(provide (all-defined-out))
(require "4king-print.rkt")


;;;;;;;;;;;;;;;;;;;4人のジャックテーブル
(define jack-table (make-hash))

;構造体
(struct CARD (NAME KIND FIRST SECOND MES ENEMY ITEM GOLD ON FLIP) #:transparent)
(struct ENEMY (NAME SKILLP HITP) #:transparent)
(struct ITEM (NAME COST KIND POWER) #:transparent)
(struct PLAYER (NAME SKILLP HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) #:transparent)
(struct WORLD (PLAYERS SMAP PMAP PHASE COORD WIN) #:transparent)

;PLAYERインスタンス
(define SJ (PLAYER "勇者スペードのジャック" '(11 . 11) '(22 . 22) '(9 . 9) 'sword 20 '() #f 'win-sj))
(define DJ (PLAYER "恋人ダイヤのジャック" '(10 . 10) '(20 . 20) '(10 . 10) 'sword 20 '() 'skill-miracle 'win-dj))
(define HJ (PLAYER "弟子ハートのジャック" '(9 . 9) '(18 . 18) '(11 . 11) 'sword 20 '() 'skill-ilusion 'win-hj))
(define CJ (PLAYER "悪魔クラブのジャック" '(10 . 10) '(20 . 20) '(9 . 9) 'sword 20 '() 'skill-recover 'win-cj))


;ITEMインスタンス　アイテムはリストにしなくても良い？
(define sord (ITEM "剣" #f 'one-hand-weapon '(0 0)))






;(define play1 (list skill-herb power-herb power-herb))
;(define play2 (list skill-herb power-herb))

(define rune-blade (ITEM "ルーンブレード" #f 'one-hand-weapon '(2 0)))                     
(define zakura (ENEMY "戦士ザクラ" 12 12))
(define SA (CARD "SA" 'SELECT ;初期Eval用キー　ここではselectクロージャを呼び出す
                 '(LUCK-TRY (numbing-medicine wine) (enemy SKILLP -3) (player HITP -2 24))
                 ;↑#tで続く（）で必要アイテム、次の（）で成功効果　最後の（）で失敗効果最後の真偽はJOK(24)行きかどうか
                 '(LUCKP -2) ;存在した場合は降服可能、BATTLEで参照してメニューを出す
                 'mes-s1 (list zakura) (list rune-blade) #f #t #t))



(define S2 (CARD "S2" 'S 2 'SHOP 'mes-s2 '() '(silver-short-sord war-hammer long-sord throwing-knife) #f #t #f))
(define silver-short-sord (ITEM "銀の短剣" 10 'sacred-weapon '(0 0)))
(define war-hammer (ITEM "ウォーハンマー" 35 'physical-slayer '(0 0)))
(define long-sword (ITEM "ロングソード" 30 'two-handed-weapon '(1 0)))
(define throwing-knife (ITEM "投げナイフ" 10 'preemptive-strike '(0 2)))

(define S3 (CARD "S3" 'S 3 'SHOP 'mes-s3 '() '(magic-gloves shield chain-mail) #f #t #f))
(define magic-gloves (ITEM "魔法の手袋" 15 'glove 1))
(define shield (ITEM "盾" 10 'shield 0))
(define chain-mail (ITEM "鎖かたびら" 40 'armor 1))

(define S4 (CARD "S4" 'S 4 'SHOP 'mes-s4 '() '(horse) #f #t #f))
(define horse (ITEM "馬" 40 'speed-up 3))

(define S5 (CARD "S5" 'S 5 'SHOP 'mes-s5 '() '(numbing-medicine anesthetic medicinal-herb skill-herb power-herb luck-herb) #f #t #f))
(define numbing-medicine(ITEM "しびれ薬" 5 'numbing 0))
(define anesthetic (ITEM "眠り薬" 5 'anesthetic 0))
(define medicinal-herb (ITEM "薬草" 3 'heal 4))
(define skill-herb (ITEM "技の薬" 15 'skill-full 0))
(define power-herb (ITEM "力の薬" 15 'power-full 0))
(define luck-herb (ITEM "ツキの薬" 15 'luck-full 0))

(define S6 (CARD "S6" 'S 6 'SHOP 'mes-s6 #f '(acrobat performance handmagic instrument) #f #t #f))
(define S7 (CARD "S7" 'S 7 'SHOP 'mes-s7 '() '(lantern shovel rope lock-pick lute)  #f #t #f))
(define S8 (CARD "S8" 'S 8 'SHOP 'mes-s8 '() '(womans-clothing magic-clothing black-clothing)  #f #t #f))
(define S9 (CARD "S9" 'S 9 'SHOP 'mes-s9 '() '(cake)  #f #t #f))
(define S10 (CARD "S10" 'S 10 'SHOP 'mes-s10 '() '(fake-jewely)  #f #t #f))
(define SQ (CARD "SQ" 'S 'Q 'cond-force 'mes-sq '() '(enemy-iris)   #f #t #t))
(define iris (ENEMY "女戦士アイリス" 11 10)) ;ENEMYからITEMを削る、CARDに持たせる
(define power-hammer (ITEM "パワーハンマー" #f 'one-hand-weapon '(0 1))) ;0は命中判定 1はダメージ
(define SK (CARD "SK" 'S 'K 'ROYAL-PALACE 'mes-sk '() '() #f #t #f))
(define DA (CARD "DA" 'D 'A 'RAIGO 'mes-da '() '(devil-eyes) #f #t #f))
(define D2 (CARD "D2" 'money-select 2 'BATTLE 'mes-d2 '(orc1 orc2) '() 6 #t #t)) ;goldはCARDのITEMに
(define orc1 (ENEMY "オークA" 6 5))
(define orc2 (ENEMY "オークB" 6 6))
(define D3 (CARD "D3" 'D 3 'WORK 'mes-d3 '() '() 9 #t #f))
(define D4 (CARD "D4" 'cond-force 4 'GUARD 'mes-d4 '(guard1 guard2 guard3) '() 12 #t #t))
(define guard1 (ENEMY "警備兵A" 10 11))
(define guard2 (ENEMY "警備兵B" 9 10))
(define guard3 (ENEMY "警備兵C" 10 10))
(define D5 (CARD "D5" 'D 5 'THEATER 'mes-d5 '() '() 15 #t #t))
(define D6 (CARD "D6" 'D 6 'PICKPOCKET'mes-d6 '(pickpoketer) '() 18 #t #t))
(define pickpocketer (ENEMY "スリ" 7 7))
(define D7 (CARD "D7" 'select 7 'BATTLE 'mes-d7 '(mouse1 mouse2 mouse3 mouse4) '() 21 #t #t)) ;悪臭ステータス追加
(define mouse1 (ENEMY "大ねずみA" 6 5))
(define mouse2 (ENEMY "大ねずみB" 5 4))
(define mouse3 (ENEMY "大ねずみC" 5 4))
(define mouse4 (ENEMY "大ねずみD" 5 4))
(define D8 (CARD "D8" 'D 8 'PICKPOCKET 'mes-d7 '() '() 24 #t #t))
(define D9 (CARD "D9" 'D 9 'BATTLE 'mes-d8 '(monster-fish) '() 27 #t #t))
(define D10 (CARD "D10" 'D 10 'BATTLE 'mes-d9 '(oltergeist) '() 30 #t #t))
(define DQ (CARD "DQ" 'D 'Q 'BATTLE 'mes-dq '(assassin) '(poison-dagger) 0 #t #t))
(define poison-dagger (ITEM "毒の短剣" #f 'poison-weapon '(0 0)))
(define DK (CARD "DK" 'D 'K 'ARENA 'mes-dk '(porcupine wolf panther dragger cyclops hole-devil) '() 0 #t #t))
(define porcupine (ENEMY "棘棘獣" 5 7))
(define wolf (ENEMY "狼" 7 6))
(define panther (ENEMY "黒豹" 8 7))
(define dragger (ENEMY "ドラガー" 9 10))
(define cyclops (ENEMY "サイクロプス" 10 10))
(define hole-devil (ENEMY "穴悪魔" 12 15))



(define test-map (list SA S2 S3 S4))
(define test-list (flatten (map (lambda (x) (list (CARD-NAME x))) test-map)))



