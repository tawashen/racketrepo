#lang racket

(require 2htdp/universe 2htdp/image lang/posn)
(require describe)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(provide (all-defined-out))





;構造体;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(struct BATTLE (C-LIST PHASE TURN ITEM MAGIC MONEY EXP E-ZAHYO STATUS TEXT MENU U-ITEM C-MAGIC) #:transparent #:mutable) 
(struct ABILITY (RACE STR INT WIS DEX CON CHR) #:transparent)
(struct CHARACTER (Name Image Race Class Ali Lv Hp Ac Exp Money Move Arm Armor Sield Item Skill Str Int Wis Dex Con Chr) #:transparent #:mutable)
(struct HERO CHARACTER () #:transparent #:mutable)
(struct ENEMY CHARACTER () #:transparent #:mutable)

;キャラクター構造体;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define HUMAN (ABILITY "HUMAN" 0 0 0 0 0 0))
(define ELF (ABILITY "ELF" -2 2 0 0 -2 2))

;アイテム構造体;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(struct BUKI (Bname Bcost BdamageS BdamageM Bcrit Brange Bweight Btype Bspecial) #:transparent)
(struct ARMOR (Aname Acost Abonus Alimit Apena Arate AmoveL AmoveS Aweight) #:transparent)
(struct SIHELD (Sname Scost Sbonus Slimit Spena Srate Sweight) #:transparent)
(struct ITEM (Iname Icost Ikind Ipower) #:transparent)
(struct MAGIC (Mname Mkind Mlv Matt Mpower) #:transparent)


(struct CLASS (NAME REQUIRE))
(define FIGHTER (CLASS "FIGHTER" 'Str))
(define MAGIC-USER (CLASS "MAGIC-USER" 'Int))
(define CLERIC (CLASS "CLERIC" 'Wis))
(define THIEF (CLASS "THIEF" 'Dex))
(define *class-list-human* `(,FIGHTER ,MAGIC-USER ,CLERIC ,THIEF))
(define *class-list-elf* `(,FIGHTER ,MAGIC-USER ,THIEF))

#|;アイテムインスタンス;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;test用
(define B001 (BUKI "ロングソード" 15 '(1 . 6) '(1 . 8) '(19 . 2) 0 4 1 '()))
(define A001 (ARMOR "チェインメイル" 150 6 2 -5 30 20 15 40))
(define S001 (SIHELD "バックラー" 5 1 0 -1 5 5))
(define I001 (ITEM "やくそう" 10 "HS" 10)) ;回復自分 HS
(define I002 (ITEM "高級薬草" 20 "HS" 20)) ;回復自分 HS
(define I003 (ITEM "投げ薬草" 20 "HO" 10)) ;回復他人も HO
(define I004 (ITEM "うんこ" 5 "AS" 20)) ;攻撃敵単体 AS
(define M001 (MAGIC "メラ" "AS" 1 "WIZ" 10)) ;攻撃敵単体 AS
(define M002 (MAGIC "イオ" "AC" 3 "SOR" 20)) ;攻撃敵全体 AC
(define M003 (MAGIC "ホイミ" "HO" 1 "CRE" 20)) ;味方単体回復 HO
(define M004 (MAGIC "ベホマラー" "HC" 5 "CRE" 20)) ;味方全体回復 HC
|#

;(define test '(0 0 0 0 0 0 ))
#;
(define test-hero (HERO "tawa" (bitmap/file "picture/03.png") "ELF" "FIGHTER" '(0 0 0 0 0 0) 1 '(120 . 100) 10 0 90 '(6 . 6)
                 `(,B001) `(,A001) `(,S001) `((,I001 . 1) (,I002 . 2) (,I003 . 2) (,I004 . 2)) `((,M001 . 3) (,M002 . 2) (,M003 . 3) (,M004 . 3)) 10 18 6 11 9 10))
;(define sleep-attack (lambda (x) (set-CHARACTER-Ali! x `(,(random 1 3) 0 0 0 0 0))))

;(define test-skill `(,sleep-attack ,poison-attack))
;((list-ref test-skill 1) test)
;(sleep-attack test-hero)
;(CHARACTER-Ali test-hero)
