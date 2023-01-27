#lang racket

(provide (all-defined-out))
(require 2htdp/image)
(struct pages (Page-num Flag Ppage C-list Pimage Arg))


#|
(define P001 (pages 001 "N" 0 '(014 027) (bitmap/file "picture/001.png") 0))
(define P002 (pages 002 "N" 0 '(031 057 039) (bitmap/file "picture/002.png") 0))
(define P003 (pages 003 "N" 0 '(160) (bitmap/file "picture/003.png") 0))
(define P004 (pages 004 "STATUS?" 0 '(999) (bitmap/file "picture/004.png") '("Ap" . ((10 . 082) (4 . 090) (0 . 069)))))
(define P005 (pages 005 "N" 0 '(035 008) (bitmap/file "picture/005.png") 0))
(define P006 (pages 006 "KAKU" 0 '(999) (bitmap/file "picture/006.png") '(10 15 053 040)))
;(define P007 (pages 007 "SAI007" 0 '(999) (bitmpa/file "picture/007.png") '("Ap" 050 028))
(define P008 (pages 008 "N" 0 '(094 005) (bitmap/file "picture/008.png") 0))
(define P009 (pages 009 "N" 0 '(036) (bitmap/file "picture/009.png") 0))
(define P010 (pages 010 "N" 0 '(022 017) (bitmap/file "picture/010.png") 0))
(define P011 (pages 011 "N" 0 '(047) (bitmap/file "picture/011.png") 0))
(define P012 (pages 012 "HPAC" 0 '(049) (bitmap/file "picture/012.png") '(-3 0)))
(define P013 (pages 013 "N" 0 '(044 055) (bitmap/file "picture/013.png") 0)) ;55で火薬Drop
(define P014 (pages 014 "N" 0 '(010) (bitmap/file "picture/014.png") 0))
(define P015 (pages 015 "HPAC" 0 '(035) (bitmap/file "picture/015.png") '(-1 0)))
(define P016 (pages 016 "N" 0 '(060 063) (bitmap/file "picture/016.png") 0))
(define P017 (pages 017 "N" 0 '(006) (bitmap/file "picture/017.png") 0))
;YESNOで戦うなら別ページで戦闘へ　YESNOの改造、メッセージを引数で与えるように
;(define P018 (pages 018 "YESNO" 0 '(999) (bitmap/file "picture/018.png") '("戦うか?" )))
(define P019 (pages 019 "N" 0 '(070 023 021) (bitmap/file "picture/019.png") 0))
(define P020 (pages 020 "KAKU" 0 '(999) (bitmap/file "picture/020.png") '(11 36 13 30)))
(define P021 (pages 021 "N" 0 '(072 056 019) (bitmap/file "picture/021.png") 0))
(define P022 (pages 022 "KAKU" 0 '(999) (bitmap/file "picture/022.png") '(3 6 29 34)))
(define P023 (pages 023 "N" 0 '(019 056) (bitmap/file "picture/023.png") 0))
;(define P024 (pages 024 "YESNO" 0 '(999) (bitmap/file "picture/024.png") '("戦うか？" )))
(define P025 (pages 025 "N" 0 '(051) (bitmap/file "picture/025.png") 0))
(define P026 (pages 026 "HPAC" 0 '(009) (bitmap/file "picture/026.png") '(0 1)))
(define P027 (pages 027 "N" 0 '(010) (bitmap/file "picture/027.png") 0))
(define P028 (pages 028 "N" 0 '(026) (bitmap/file "picture/028.png") 0))
(define P029 (pages 029 "HPAC" 0 '(0291) (bitmap/file "picture/029.png") '(0 -1)))
;(define P291 (pages 0291 "B" ↑の戦闘ページ
(define P030 (pages 030 "HPAC" 0 '(066) (bitmap/file "picture/030.png") '(-4 0)))
(define P031 (pages 031 "HPAC" 0 '(002) (bitmap/file "picture/031.png") '(-2 0)))
(define P032 (pages 032 "N" 0 '(005) (bitmap/file "picture/032.png") 0))
(define P033 (pages 033 "KAKU" 0 '(999) (bitmap/file "picture/033.png") '(4 6 20 54)))
(define P034 (pages 034 "N" 0 '(043) (bitmap/file "picture/034.png") 0))
(define P035 (pages 035 "N" 0 '(056 015 005) (bitmap/file "picture/035.png") 0))
(define P036 (pages 036 "KAKU" 0 '(999) (bitmap/file "picture/036.png") '(11 36 13 30)))
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
(define P065 (pages 065 "STATUS" 0 '(999) (bitmap/file "picture/065.png") '("Ap" . ((8 . 074) (0 . 107)))))
(define P066 (pages 066 "N" 0 '(059) (bitmap/file "picture/066.png") 0))
(define P067 (pages 067 "HPAC" 0 '(047) (bitmap/file "picture/067.png")'(-3 0)))
(define P068 (pages 068 "N" 0 '(100) (bitmap/file "picture/068.png") 0))
(define P069 (pages 069 "HPAC" 0 '(114) (bitmap/file "picture/069.png") '(-4 0)))
(define P070 (pages 070 "HPAC" 0 '(019) (bitmap/file "picture/070.png") '(-1 0)))
(define P071 (pages 071 "N" 0 '(024) (bitmap/file "picture/071.png") 0))
(define P072 (pages 072 "HPAC" 0 '(021) (bitmap/file "picture/072.png") '(-2 0)))
(define P073 (pages 073 "HPAC" 0 '(105) (bitmap/file "picture/073.png") '(0 -1)))
(define P074 (pages 074 "N" 0 '(086) (bitmap/file "picture/074.png") 0))
(define P075 (pages 075 "N" 0 '(091 039 061 049) (bitmap/file "picture/075.png") 0))
(define P076 (pages 076 "N" 0 '(097) (bitmap/file "picture/076.png") 0))
(define P077 (pages 077 "N" 0 '(062 080) (bitmap/file "picture/077.png") 0))
(define P078 (pages 078 "HPAC" 0 '(0781) (bitmap/file "picture/078.png") '(0 -1)))
(define P0781 (pages 0781 "KAKU" 0 '(999) (bitmap/file "picture/078.png") '(3 6 106 087)))

;79へ行くページの数をチェックしてNOに入れる
;(define P079 (pages 079 "NO" 0 '(121 1391 1481) (bitmap/file "picture/079.png") 0))
(define P080 (pages 080 "N" 0 '(088) (bitmap/file "picture/080.png") 0))
(define P081 (pages 081 "HPAC" 0 '(045) (bitmap/file "picture/081.png") '(-3 0)))
(define P082 (pages 082 "N" 0 '(116) (bitmap/file "picture/082.png") 0))
(define P083 (pages 083 "N" 0 '(002) (bitmap/file "picture/083.png") 0))
(define P084 (pages 084 "N" 0 '(163 139) (bitmap/file "picture/084.png") 0))
(define P085 (pages 085 "N" 0 '(144 111 102) (bitmap/file "picture/085.png") 0))
(define P086 (pages 086 "N" 0 '(193) (bitmap/file "picture/086.png") 0))
(define P087 (pages 087 "HPAC" 0 '(999) (bitmap/file "picture/087.png") '(0 -1)))
;(define P??? (pages ??? "KAKU" 0 '(999) (bitmap/file "picture/087.png") '(3 6 120 065)))
(define P088 (pages 088 "N" 0 '(115) (bitmap/file "picture/088.png") 0))
(define P089 (pages 089 "STATUS" 0 '(999) (bitmap/file "picture/089.png") '("Ap" . ((4 . 128) (0 . 084)))))
(define P090 (pages 090 "STATUS" 0 '(999) (bitmap/file "picture/090.png") '("Ap" . ((7 . 103) (0 . 114)))))
(define P091 (pages 091 "HPAC" 0 '(038) (bitmap/file "picture/091.png") '(3 0)))
(define P092 (pages 092 "N" 0 '(105) (bitmap/file "picture/092.png") 0))
(define P093 (pages 093 "N" 0 '(077) (bitmap/file "picture/093.png") 0))
(define P094 (pages 094 "N" 0 '(008) (bitmap/file "picture/094.png") 0))
(define P095 (pages 095 "N" 0 '(115 127 142 134) (bitmap/file "picture/095.png") 0))
(define P096 (pages 096 "N" 0 '(112) (bitmap/file "picture/096.png") 0))
(define P097 (pages 097 "END" 0 '(999) (bitmap/file "picture/097.png") 0))
(define P098 (pages 098 "N" 0 '(039 061 049) (bitmap/file "picture/098.png") 0))
(define P099 (pages 099 "KAKU" 0 '(999) (bitmap/file "picture/099.png") '(3 6 078 120)))
(define P100 (pages 100 "G" 0 '(081) (bitmap/file "picture/100.png") '("ゴーグル" . 1)))
(define P101 (pages 101 "N" 0 '(108 150) (bitmap/file "picture/101.png") 0))
(define P102 (pages 102 "NO" 0 '(鍵の数 085 142) (bitmap/file "picture/102.png") 0))
(define P103 (pages 103 "HPAC" 0 '(114) (bitmap/file "picture/103.png") '(1 0)))
(define P104 (pages 104 "N" 0 '(039) (bitmap/file "picture/104.png") 0))
(define P105 (pages 105 "HPAC" 0 '(064 093) (bitmap/file "picture/105.png") '(-3 0)))
(define P106 (pages 106 "N" 0 '(065) (bitmap/file "picture/106.png") 0))
(define P107 (pages 107 "KAKU" 0 '(999) (bitmap/file "picture/107.png") '(3 6 116 004)))
(define P108 (pages 108 "N" 0 '(121 115 129) (bitmap/file "picture/108.png") 0))
(define P109 (pages 109 "END" 0 '(999) (bitmap/file "picture/109.png") '(115)))
(define P110 (pages 110 "N" 0 '(145 134) (bitmap/file "picture/110.png") 0))
(define P111 (pages 111 "N" 0 '(085) (bitmap/file "picture/111.png") 0))
(define P112 (pages 112 "END" 0 '(999) (bitmap/file "picture/112.png") 0))
(define P113 (pages 113 "N" 0 '(127) (bitmap/file "picture/113.png") 0))
(define P114 (pages 114 "N" 0 '(086) (bitmap/file "picture/114.png") 0))
(define P115 (pages 115 "N" 0 '(108 095) (bitmap/file "picture/115.png") 0))
(define P116 (pages 116 "N" 0 '(086) (bitmap/file "picture/116.png") 0))
(define P117 (pages 117 "N" 0 '(138) (bitmap/file "picture/117.png") 0))
(define P118 (pages 118 "N" 0 '(109) (bitmap/file "picture/118.png") 0))
(define P119 (pages 119 "N" 0 '(136 134) (bitmap/file "picture/119.png") 0))
(define P120 (pages 120 "KAKU" 0 '(999) (bitmap/file "picture/120.png") '(3 6 087 106)))
(define P121 (pages 121 "G" 0 '(108) (bitmap/file "picture/121.png") '("鍵23" . 1)))
(define P122 (pages 122 "N" 0 '(126 135 150) (bitmap/file "picture/122.png") 0))
(define P123 (pages 123 "N" 0 '(142) (bitmap/file "picture/123.png") 0))
(define P124 (pages 124 "N" 0 '(109) (bitmap/file "picture/124.png") 0))
;↓装備をリセットするイベント
(define P125 (pages 125 "ERESET" 0 '(102) (bitmap/file "picture/125.png") 0))
(define P126 (pages 126 "NO" 0 '(023 122) (bitmap/file "picture/126.png") 0))
(define P127 (pages 127 "N" 0 '(113 144 095) (bitmap/file "picture/127.png") 0))
(define P128 (pages 128 "N" 0 '(134) (bitmap/file "picture/128.png") '(("鍵41" . 1) ("鍵35" . 1))))
(define P129 (pages 129 "N" 0 '(101 150 108) (bitmap/file "picture/129.png") 0))
(define P130 (pages 130 "N" 0 '(247) (bitmap/file "picture/130.png") 0))
(define P131 (pages 131 "N" 0 '(134) (bitmap/file "picture/131.png") 0))
(define P132 (pages 132 "HPAC" 0 '(166) (bitmap/file "picture/132.png") '(-2 0)))
(define P133 (pages 133 "HPAC" 0 '(186) (bitmap/file "picture/133.png") '(15 3)))
(define P134 (pages 134 "N" 0 '(119 095 110) (bitmap/file "picture/134.png") 0))
(define P135 (pages 135 "N" 0 '(122) (bitmap/file "picture/135.png") 0))
(define P136 (pages 136 "N" 0 '(089 134) (bitmap/file "picture/136.png") 0))
(define P137 (pages 137 "N" 0 '(102) (bitmap/file "picture/137.png") 0))
(define P138 (pages 138 "C" 0 '(999) (bitmap/file "picture/138.png") '("ポムじいさん" 171 147)))
(define P139 (pages 139 "HPAC" 0 '(???) (bitmap/file "picture/139.png") '(0 1)))
(define P1391 (pages 1391 "G" 0 '(079 134) (bitmap/file "picture/139.png") '(("鍵41" . 1) ("鍵35" . 1))))
(define P140 (pages 140 "C" 0 '(999) (bitmap/file "picture/140.png") '("巨人の胸の印" 187 132)))
(define P141 (pages 141 "N" 0 '(162) (bitmap/file "picture/141.png") 0))
(define P142 (pages 142 "N" 0 '(095 102 123) (bitmap/file "picture/142.png") 0))
(define P143 (pages 143 "N" 0 '(102) (bitmap/file "picture/143.png") 0))
(define P144 (pages 144 "N" 0 '(150 085 127) (bitmap/file "picture/144.png") 0))
(define P145 (pages 145 "N" 0 '(158 134 153) (bitmap/file "picture/145.png") 0))
(define P146 (pages 146 "N" 0 '(193) (bitmap/file "picture/146.png") 0))
(define P147 (pages 147 "C" 0 '(999) (bitmap/file "picture/147.png") '("巨人" 177 173)))
(define P148 (pages 148 "HPAC" 0 '(1481) (bitmap/file "picture/148.png") '(0 2)))
(define P1481 (pages 1481 "G" 0 '(079 134) (bitmap/file "picture/148.png") '(("鍵41" . 1) ("鍵35" . 1))))
(define P149 (pages 149 "N" 0 '(126) (bitmap/file "picture/149.png") 0))
(define P150 (pages 150 "N" 0 '(129 142 122) (bitmap/file "picture/150.png") 0))
(define P151 (pages 151 "G?" 0 '(156) (bitmap/file "picture/151.png") '("ブラックジャック" . 1)))
|#
(define P152 (pages 152 "B" 0 '(157 124) (bitmap/file "picture/152.png") 3))
#|
(define P153 (pages 153 "HPAC" 0 '(1531) (bitmap/file "picture/153.png") '(0 1 "ブラックジャック" 1)))
;(define P1531 (pages 1531 "SAI153" 0 '(158の分離先複数) (bitmap/file "picture/153.png") 0))
(define P154 (pages 154 "N" 0 '(180) (bitmap/file "picture/154.png") 0))
(define P155 (pages 155 "N" 0 '(109) (bitmap/file "picture/155.png") 0))
(define P156 (pages 156 "N" 0 '(131) (bitmap/file "picture/156.png") 0))
(define P157 (pages 157 "HPAC" 0 '(083) (bitmap/file "picture/157.png") '(0 1)))
;(define P158a (pages 1581 "B" 0 '(151 118) (bitmap/file "picture/158.png") 2))
;(define P158b (pages 1582 "B" 0 '(151 118) (bitmap/file "picture/158.png") 2))
;(define P158c (pages 1583 "B" 0 '(151 118) (bitmap/file "picture/158.png") 2))
(define P159 (pages 159 "END" 0 '(999) (bitmap/file "picture/159.png") 0))
(define P160 (pages 160 "N" 0 '(117) (bitmap/file "picture/160.png") 0))
(define P161 (pages 161 "N" 0 '(152) (bitmap/file "picture/161.png") 0))
(define P162 (pages 162 "N" 0 '(154) (bitmap/file "picture/162.png") 0))
(define P163 (pages 163 "B" 0 '(148 155) (bitmap/file "picture/163.png") 1))
(define P164 (pages 164 "N" 0 '(184) (bitmap/file "picture/164.png") 0))
(define P165 (pages 165 "SAI007" 0 '(194 203) (bitmap/file "picture/165.png") '("Ap" 194 203)))
(define P166 (pages 166 "N" 0 '(182) (bitmap/file "picture/166.png") 0))
(define P167 (pages 167 "N" 0 '(126) (bitmap/file "picture/167.png") 0))
(define P168 (pages 168 "HPAC" 0 '(234) (bitmap/file "picture/168.png") '("火薬ビン" -1)))
(define P169 (pages 169 "HPAC" 0 '(1691) (bitmap/file "picture/169.png") '(-1 0)))
(define P1691 (pages 1691 "SAI007" 0 '(999) (bitmap/file "picture/169.png") '("Ap" 229 205)))
(define P170 (pages 170 "HPAC" 0 '(199) (bitmap/file "picture/170.png") '(-2 0)))
(define P171 (pages 171 "N" 0 '(147) (bitmap/file "picture/171.png") 0))
(define P172 (pages 172 "N" 0 '(141 176) (bitmap/file "picture/172.png") 0))
(define P173 (pages 173 "N" 0 '(140) (bitmap/file "picture/173.png") 0))
(define P174 (pages 174 "SAI007" 0 '(999) (bitmap/file "picture/174.png") '("AP" 194 203)))
(define P175 (pages 175 "HPAC" 0 '(212) (bitmap/file "picture/175.png") '(-1 0)))
(define P176 (pages 176 "N" 0 '(162) (bitmap/file "picture/176.png") 0))
(define P177 (pages 177 "N" 0 '(140) (bitmap/file "picture/177.png") 0))
(define P178 (pages 178 "N" 0 '(146) (bitmap/file "picture/178.png") 0))
(define P179 (pages 179 "N" 0 '(198) (bitmap/file "picture/179.png") 0))
(define P180 (pages 180 "N" 0 '(192) (bitmap/file "picture/180.png") 0))
(define P181 (pages 181 "N" 0 '(223 175) (bitmap/file "picture/181.png") 0))
(define P182 (pages 182 "N" 0 '(178) (bitmap/file "picture/182.png") 0))
;↓のページは二度目はEvent＃fなので通ったページはリストにして持つのを実装
(define P183 (pages 183 "HPAC" 0 '(252) (bitmap/file "picture/183.png") 0))
(define P184 (pages 184 "N" 0 '(206) (bitmap/file "picture/184.png") 0))
(define P185 (pages 185 "HPAC" 0 '(191) (bitmap/file "picture/185.png") '(-2 0)))
(define P186 (pages 186 "N" 0 '(172) (bitmap/file "picture/186.png") 0))
(define P187 (pages 187 "HPAC" 0 '(178) (bitmap/file "picture/187.png") '(0 2)))
(define P188 (pages 188 "C" 0 '(999) (bitmap/file "picture/188.png") '("火薬ビン" 1671 214)))
(define P1881 (pages 1881 "YESNO" 0 '(999) (bitmap/file "picture/188.png") '("火薬ビンを使うか？" 168 214)))
(define P189 (pages 189 "SAI007" 0 '(999) (bitmap/file "picture/189.png") '("AP" 185 196)))
(define P190 (pages 190 "N" 0 '(209 221) (bitmap/file "picture/190.png") 0))
|#





























;(define *page-list* `(P000 P001 P002 P003 P004 P005 P006 P007 P008 P009 P010 P011 P012 P013 P014 P015 P016 P017 P018 P019 P020 P021 P022 P023 P024 P025 P026 P027 P028 P029 P030 P031 P032 P033 P034 P035 P036 P037 P038 P039 P040 P041 P042 P043 P044 P045 P046 P047 P048 P049 P050 P051 P052 P053 P054 P055 P056 P057 P058 P059 P060 P061 P062 P063 P064 P065 P066 P067 P068 P069 P070 P071 P072 P073 P074 P075 P076 P077 P078 P079 P080 P081 P082 P083 P084 P085 P086 P087 P088 P089 P090 P091 P092 P093 P094 P095 P096 P097 P098 P099 P100 P101 P102 P103 P104 P105 P106 P107 P108 P109 P110 P111 P112 P113 P114 P115 P116 P117 P118 P119 P120 P121 P122 P123 P124 P125 P126 P127 P128 P129 P130 P131 P132 P133 P134 P135 P136 P137 P138 P139 P140 P141 P142 P143 P144 P145 P146 P147 P148 P149 P150 P151 ,P152 P153 P154 P155 P156 P157 P158 P159 P160 P161 P162 P163 P164 P165 P166 P167 P168 P169 P170 P171 P172 P173 P174 P175 P176 P177 P178 P179 P180 P181 P182 P183 P184 P185 P186 P187 P188 P189 P190 P191 P192 P193 P194 P195 P196 P197 P198 P199 P200 P201 P202 P203 P204 P205 P206 P207 P208 P209 P210 P211 P212 P213 P214 P215 P216 P217 P218 P219 P220 P221 P222 P223 P224 P225 P226 P227 P228 P229 P230 P231 P232 P233 P234 P235 P236 P237 P238 P239 P240 P241 P242 P243 P244 P245 P246 P247 P248 P249 P250 P251 P252 P253 P254 P255 P256 P257 P258 P259 P260 ))

(define page-list `(,P152))



















