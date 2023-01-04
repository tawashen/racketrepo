#lang racket

(provide (all-defined-out))
(require 2htdp/image)
(struct pages (Page-num Flag Ppage C-list Pimage Arg))


(define P001 (pages 001 "N" 0 '(014 027) (bitmap/file "picture/001.png") 0))
(define P002 (pages 002 "N" 0 '(031 057 039) (bitmap/file "picture/002.png") 0))
(define P003 (pages 003 "N" 0 '(160) (bitmap/file "picture/003.png") 0))
;(define P004 (pages 004 "STATUS?" 0 '(999) (bitmap/file "picture/004.png") '("Ap" . ((10 . 082) (4 . 090) (0 . 069)))))
(define P005 (pages 005 "N" 0 '(035 008) (bitmap/file "picture/005.png") 0))
;(define P006 (pages 006 "SAI" 0 '(999) (bitmap/file "picture/006.png") '(053 040))
;(define P007 (pages 007 "SAI" 0 '(999) (bitmpa/file "picture/007.png") '(050 028))
(define P008 (pages 008 "N" 0 '(094 005) (bitmap/file "picture/008.png") 0))
(define P009 (pages 009 "N" 0 '(036) (bitmap/file "picture/009.png") 0))
(define P010 (pages 010 "N" 0 '(022 017) (bitmap/file "picture/010.png") 0))
(define P011 (pages 011 "N" 0 '(047) (bitmap/file "picture/011.png") 0))
(define P012 (pages 012 "HPAC" 0 '(049) (bitmap/file "picture/012.png") '(-3 0)))
;(define P013 (pages 013 "N" 0 '(044 055) (bitmap/file "picture/013.png") 0)) ;55で火薬Drop
(define P014 (pages 014 "N" 0 '(010) (bitmap/file "picture/014.png") 0))
(define P015 (pages 015 "HPAC" 0 '(035) (bitmap/file "picture/015.png") '(-1 0)))
(define P016 (pages 016 "N" 0 '(060 063) (bitmap/file "picture/016.png") 0))
(define P017 (pages 017 "N" 0 '(006) (bitmap/file "picture/017.png") 0))
;YESNOで戦うなら別ページで戦闘へ　YESNOの改造、メッセージを引数で与えるように
;(define P018 (pages 018 "YESNO" 0 '(999) (bitmap/file "picture/018.png") '("戦うか?" )))
(define P019 (pages 019 "N" 0 '(070 023 021) (bitmap/file "picture/019.png") 0))
;(define P020 (pages 020 "SAI" 0 '(999) (bitmap/file "picture/020.png") 0)) SAIの仕様を考える
(define P021 (pages 021 "N" 0 '(072 056 019) (bitmap/file "picture/021.png") 0))
;(define P022 (pages 022 "SAI" 0 '(999) (bitmap/file "picture/022.png") '(29 34)))
(define P023 (pages 023 "N" 0 '(019 056) (bitmap/file "picture/023.png") 0))
;(define P024 (pages 024 "YESNO" 0 '(999) (bitmap/file "picture/024.png") '("戦うか？" )))
(define P025 (pages 025 "N" 0 '(051) (bitmap/file "picture/025.png") 0))
(define P026 (pages 026 "HPAC" 0 '(009) (bitmap/file "picture/026.png") '(0 1)))
(define P027 (pages 027 "N" 0 '(010) (bitmap/file "picture/027.png") 0))
(define P028 (pages 028 "N" 0 '(026) (bitmap/file "picture/028.png") 0))
;(define P029 (pages 029 "HPAC" 0 '(戦闘のページへ) (bitmap/file "picture/029.png") '(0 -1)))
;(define P??? ↑の戦闘ページ
(define P030 (pages 030 "HPAC" 0 '(066) (bitmap/file "picture/030.png") '(-4 0)))
(define P031 (pages 031 "HPAC" 0 '(002) (bitmap/file "picture/031.png") '(-2 0)))
(define P032 (pages 032 "N" 0 '(005) (bitmap/file "picture/032.png") 0))
;(define P033 (pages 033 "SAI" 0 '(999) (bitmap/file "picture/033.png") '(20 54)))
(define P034 (pages 034 "N" 0 '(043) (bitmap/file "picture/034.png") 0))
(define P035 (pages 035 "N" 0 '(056 015 005) (bitmap/file "picture/035.png") 0))
;(define P036 (pages 036 "SAI" 0 '(999) (bitmap/file "picture/036.png") '(13 30)))
(define P037 (pages 037 "HPAC" 0 '(043) (bitmap/file "picture/037.png") '(0 1)))
(define P038 (pages 038 "N" 0 '(016) (bitmap/file "picture/038.png") 0))
(define P039 (pages 039 "N" 0 '(002 100 075) (bitmap/file "picture/039.png") 0))
(define P040 (pages 040 "N" 0 '(037) (bitmap/file "picture/040.png") '(0 -1)))
(define P041 (pages 041 "N" 0 '(061) (bitmap/file "picture/041.png") '(-1 0)))
(define P042 (pages 042 "N" 0 '(056) (bitmap/file "picture/042.png") 0))
(define P043 (pages 043 "N" 0 '(007) (bitmap/file "picture/043.png") 0))
(define P044 (pages 044 "N" 0 '(067) (bitmap/file "picture/044.png") 0))
(define P045 (pages 045 "N" 0 '(099) (bitmap/file "picture/045.png") 0))
(define P046 (pages 046 "N" 0 '(033) (bitmap/file "picture/046.png") 0))
(define P047 (pages 047 "N" 0 '(032) (bitmap/file "picture/047.png") 0))
(define P048 (pages 048 "N" 0 '(028) (bitmap/file "picture/048.png") 0))
(define P049 (pages 049 "N" 0 '(012 075 052 008) (bitmap/file "picture/049.png") 0))
(define P050 (pages 050 "N" 0 '(046) (bitmap/file "picture/050.png") '(-1 0)))
(define P051 (pages 051 "N" 0 '(098) (bitmap/file "picture/051.png") 0))
(define P052 (pages 052 "N" 0 '(049 061) (bitmap/file "picture/052.png") 0))
(define P053 (pages 053 "N" 0 '(037) (bitmap/file "picture/053.png") 0))
(define P054 (pages 054 "N" 0 '(066) (bitmap/file "picture/054.png") '(0 -3)))
(define P055 (pages 055 "D" 0 '(011) (bitmap/file "picture/055.png") '("火薬ビン" . -1)))
(define P056 (pages 056 "N" 0 '(023 035 042 021) (bitmap/file "picture/056.png") 0))
;アイテムにポムじいさんを入れること
(define P057 (pages 057 "C" 0 '(999) (bitmap/file "picture/057.png") '("ポムじいさん" 071 048)))
;(define P058 (pages 058 "YESNO" 0 '(999) (bitmap/file "picture/058.png") '("再挑戦するか？" (RESTART 022) END)))
(define P059 (pages 059 "N" 0 '(023) (bitmap/file "picture/059.png") 0))
(define P060 (pages 060 "N" 0 '(025) (bitmap/file "picture/060.png") 0))
(define P061 (pages 061 "N" 0 '(075 041 052) (bitmap/file "picture/061.png") 0))
(define P062 (pages 062 "N" 0 '(068 096) (bitmap/file "picture/062.png") 0))
(define P063 (pages 063 "N" 0 '(060) (bitmap/file "picture/063.png") 0))
(define P064 (pages 064 "N" 0 '(093) (bitmap/file "picture/064.png") 0))
(define P065 (pages 065 "STATUS" 0 '(999) (bitmap/file "picture/014.png") '("Ap" . ((8 . 074) (0 . 107)))))










































































































