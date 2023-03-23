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
