#lang racket

(provide (all-defined-out))
(require 2htdp/image)
(struct pages (Page-num Flag Ppage C-list Pimage Arg))



(define P001 (pages 001 "N" 0 '(014 027) (bitmap/file "picture/001.png") 0))
(define P002 (pages 002 "N" 0 '(031 057 039) (bitmap/file "picture/002.png") 0))
(define P003 (pages 003 "N" 0 '(160) (bitmap/file "picture/003.png") 0))
(define P004 (pages 004 "STATUS" 0 '(999) (bitmap/file "picture/004.png") '("Ac" . ((10 . 082) (4 . 090) (0 . 069)))))
(define P005 (pages 005 "N" 0 '(035 008) (bitmap/file "picture/005.png") 0))
(define P006 (pages 006 "SAI006" 0 '(999) (bitmap/file "picture/006.png") '(3 10 053 040)))
(define P007 (pages 007 "SAI007" 0 '(999) (bitmap/file "picture/007.png") '("Ac" 050 028)))
(define P008 (pages 008 "N" 0 '(094 005) (bitmap/file "picture/008.png") 0))
(define P009 (pages 009 "N" 0 '(036) (bitmap/file "picture/009.png") 0))
(define P010 (pages 010 "N" 0 '(022 017) (bitmap/file "picture/010.png") 0))
(define P011 (pages 011 "N" 0 '(047) (bitmap/file "picture/011.png") 0))
(define P012 (pages 012 "HPAC" 012 '(049) (bitmap/file "picture/012.png") '(-3 0)))
(define P013 (pages 013 "N" 0 '(044 055) (bitmap/file "picture/013.png") 0))
(define P014 (pages 014 "N" 0 '(010) (bitmap/file "picture/014.png") 0))
(define P015 (pages 015 "HPAC" 015 '(035) (bitmap/file "picture/015.png") '(-1 0)))
(define P016 (pages 016 "N" 0 '(060 063) (bitmap/file "picture/016.png") 0))
(define P017 (pages 017 "N" 0 '(006) (bitmap/file "picture/017.png") 0))
(define P018 (pages 018 "YESNO" 0 '(999) (bitmap/file "picture/018.png") '("戦うか? [y]es or [n]o" 018001 073)))
(define P018001 (pages 018001 "B" 0 '(076 092) (bitmap/file "picture/018.png") 2))
(define P019 (pages 019 "N" 0 '(070 023 021) (bitmap/file "picture/019.png") 0))
(define P020 (pages 020 "SAI020" 0 '(999) (bitmap/file "picture/020.png") '(11 36 13 30)))
(define P021 (pages 021 "N" 0 '(072 056 019) (bitmap/file "picture/021.png") 0))
(define P022 (pages 022 "SAI022" 0 '(999) (bitmap/file "picture/022.png") '('ZORO '(3 11) 29 34)))
(define P023 (pages 023 "N" 0 '(019 056) (bitmap/file "picture/023.png") 0))
(define P024 (pages 024 "YESNO" 0 '(999) (bitmap/file "picture/024.png") '("戦うか？[y]es or [n]o" 018 073)))
(define P025 (pages 025 "N" 0 '(051) (bitmap/file "picture/025.png") 0))
(define P026 (pages 026 "HPAC" 026 '(009) (bitmap/file "picture/026.png") '(0 1)))
(define P027 (pages 027 "N" 0 '(010) (bitmap/file "picture/027.png") 0))
(define P028 (pages 028 "N" 0 '(026) (bitmap/file "picture/028.png") 0))
(define P029 (pages 029 "HPAC" 029 '(0291) (bitmap/file "picture/029.png") '(0 -1)))
(define P029001 (pages 029001 "B" 0 '(006 029002) (bitmap/file "picture/029.png") 2))
(define P029002 (pages 029002 "HPAC" 29002 '(058) (bitmap/file "picture/029.png") '(-2 0)))
(define P030 (pages 030 "HPAC" 030 '(066) (bitmap/file "picture/030.png") '(-4 0)))
(define P031 (pages 031 "HPAC" 031 '(002) (bitmap/file "picture/031.png") '(-2 0)))
(define P032 (pages 032 "N" 0 '(005) (bitmap/file "picture/032.png") 0))
(define P033 (pages 033 "SAI033" 0 '(999) (bitmap/file "picture/033.png") '(1 '(3 4 5) 20 54)))
(define P034 (pages 034 "N" 0 '(043) (bitmap/file "picture/034.png") 0))
(define P035 (pages 035 "N" 0 '(056 015 005) (bitmap/file "picture/035.png") 0))
(define P036 (pages 036 "SAI022" 0 '(999) (bitmap/file "picture/036.png") '('ZORO '(3 11) 13 30)))
(define P037 (pages 037 "HPAC" 037 '(043) (bitmap/file "picture/037.png") '(0 1)))
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
(define P055 (pages 055 "HPAC" 055 '(011) (bitmap/file "picture/055.png") '(0 0 "火薬ビン" -1)))
(define P056 (pages 056 "N" 0 '(023 035 042 021) (bitmap/file "picture/056.png") 0))
(define P057 (pages 057 "C" 0 '(999) (bitmap/file "picture/057.png") '("ポムじいさん" 071 048)))
(define P058 (pages 058 "YESNO" 0 '(999) (bitmap/file "picture/058.png") '("再挑戦するか？[y]es or [n]o" 022 9999)))
(define P059 (pages 059 "N" 0 '(023) (bitmap/file "picture/059.png") 0))
(define P060 (pages 060 "N" 0 '(025) (bitmap/file "picture/060.png") 0))
(define P061 (pages 061 "N" 0 '(075 041 052) (bitmap/file "picture/061.png") 0))
(define P062 (pages 062 "N" 0 '(068 096) (bitmap/file "picture/062.png") 0))
(define P063 (pages 063 "N" 0 '(060) (bitmap/file "picture/063.png") 0))
(define P064 (pages 064 "N" 0 '(093) (bitmap/file "picture/064.png") 0))
(define P065 (pages 065 "STATUS" 0 '(999) (bitmap/file "picture/065.png") '("Ac" . ((8 . 074) (0 . 107)))))
(define P066 (pages 066 "N" 0 '(059) (bitmap/file "picture/066.png") 0))
(define P067 (pages 067 "HPAC" 067 '(047) (bitmap/file "picture/067.png")'(-3 0)))
(define P068 (pages 068 "N" 0 '(100) (bitmap/file "picture/068.png") 0))
(define P069 (pages 069 "HPAC" 069 '(114) (bitmap/file "picture/069.png") '(-4 0)))
(define P070 (pages 070 "HPAC" 070 '(019) (bitmap/file "picture/070.png") '(-1 0)))
(define P071 (pages 071 "N" 0 '(024) (bitmap/file "picture/071.png") 0))
(define P072 (pages 072 "HPAC" 072 '(021) (bitmap/file "picture/072.png") '(-2 0)))
(define P073 (pages 073 "HPAC" 073 '(105) (bitmap/file "picture/073.png") '(0 -1)))
(define P074 (pages 074 "N" 0 '(086) (bitmap/file "picture/074.png") 0))
(define P075 (pages 075 "N" 0 '(091 039 061 049) (bitmap/file "picture/075.png") 0))
(define P076 (pages 076 "N" 0 '(097) (bitmap/file "picture/076.png") 0))
(define P077 (pages 077 "N" 0 '(062 080) (bitmap/file "picture/077.png") 0))
(define P078 (pages 078 "HPAC" 078 '(0781) (bitmap/file "picture/078.png") '(0 -1)))
(define P0781 (pages 0781 "SAI033" 0 '(999) (bitmap/file "picture/078.png") '(1 '(3 4 5) 106 087)))
(define P079 (pages 079 "NO" 0 '(121 1391 1481) (bitmap/file "picture/079.png") 0))
(define P080 (pages 080 "N" 0 '(088) (bitmap/file "picture/080.png") 0))
(define P081 (pages 081 "HPAC" 081 '(045) (bitmap/file "picture/081.png") '(-3 0)))
(define P082 (pages 082 "N" 0 '(116) (bitmap/file "picture/082.png") 0))
(define P083 (pages 083 "N" 0 '(002) (bitmap/file "picture/083.png") 0))
(define P084 (pages 084 "N" 0 '(163 139) (bitmap/file "picture/084.png") 0))
(define P085 (pages 085 "N" 0 '(144 111 102) (bitmap/file "picture/085.png") 0))
(define P086 (pages 086 "N" 0 '(193) (bitmap/file "picture/086.png") 0))
(define P087 (pages 087 "HPAC" 087 '(087001) (bitmap/file "picture/087.png") '(0 -1)))
(define P087001 (pages 087001 "SAI033" 0 '(999) (bitmap/file "picture/087.png") '(1 '(1 2 3) 120 065)))
(define P088 (pages 088 "N" 0 '(115) (bitmap/file "picture/088.png") 0))
(define P089 (pages 089 "STATUS" 0 '(999) (bitmap/file "picture/089.png") '("Ac" . ((4 . 128) (0 . 084)))))
(define P090 (pages 090 "STATUS" 0 '(999) (bitmap/file "picture/090.png") '("Ac" . ((7 . 103) (0 . 114)))))
(define P091 (pages 091 "HPAC" 091 '(038) (bitmap/file "picture/091.png") '(3 0)))
(define P092 (pages 092 "N" 0 '(105) (bitmap/file "picture/092.png") 0))
(define P093 (pages 093 "N" 0 '(077) (bitmap/file "picture/093.png") 0))
(define P094 (pages 094 "N" 0 '(008) (bitmap/file "picture/094.png") 0))
(define P095 (pages 095 "N" 0 '(115 127 142 134) (bitmap/file "picture/095.png") 0))
(define P096 (pages 096 "N" 0 '(112) (bitmap/file "picture/096.png") 0))
(define P097 (pages 097 "END" 0 '(999) (bitmap/file "picture/097.png") 0))
(define P098 (pages 098 "N" 0 '(039 061 049) (bitmap/file "picture/098.png") 0))
(define P099 (pages 099 "SAI033" 0 '(999) (bitmap/file "picture/099.png") '(1 '(2 4 6) 078 120)))
(define P100 (pages 100 "G" 100 '(081) (bitmap/file "picture/100.png") '("ゴーグル" . 1)))
(define P101 (pages 101 "N" 0 '(108 150) (bitmap/file "picture/101.png") 0))

(define P102 (pages 102 "NO" 0 '(125 137 143 085 142) (bitmap/file "picture/102.png") 0))

(define P103 (pages 103 "HPAC" 103 '(114) (bitmap/file "picture/103.png") '(1 0)))
(define P104 (pages 104 "N" 0 '(039) (bitmap/file "picture/104.png") 0))
(define P105 (pages 105 "HPAC" 105 '(064 093) (bitmap/file "picture/105.png") '(-3 0)))
(define P106 (pages 106 "N" 0 '(065) (bitmap/file "picture/106.png") 0))
(define P107 (pages 107 "SAI033" 0 '(999) (bitmap/file "picture/107.png") '(1 '(1 5 6) 116 004)))
(define P108 (pages 108 "N" 0 '(121 115 129) (bitmap/file "picture/108.png") 0))
(define P109 (pages 109 "YESNO" 0 '(999) (bitmap/file "picture/109.png") '("再挑戦するか？[y]es or [n]o" 115 9999)))
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
(define P120 (pages 120 "SAI033" 0 '(999) (bitmap/file "picture/120.png") '(1 '(3 4 5) 087 106)))
(define P121 (pages 121 "G" 121 '(079 108) (bitmap/file "picture/121.png") '("P121の鍵" . 23)))
(define P122 (pages 122 "N" 0 '(126 135 150) (bitmap/file "picture/122.png") 0))
(define P123 (pages 123 "N" 0 '(142) (bitmap/file "picture/123.png") 0))
(define P124 (pages 124 "N" 0 '(109) (bitmap/file "picture/124.png") 0))

;↓装備をリセットするイベント
(define P125 (pages 125 "RESET" 125 '(102) (bitmap/file "picture/125.png") '("スパナ" "モンキー" "レンチ")))

(define P126 (pages 126 "NO" 0 '(023 122) (bitmap/file "picture/126.png") 0))
(define P127 (pages 127 "N" 0 '(113 144 095) (bitmap/file "picture/127.png") 0))
(define P128 (pages 128 "N" 0 '(134) (bitmap/file "picture/128.png") '(("P128の鍵A" . 41) ("P128の鍵B" . 35))))
(define P129 (pages 129 "N" 0 '(101 150 108) (bitmap/file "picture/129.png") 0))
(define P130 (pages 130 "N" 0 '(247) (bitmap/file "picture/130.png") 0))
(define P131 (pages 131 "HPAC" 131 '(134) (bitmap/file "picture/131.png") '(0 0 "巨人の胸の印" 1)))
(define P132 (pages 132 "HPAC" 132 '(166) (bitmap/file "picture/132.png") '(-2 0)))
(define P133 (pages 133 "HPAC" 133 '(186) (bitmap/file "picture/133.png") '(15 3)))
(define P134 (pages 134 "N" 0 '(119 095 110) (bitmap/file "picture/134.png") 0))
(define P135 (pages 135 "N" 0 '(122) (bitmap/file "picture/135.png") 0))
(define P136 (pages 136 "N" 0 '(089 134) (bitmap/file "picture/136.png") 0))
(define P137 (pages 137 "N" 0 '(102) (bitmap/file "picture/137.png") 0))
(define P138 (pages 138 "C" 0 '(999) (bitmap/file "picture/138.png") '("ポムじいさん" 171 147)))
(define P139 (pages 139 "HPAC" 139 '(???) (bitmap/file "picture/139.png") '(0 1)))

(define P1391 (pages 1391 "G" 1391 '(079 134) (bitmap/file "picture/139.png") '(("P139の鍵A" . 41) ("P139の鍵B" . 35))))

(define P140 (pages 140 "C" 0 '(999) (bitmap/file "picture/140.png") '("巨人の胸の印" 187 132))) ;
(define P141 (pages 141 "N" 0 '(162) (bitmap/file "picture/141.png") 0))
(define P142 (pages 142 "N" 0 '(095 102 123) (bitmap/file "picture/142.png") 0))
(define P143 (pages 143 "N" 0 '(102) (bitmap/file "picture/143.png") 0))
(define P144 (pages 144 "N" 0 '(150 085 127) (bitmap/file "picture/144.png") 0))
(define P145 (pages 145 "N" 0 '(158 134 153) (bitmap/file "picture/145.png") 0))
(define P146 (pages 146 "N" 0 '(193) (bitmap/file "picture/146.png") 0))
(define P147 (pages 147 "C" 0 '(999) (bitmap/file "picture/147.png") '("巨人の胸の印" 177 173))) ;
(define P148 (pages 148 "HPAC" 148 '(1481) (bitmap/file "picture/148.png") '(0 2)))
(define P1481 (pages 1481 "G" 1481 '(079 134) (bitmap/file "picture/148.png") '(("P148の鍵" . 41) ("P148の鍵" . 35))))
(define P149 (pages 149 "N" 0 '(126) (bitmap/file "picture/149.png") 0))
(define P150 (pages 150 "N" 0 '(129 142 122) (bitmap/file "picture/150.png") 0))
(define P151 (pages 151 "G" 151 '(156) (bitmap/file "picture/151.png") '("ブラックジャック" . 1)))

(define P152 (pages 152 "B" 152 '(157 124) (bitmap/file "picture/152.png") 3))

(define P153 (pages 153 "HPAC" 153 '(1531) (bitmap/file "picture/153.png") '(0 1 "ブラックジャック" 1)))
(define P1531 (pages 1531 "SAI153" 0 '(1581 1582 1583) (bitmap/file "picture/153.png") 0))
(define P154 (pages 154 "N" 0 '(180) (bitmap/file "picture/154.png") 0))
(define P155 (pages 155 "N" 0 '(109) (bitmap/file "picture/155.png") 0))
(define P156 (pages 156 "N" 0 '(131) (bitmap/file "picture/156.png") 0))
(define P157 (pages 157 "HPAC" 157 '(083) (bitmap/file "picture/157.png") '(0 1)))
(define P1581 (pages 1581 "B" 1581 '(151 118) (bitmap/file "picture/158.png") 3))
(define P1582 (pages 1582 "B" 1582 '(151 118) (bitmap/file "picture/158.png") 3))
(define P1583 (pages 1583 "B" 1583 '(151 118) (bitmap/file "picture/158.png") 3))
(define P159 (pages 159 "END" 0 '(999) (bitmap/file "picture/159.png") 0))
(define P160 (pages 160 "N" 0 '(117) (bitmap/file "picture/160.png") 0))
(define P161 (pages 161 "N" 0 '(152) (bitmap/file "picture/161.png") 0))
(define P162 (pages 162 "N" 0 '(154) (bitmap/file "picture/162.png") 0))
(define P163 (pages 163 "B" 163 '(148 155) (bitmap/file "picture/163.png") 1))
(define P164 (pages 164 "N" 0 '(184) (bitmap/file "picture/164.png") 0))
(define P165 (pages 165 "SAI007" 0 '(194 203) (bitmap/file "picture/165.png") '("Ac" 194 203)))
(define P166 (pages 166 "N" 0 '(182) (bitmap/file "picture/166.png") 0))
(define P167 (pages 167 "N" 0 '(126) (bitmap/file "picture/167.png") 0))
(define P168 (pages 168 "HPAC" 168 '(234) (bitmap/file "picture/168.png") '(0 0 "火薬ビン" -1)))
(define P169 (pages 169 "HPAC" 169 '(1691) (bitmap/file "picture/169.png") '(-1 0)))
(define P1691 (pages 1691 "SAI007" 0 '(999) (bitmap/file "picture/169.png") '("Ac" 229 205)))
(define P170 (pages 170 "HPAC" 170 '(199) (bitmap/file "picture/170.png") '(-2 0)))
(define P171 (pages 171 "N" 0 '(147) (bitmap/file "picture/171.png") 0))
(define P172 (pages 172 "N" 0 '(141 176) (bitmap/file "picture/172.png") 0))
(define P173 (pages 173 "N" 0 '(140) (bitmap/file "picture/173.png") 0))
(define P174 (pages 174 "SAI007" 0 '(999) (bitmap/file "picture/174.png") '("Ac" 194 203)))
(define P175 (pages 175 "HPAC" 175 '(212) (bitmap/file "picture/175.png") '(-1 0)))
(define P176 (pages 176 "N" 0 '(162) (bitmap/file "picture/176.png") 0))
(define P177 (pages 177 "N" 0 '(140) (bitmap/file "picture/177.png") 0))
(define P178 (pages 178 "N" 0 '(146) (bitmap/file "picture/178.png") 0))
(define P179 (pages 179 "N" 0 '(198) (bitmap/file "picture/179.png") 0))
(define P180 (pages 180 "N" 0 '(192) (bitmap/file "picture/180.png") 0))
(define P181 (pages 181 "N" 0 '(223 175) (bitmap/file "picture/181.png") 0))
(define P182 (pages 182 "N" 0 '(178) (bitmap/file "picture/182.png") 0))
(define P183 (pages 183 "HPAC" 183 '(252) (bitmap/file "picture/183.png") '(-1 0 "ランチャーの弾" -1)))
(define P184 (pages 184 "N" 0 '(206) (bitmap/file "picture/184.png") 0))
(define P185 (pages 185 "HPAC" 185 '(191) (bitmap/file "picture/185.png") '(-2 0)))
(define P186 (pages 186 "N" 0 '(172) (bitmap/file "picture/186.png") 0))
(define P187 (pages 187 "HPAC" 187 '(178) (bitmap/file "picture/187.png") '(0 2)))
(define P188 (pages 188 "C" 0 '(999) (bitmap/file "picture/188.png") '("火薬ビン" 1671 214)))
(define P1881 (pages 1881 "YESNO" 0 '(999) (bitmap/file "picture/188.png") '("火薬ビンを使うか？[y]es or [n]o" 168 214)))
(define P189 (pages 189 "SAI007" 0 '(999) (bitmap/file "picture/189.png") '("Ac" 185 196)))
(define P190 (pages 190 "N" 0 '(209 221) (bitmap/file "picture/190.png") 0))


(define P191 (pages 191 "N" 0 '(216 233) (bitmap/file "picture/191.png") 0))
(define P192 (pages 192 "N" 0 '(170) (bitmap/file "picture/192.png") 0))
(define P193 (pages 193 "N" 0 '(159 179) (bitmap/file "picture/193.png") 0))
(define P194 (pages 194 "HPAC" 194 '(213) (bitmap/file "picture/194.png") '(0 2 "ランチャーの弾" 3)))
(define P195 (pages 195 "N" 0 '(181) (bitmap/file "picture/195.png") 0))
(define P196 (pages 196 "YESNO" 0 '(999) (bitmap/file "picture/196.png") '("再挑戦するか？[y]es or [n]o" 185 9999)))
(define P197 (pages 197 "N" 0 '(217 183 207 225) (bitmap/file "picture/197.png") 0))
(define P198 (pages 198 "N" 0 '(133) (bitmap/file "picture/198.png") 0))
(define P199 (pages 199 "N" 0 '(164) (bitmap/file "picture/199.png") 0))
(define P200 (pages 200 "N" 0 '(240) (bitmap/file "picture/200.png") 0))
(define P201 (pages 201 "HPAC" 201 '(232) (bitmap/file "picture/201.png") '(-2 0 "ランチャーの弾" -1)))
(define P202 (pages 202 "N" 0 '(190) (bitmap/file "picture/202.png") 0))
(define P203 (pages 203 "HPAC" 203 '(174) (bitmap/file "picture/203.png") '(-1 0)))
(define P204 (pages 204 "N" 0 '(253 208) (bitmap/file "picture/204.png") 0))
(define P205 (pages 205 "HPAC" 205 '(165) (bitmap/file "picture/205.png") '(0 -1)))
(define P206 (pages 206 "N" 0 '(188) (bitmap/file "picture/206.png") 0))
(define P207 (pages 207 "N" 0 '(219) (bitmap/file "picture/207.png") 0))

;何度も来るところなので判定消失語は強制的にクローンページへ
(define P208 (pages 208 "YESNO" 208 '(2081) (bitmap/file "picture/208.png") '("水を飲んでみるか？[y]es or [n]o" 242 2081)))
(define P2081 (pages 2081 "C" 0 '(999) (bitmap/file "picture/208.png") '("緑色の棒" 2082 2083)))
;SC関数で弾がない場合は行ったところのみ表示、弾があれば全部表示鍵があれば表示する
(define P2082 (pages 2082 "SC" 0 '(248 緑色の棒＋208 251 256) (bitmap/file "picture/208.png") '("ランチャーの弾")))
(define P2083 (pages 2083 "SC" 0 '(248 251 256) (bitmap/file "picture/208.png") '("ランチャーの弾")))

(define P209 (pages 209 "N" 0 '(169 221) (bitmap/file "picture/209.png") 0))
(define P210 (pages 210 "N" 0 '(260) (bitmap/file "picture/210.png") 0))
(define P211 (pages 211 "N" 0 '(252) (bitmap/file "picture/211.png") 0))
(define P212 (pages 212 "N" 0 '(207) (bitmap/file "picture/212.png") 0))
(define P213 (pages 213 "N" 0 '(195) (bitmap/file "picture/213.png") 0))
(define P214 (pages 214 "N" 0 '(202 190) (bitmap/file "picture/214.png") 0))
(define P215 (pages 215 "N" 0 '(204) (bitmap/file "picture/215.png") 0))
(define P216 (pages 216 "N" 0 '(225) (bitmap/file "picture/216.png") 0))
(define P217 (pages 217 "HPAC" 217 '(241) (bitmap/file "picture/217.png") '(-1 0 "ランチャーの弾" -1)))
(define P218 (pages 218 "N" 0 '(211 248) (bitmap/file "picture/218.png") 0))
(define P219 (pages 219 "N" 0 '(233) (bitmap/file "picture/219.png") 0))

;このページに来るということは2581はもうイベント起こさなくて良いと
(define P220 (pages 220 "N" 2581 '(259) (bitmap/file "picture/220.png") 0))

(define P221 (pages 221 "HPAC" 221 '(165) (bitmap/file "picture/221.png") '(-1 0)))

;248のイベント無効化
(define P222 (pages 222 "HPAC" 248 '(257) (bitmap/file "picture/222.png") '(0 0 "ランチャーの弾" -1)))

(define P223 (pages 223 "N" 0 '(212) (bitmap/file "picture/223.png") 0))
(define P224 (pages 224 "N" 0 '(245) (bitmap/file "picture/224.png") 0))
(define P225 (pages 225 "N" 0 '(197) (bitmap/file "picture/225.png") 0))
;241のチェック用Track追加
(define P226 (pages 226 "N" 226 '(197) (bitmap/file "picture/226.png") 0))
(define P227 (pages 227 "N" 0 '(240) (bitmap/file "picture/227.png") 0))
(define P228 (pages 228 "N" 0 '(190) (bitmap/file "picture/228.png") 0))
(define P229 (pages 229 "HPAC" 229 '(165) (bitmap/file "picture/229.png") '(0 1)))
(define P230 (pages 230 "N" 0 '(249) (bitmap/file "picture/230.png") 0))
(define P231 (pages 231 "SAI007" 0 '(999) (bitmap/file "picture/231.png") '("Ac" 242 236)))
(define P232 (pages 232 "N" 0 '(197) (bitmap/file "picture/232.png") 0))
(define P233 (pages 233 "N" 0 '(224) (bitmap/file "picture/233.png") 0))
(define P234 (pages 234 "N" 0 '(228) (bitmap/file "picture/234.png") 0))
(define P235 (pages 235 "END" 0 '(999) (bitmap/file "picture/235.png") 0))
(define P236 (pages 236 "B" 236 '(239 227) (bitmap/file "picture/236.png") 2))
(define P237 (pages 237 "N" 0 '(243) (bitmap/file "picture/237.png") 0))
(define P238 (pages 238 "N" 0 '(230) (bitmap/file "picture/238.png") 0))
(define P239 (pages 239 "N" 0 '(247) (bitmap/file "picture/239.png") 0))
(define P240 (pages 240 "N" 0 '(237) (bitmap/file "picture/240.png") 0))

;ランチャーの弾関係 ここだけ特殊な処理が必要
;(define P241 (pages 241 "SC" 0 '(254 226 222) (bitmap/file "picture/241.png") '("ランチャーの弾")))
(define P241 (pages 241 "SC" 0 '(222) (bitmap/file "picture/241.png") '("ランチャーの弾" . (254 226))))
  
(define P242 (pages 242 "HPAC" 242 '(208) (bitmap/file "picture/242.png") '(0 -1)))
(define P243 (pages 243 "N" 0 '(260) (bitmap/file "picture/243.png") 0))
(define P244 (pages 244 "N" 0 '(238) (bitmap/file "picture/244.png") 0))

;ここは強制的にランチャーを使うのでこの場で無効化する
(define P245 (pages 245 "N" 245 '(225) (bitmap/file "picture/245.png") '(-1 0 "ランチャーの弾" -1)))

;ランチャーの弾があるなしで分岐。二度目に来るときには自由に行けるようにしないと・・Ppageを使う
(define P246 (pages 246 "C" 0 '(204 258) (bitmap/file "picture/246.png") '("ランチャーの弾" 2461 2462)))
(define P2461 (pages 2461 "N" 0 '(204 258) (bitmap/file "picture/246.png") 0))
(define P2462 (pages 2462 "N" 0 '(204) (bitmap/file "picture/246.png") 0))

(define P247 (pages 247 "N" 0 '(244) (bitmap/file "picture/247.png") 0))

;222へ行けたらランチャーの弾を減らして248をPpageに追加
(define P248 (pages 248 "C" 0 '(208 218 222) (bitmap/file "picture/248.png") '("ランチャーの弾" 2481 2482)))
(define P2481 (pages 2481 "N" 0 '(208 218 222) (bitmap/file "picture/247.png") 0))
(define P2482 (pages 2482 "N" 0 '(208 218) (bitmap/file "picture/247.png") 0))

(define P249 (pages 249 "N" 0 '(210) (bitmap/file "picture/249.png") 0))
(define P250 (pages 250 "N" 0 '(236 200) (bitmap/file "picture/250.png") 0))
(define P251 (pages 251 "HPAC" 251 '(204) (bitmap/file "picture/251.png") '(0 0 "ランチャーの弾" -1)))
(define P252 (pages 252 "N" 0 '(218 226) (bitmap/file "picture/252.png") 0))
;二度目は強制的に・・という場合にSAIDO。最初はArgを使って選択
(define P253 (pages 253 "SAIDO" 0 '(246) (bitmap/file "picture/253.png") '(220 246)))

;254の登録（241のリスト判定に使うため)
(define P254 (pages 254 "HPAC" 254 '(208) (bitmap/file "picture/254.png") '(0 0 "ランチャーの弾" -1)))

(define P255 (pages 255 "NO" 0 '(このページへ飛んでくるページ) (bitmap/file "picture/255.png") 0))
(define P256 (pages 256 "HPAC" 256 '(241) (bitmap/file "picture/256.png") 0))
(define P257 (pages 257 "N" 222 '(248) (bitmap/file "picture/257.png") 0))

;この条件をクリアしたら246はOKとして登録する
(define P258 (pages 258 "HPAC" 246 '(2581) (bitmap/file "picture/258.png") '(0 0 "ランチャーの弾" -1)))
(define P2581 (pages 2581 "C" 258 '(220) (bitmap/file "picture/258.png") '("ランチャーの弾" 220 2582)))
(define P2582 (pages 2582 "C" 0 '(999) (bitmap/file "picture/258.png") '("火薬" 220 9999)))

(define P259 (pages 259 "B" 259 '(250 235) (bitmap/file "picture/259.png") 2))
(define P260 (pages 260 "EP" 0 '(999) (bitmap/file "picture/260.png") 0))
(define P9999 (pages 9999 "END" 0 '(999) "" 0)) ;BadEnd用ページ



(define *page-list* (list P001 P002 P003 P004 P005 P006 P007 P008 P009 P010 P011 P012 P013 P014 P015 P016 P017 P018 P018001 P019 P020
                          P021 P022 P023 P024 P025 P026 P027 P028 P029 P029001 P029002 P030 P031 P032 P033 P034 P035 P036 P037 P038 P039 P040
                          P041 P042 P043 P044 P045 P046 P047 P048 P049 P050 P051 P052 P053 P054 P055 P056 P057 P058 P059 P060
                          P061 P062 P063 P064 P065 P066 P067 P068 P069 P070 P071 P072 P073 P074 P075 P076 P077 P078 P0781 P079 P080
                          P081 P082 P083 P084 P085 P086 P087 P087001 P088 P089 P090 P091 P092 P093 P094 P095 P096 P097 P098 P099 P100
                          P101 P102 P103 P104 P105 P106 P107 P108 P109 P110 P111 P112 P113 P114 P115 P116 P117 P118 P119 P120
                          P121 P122 P123 P124 P125 P126 P127 P128 P129 P130 P131 P132 P133 P134 P135 P136 P137 P138 P139 P1391 P140
                          P141 P142 P143 P144 P145 P146 P147 P148 P1481 P149 P150 P151 P152 P153 P1531 P154 P155 P156 P157 P1581 P1582 P1583 P159 P160
                          P161 P162 P163 P164 P165 P166 P167 P168 P169 P1691 P170 P171 P172 P173 P174 P175 P176 P177 P178 P179 P180
                          P181 P182 P183 P184 P185 P186 P187 P188 P1881 P189 P190 P191 P192 P193 P194 P195 P196 P197 P198 P199 P200
                          P201 P202 P203 P204 P205 P206 P207 P208 P2081 P2082 P2083 P209 P210 P211 P212 P213 P214 P215 P216 P217 P218 P219 P220
                          P221 P222 P223 P224 P225 P226 P227 P228 P229 P230 P231 P232 P233 P234 P235 P236 P237 P238 P239 P240
                          P241 P242 P243 P244 P245 P246 P2461 P2462 P247 P248 P2481 P2482 P249 P250 P251 P252 P253 P254 P255 P256 P257 P258 P2581 P2582
                          P259 P260 P9999))


;(define P151 (pages 151 "G" 0 '(156) "" '(("ブラックジャック" . 1))))

(define page-list `(,P151))



















