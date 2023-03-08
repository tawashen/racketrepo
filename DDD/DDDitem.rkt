#lang racket


(struct BUKI (Bname Bcost BdamageS BdamageM Bcrit Brange Bweight Btype Bspecial))
(struct ARMOR (Aname Acost Abonus Alimit Apena Arate AmoveL AmoveS Aweight))
(struct SIHELD (Sname Scost Sbonus Slimit Spena Srate Sweight))

(define B001 (BUKI "ロングソード" 15 (random 1 6) (random 1 8) 19 0 4 1 '()))
(define A001 (ARMOR "チェインメイル" 150 6 2 -5 30 20 15 40))
(define S001 (SIHELD "バックラー" 5 1 0 -1 5 5))

;(BUKI-Bcrit B001)



