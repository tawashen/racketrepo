#lang racket

(provide (all-defined-out))

(struct CARD (SUIT NUM KIND MES ENEMY ITEM ON FLIP) #:transparent)
(struct ENEMY (NAME AT HP ITEM GOLD))
(struct ITEM (NAME COST KIND POWER))
(struct PLAYER (NAME SKILLP HITP MAGICP EQUIP GOLD ITEMS SPECIAL WIN))
(struct WORLD (PLAYERS SMAP PMAP PHASE COORD WIN))


(define SJ (PLAYER "勇者スペードのジャック" '(11 . 11) '(22 . 22) '(9 . 9) 'sword 20 '() #f 'win-sj))
(define DJ (PLAYER "恋人ダイヤのジャック" '(10 . 10) '(20 . 20) '(10 . 10) 'sword 20 '() 'skill-miracle 'win-dj))
(define HJ (PLAYER "弟子ハートのジャック" '(9 . 9) '(18 . 18) '(11 . 11) 'sword 20 '() 'skill-ilusion 'win-hj))
(define CJ (PLAYER "悪魔クラブのジャック" '(10 . 10) '(20 . 20) '(9 . 9) 'sword 20 '() 'skill-recover 'win-cj))



;;;;kokokara harituke 敵構造体にゴールドを追加する
(define sord (ITEM "剣" #f 'one-hand-weapon '(0 0)))
(define rune-blade (ITEM "ルーンブレード" #f 'one-hand-weapon '(2 0)))
(define silver-short-sord (ITEM "銀の短剣" 10 'sacred-weapon '(0 0)))
(define war-hammer (ITEM "ウォーハンマー" 35 'physical-slayer '(0 0)))
(define long-sword (ITEM "ロングソード" 30 'two-handed-weapon '(1 0))
(define throwing-knife (ITEM "投げナイフ" 10 'preemptive-strike '(0 2)))
(define magic-gloves (ITEM "魔法の手袋" 15 'glove 1))
(define shield (ITEM "盾" 10 'shield 0))
(define chain-mail (ITEM "鎖かたびら" 40 'armor 1))
(define horse (ITEM "馬" 40 'speed-up 3))
(define numbing-medicine(ITEM "しびれ薬" 5 'numbing 0))
(define anesthetic (ITEM "眠り薬" 5 'anesthetic 0))
(define medicinal-herb (ITEM "薬草" 3 'heal 4))
(define skill-herb (ITEM "技の薬" 15 'skill 0))
(define power-herb (ITEM "力の薬" 15 'power 0))
(define luck-herb (ITEM "ツキの薬" 15 'luck 0))

(define zakura (ENEMY "戦士ザクラ" 12 12 'item-rune-blade 0))
(define SA (CARD 'S 'A 'BATTLABLE-ZAKURA 'mes-sa '(enemy-zakura) '() #t #t))
(define S2 (CARD 'S 2 'SHOP 'mes-s1 '() '(silver-short-sord war-hammer long-sord throwing-knife) #t #f))
(define S3 (CARD 'S 3 'SHOP 'mes-s2 '() '(magic-gloves shield chain-mail) #t #f))
(define S4 (CARD 'S 4 'SHOP 'mes-s3 '() '(horse) #t #f))
(define S5 (CARD 'S 5 'SHOP 'mes-s4 '() '(numbing-medicine anesthetic medicinal-herb skill-herb power-herb luck-herb) #t #f))
(define S6 (CARD 'S 6 'SKILL-SHOP 'mes-s6 #f '(

(define S7 (CARD 'S 7 'SHOP 'mes-s7 '() '(lantern shovel rope lock-pick lute) #t #f))
(define S8 (CARD 'S 8 'SHOP 'mes-s8 '() '(womans-clothing magic-clothing black-clothing) #t #f))
(define S9 (CARD 'S 9 'SHOP 'mes-s9 '() '(cake) #t #f))
(define S10 (CARD 'S 10 'SHOP 'mes-s10 '() '(fake-jewely) #t #f))
(define SQ (CARD 'S 'Q 'BATTLE-IRIS 'mes-sq '(enemy-iris) '() #t #t))
(define iris (ENEMY "女戦士アイリス" 11 10 'item-power-hammer #t #t)) ;ENEMYからITEMを削る、CARDに持たせる
(define power-hammer (ITEM "パワーハンマー" #f 'one-hand-weapon '(0 1))) ;0は命中判定 1はダメージ
(define SK (CARD 'S 'K 'ROYAL-PALACE 'mes-sk '() '() #t #f))
(define DA (CARD 'D 'A 'RAIGO 'mes-da '() '(devil-eyes) #t #f))
(define D2 (CARD 'D 2 'BATTLABLE-ORC 'mes-d2 '(orc1 orc2) '((gold . 6)) #t #t)) ;goldはCARDのITEMに
(define orc1 (ENEMY "オークA" 6 5))
(define orc2 (ENEMY "オークB" 6 6))
(define D3 (CARD 'D 3 'WORK 'mes-d3 '() '(gold . 9) #t #f))
(define D4 (CARD 'D 4 'GUARD 'mes-d4 '(guard1 guard2 guard3) '((gold . 12)) #t #t))
(define guard1 (ENEMY "警備兵A" 10 11))
(define guard2 (ENEMY "警備兵B" 9 10))
(define guard3 (ENEMY "警備兵C" 10 10))
(define D5 (CARD 'D 5 'THEATER 'mes-d5 '() '((gold . 15)) #t #t))
(define D6 (CARD 'D 6 'PICKPOCKETED 'mes-d6 '(pickpoketer) '((gold . 18)) #t #t))
(define pickpocketer (ENEMY "スリ" 7 7))
(define D7 (CARD 'D 7 'SEWER 'mes-d7 '(mouse1 mouse2 mouse3 mouse4) '((gold . 21)) #t #t)) ;悪臭ステータス追加
(define D8 (CARD 'D 8 'PICKPOCKET 'mes-d7 '() '((gold . 24)) #t #t))
(define D9 (CARD 'D 9 'BATTLABLE-FISH 'mes-d8 '(monster-fish) '((gold . 27)) #t #t))
(define D10 (CARD 'D 10 'BATTLE-GHOST 'mes-d9 '(oltergeist) '((gold . 30)) #t #t))
(define DQ (CARD 'D 'Q 'BATTLE-ASSASSIN 'mes-dq '(assassin) '(poison-dagger) #t #t))
(define poison-dagger (ITEM "毒の短剣" #f 'poison-weapon '(0 0)))
(define DK (CARD 'D 'K 'ARENA 'mes-dk '(porcupine wolf panther dragger cyclops hole-devil)))
(define porcupine (ENEMY "棘棘獣" 5 7))
(define wolf (ENEMY "狼" 7 6))
(define panther (ENEMY "黒豹" 8 7))
(define dragger (ENEMY "ドラガー" 9 10))
(define cyclops (ENEMY "サイクロプス" 10 10))
(define hole-devil (ENEMY "穴悪魔" 12 15))
