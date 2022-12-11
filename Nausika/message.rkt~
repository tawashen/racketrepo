#lang racket


(provide (all-defined-out))



;分離式戦闘用メッセージ
(define *shop-messages* '((kaukane . "何を買うかね?")
                           (arigatou . "毎度ありがとう~%")
                           (getitem . "ナウシカは~aを手に入れた~%")))


;分離式戦闘用メッセージ
(define *battle-messages* '((appear . "敵~aが現れた!~%")
                           (atack . "ナウシカの攻撃!~%")
                           (damagep . "ナウシカは~aのダメージを与えた!~%")
                           (atacked . "~aの攻撃!~%")
                           (damagedp . "ナウシカは~aのダメージを受けた!~%")
                           (tie . "互角!~%")
                           (status . "攻撃力~a 体力(~a)~%")
                           (turn . "第~aターン~%")
                           (select . "どうする? [1:剣で戦う] [2:光弾を使う]")
                           (selectM . "どうする? [1:剣で戦う]")
                           (koudan . "ナウシカは光弾を投げつけた!~%")
                           (tamanasi . "しまった!光弾はもう無かったんだった!~%")
                           (win . "ナウシカは~aを打ち倒した!!~%")))

(define *item-messages* '((select . "どのアイテムを使う？~%")
                          (use . "ナウシカは~aを使った~%")
                          (heal . "ナウシカは基本点を~a回復した~%")
                          ))

(define *main-messages* '((select . "~%基本点[~a/~a点]　行動点[~a点] きみはどうする？~%")
                          (saikoro . "コロコロ・・・~a!~%")
                          (drop . "君は~aを~a個失った！~%")
                          (input . "正しい数字を答えるのだ！~%")
                          (miss . "君は間違った数字を答えてしまった！~%")
                          (escape . "君は逃げるか？　1:はい　2:いいえ~%")
                          (get . "君は~aを~a個手に入れた！~%")
                          (get? . "君は~aを手に入れるか？　1：はい　2：いいえ~%")
                          (ture . "君は~aを連れて行く事に決めた~%")
                          (drop? . "君は何を捨てるのか？~%")
                          (drop-it? . "君は~aと別れるか？ 1:はい　2：いいえ~%")
                          (droped . "君は~aを失った！~%")
                          (use? . "君は~aを使うか？ 1:はい　2:いいえ~%")
                          ))
                          
(define *max-hp* 15)