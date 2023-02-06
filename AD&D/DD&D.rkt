#lang racket

;構造体とインスタンス作成
(struct ABILITY (RACE STR INT WIS DEX CON CHR))
(struct CHARACTER (Name Race Class Ali Lv Hp Ac Exp Money Move Str Int Wis Dex Con Chr) #:transparent)

(define HUMAN (ABILITY "HUMAN" 0 0 0 0 0 0))
(define ELF (ABILITY "ELF" -2 2 0 0 -2 2))

(define *chara-list* '())
(define *member-list* '())
