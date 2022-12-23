#lang racket




(provide (all-defined-out))

;アイテム関係
;アイテム系データ
(struct item (name cost page times point att) #:transparent)

(define I001 (item "防瘴マスク" 10 26 1 #f "I"))
(define I002 (item "防瘴ケース" 15 26 1 #f "I"))
(define I003 (item "光弾" 4 26 1 #f "I"))
(define I004 (item "ロープ" 5 26 1 #f "I"))
(define I005 (item "干し肉" 10 26 3 2 "F"))
(define I006 (item "パン" 6 38 2 2 "F"))
(define I007 (item "チーズ" 9 38 2 3 "F"))
(define I008 (item "干し肉" 8 38 2 2 "F"))
(define I009 (item "干し果物" 8 38 3 2 "F"))
(define I010 (item "防瘴マスク" 10 43 1 #f "I"))
(define I011 (item "防瘴ケース" 12 43 1 #f "I"))
(define I012 (item "ロープ" 5 43 1 #f "I"))
(define I013 (item "光弾" 3 43 1 #f "I"))
(define I014 (item "蟲笛" 7 43 1 #f "I"))
(define I015 (item "短剣" 12 43 1 #f "A"))
(define I016 (item "カンテラ(油入り)" 10 49 1 #f "L"))
(define I017 (item "ろうそく" 2 49 1 #f "L"))
(define I018 (item "油" 4 49 1 #f "I"))
(define I019 (item "葡萄酒" 10 64 5 2 "F"))
(define I020 (item "蒸留酒" 12 64 3 3 "F"))
(define I021 (item "果実酒" 12 64 6 2 "F"))
(define I033 (item "皮袋" 6 64 1 #f "I"))
(define I022 (item "傷薬" 4 68 2 1 "H"))
(define I023 (item "毒消し" 5 68 1 #f "I"))
(define I024 (item "眠り薬" 10 68 1 #f "I"))
(define I025 (item "革ヒモ" 1 90 1 #f "I"))
(define I026 (item "厚手のマント" 8 90 1 #f "I"))
(define I027 (item "水袋(水筒)" 5 90 1 #f "I"))
(define I028 (item "剣" 20 105 1 #f "A"))
(define I029 (item "短剣(セラミック製)" 10 105 1 #f "A"))
(define I030 (item "額あて" 12 105 1 #f "A"))
(define I031 (item "光弾" 3 105 1 #f "I"))
(define I032 (item "ランプ(永久)" 20 105 1 #f "L"))
(define I034 (item "チコの実" 0 0 0 1 "F"))
(define I035 (item "食料" 0 0 0 2 "F"))
(define I036 (item "高級傷薬" 0 0 1 5 "H"))


(define item-list `(
                    ,I001 ,I002 ,I003 ,I004 ,I005 ,I006 ,I007 ,I008 ,I009 ,I010
                    ,I011 ,I012 ,I013 ,I014 ,I015 ,I016 ,I017 ,I018 ,I019 ,I020
                    ,I021 ,I022 ,I023 ,I024 ,I025 ,I026 ,I027 ,I028 ,I029 ,I030
                    ,I031 ,I032 ,I034 ,I035 ,I036))


;装備品リスト
(define *equip* '(
               ("銀貨" . 140)
               ("蟲笛" . 1)
               ("光弾" . 5)
               ("チコの実" . 15)
               ("守り石" . 1)
               ("カイ" . 1)
               ("防瘴マスク" . 0)
               ("防瘴ケース" . 0)
               ("ロープ" . 0)
               ("干し肉" . 0)
               ("パン" . 0)
               ("チーズ" . 0)
               ("干し果物" . 0)
               ("カンテラ" . 0)
               ("カンテラ(油入り)" . 0)
               ("油" . 0)
               ("ろうそく" . 0)
               ("葡萄酒" . 0)
               ("蒸留酒" . 0)
               ("果実酒" . 0)
               ("皮袋" . 0)
               ("傷薬" . 0)
               ("毒消し" . 0)
               ("眠り薬" . 0)
               ("革ヒモ" . 0)
               ("厚手のマント" . 0)
               ("水袋(水筒)" . 0)
               ("短剣" . 0) ;1
               ("剣" . 0) ;2
               ("短剣(セラミック製)" . 0) ;1
               ("額あて" . 0) ;1
               ("ランプ" . 0)
               ("鉄製の刀" . 0)
               ("ランプ(永久)" . 0)
               ("ケルラ" . 0)
               ("オームの数字" . 0)
               ("光" . 0)
               ("鉄の鍵" . 0)
               ("ペンダント" . 0)
               ("食料" . 0)
               ("長老の鍵" . 0)
               ("アスベル" . 0)
               ("兵士の鍵" . 0)
               ("銅の鍵" . 0)
               ("扉の錠の番号" . 0)
               ("森の人" . 0)
               ("高級傷薬" . 0)
               ("ペジテでの出会い" . 0)
               ("キツネリス" . 0)))

;(list-ref *equip* 1)
