#lang racket


(require 2htdp/universe 2htdp/image lang/posn)
;(require srfi/1)
;(require srfi/13)
(require racket/struct)
(require racket/match)
(require "4king-print.rkt")
(require "4king-util.rkt")
(require "4king-data.rkt")
(require "4king-mes.rkt")





(define players '(2 5 7 10))
(define phase-list (circular '(0 1 2 3)))

;整形後のPlayers配置マップを束縛（初期値）
(define players-map (split-list (map align-string (map (lambda (x) (number->string x)) (put-player *player-zero* 1 players))))) 


;テスト用インスタンス類

(define world (WORLD (list SJ DJ HJ CJ) string-map players-map phase-list players #f))




;ここにしか置けない関数

(define (go-direct direct w) ;新たなwを返す予定 COORDとplayer-mapを更新する
  (let ((current ;PLAYER構造体から座標(INT)を束縛
                  (list-ref (WORLD-COORD w) (car (WORLD-PHASE w))))) ;現在のPLYAER構造体を返す
    (cond ((and (string=? direct "r") (ue? current)) (main-eval (change-coord direct w -7)))
          ((and (string=? direct "d") (hidari? current)) (main-eval (change-coord direct w -1)))
          ((and (string=? direct "c") (sita? current)) (main-eval (change-coord direct w 7)))
          ((and (string=? direct "f") (migi? current)) (main-eval (change-coord direct w 1)))
          (else (main-read w)))))



                                                 
;;;;;;;;;;;;;;;;;アイテムテーブル
(hash-set! jack-table 'item-sord sord)

;;;;;;;;;;;;;;;;;アイテム属性テーブル 装備コマンドの時参照する感じ？



;;;;;;;;;;;;;;;;;イベントテーブル
(hash-set! jack-table 'direct go-direct)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;バトル部分
;(define (battle-print w))
;(define (battle-read w))
;(define (battle-eval w))
;(define (battl-loop w))
;(define battle (lambda (x y) ()))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;メイン部分
;メインPRINT マップ表示                             
;(define (main-map-print w)

  ;(display (hash-ref jack-table (CARD-MES (PLAYER-COORD (WORLD-PLAYERS w))))))
;メインREAD マップの移動入力
(define (main-read w)
  (display-map (WORLD-SMAP w) (WORLD-PMAP w) '())
  (newline)
  (display (format (hash-ref jack-table 'mes-read) (list-ref (WORLD-PLAYERS w) (car (WORLD-PHASE w)))))
  (let ((direct (read-line)))
    (cond ((member direct  '("r" "d" "c" "f")) ((hash-ref jack-table 'direct) direct w))
          (else (main-read w)))))
  
;メインEVAL　移動後イベント発生
(define (main-eval w)
  (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) w))
  (display-map SMAP PMAP '()) (newline)
  (let ((c-card (list-ref *map* (list-ref (WORLD-COORD w) (car (WORLD-PHASE w))))))
  (if (CARD-ON c-card) ;CARD-ONが#fなら何も起きないので次のプレイヤーへ
      ((hash-ref jack-table (CARD-KIND c-card)));#tならCARD-KINDを実行
      (main-loop (WORLD PLAYERS SMAP PMAP PHASE COORD WIN)))))) ;main-loopで勝利条件の判定

  
;メインLOOP　次のプレイヤーか自身の次ターン
;(define (main-loop w))



;select 戦うかどうか選択のクロージャ 引数はworld
(define select (lambda (x)
                 (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) x))
                   (let ((c-player (list-ref PLAYERS (list-ref PHASE 0)));今のPLAYERインスタンス
                         (c-card (list-ref COORD (list-ref PHASE 0))));今のCARDインスタンス
                     (display "受けるか?") (newline)
                     (let ((answer (read-line)))
                       (if (string=? "y" answer)
                           (if (and (CARD-FIRST c-card) ;CARD-FIRSTの真偽
                                    (satisfy-item? (cadr (CARD-FIRST c-card)) (PLAYER-ITEMS c-player)));必要アイテムを持っている？
                               ((hash-ref jack-table (car (CARD-FIRST c-card))) x) ;真ならCARD-FIRSTのキーで発動
                               ((hash-ref jack-table 'BATTLE) x)) ;#fならすぐにバトル開始
                           (eval-read (WORLD PLAYERS SMAP PMAP (circular PHASE) COORD)) ;受けない場合次へ
                           ))))))

;CARDが要請するアイテムをPLAYERが全て持っているか？をチェックする関数
(define (satisfy-item? card-item player-item)
  (if (null? card-item)
      #t
      (if (member (car card-item player-item))
          (satisfy? (cdr card-item) player-item)
          #f)))

(hash-set! jack-table 'SELECT select)

;運試しするか？関数
(define luck-try (lambda (x)
                  (display "運試しするか？") (newline)
                  (let ((answer (read-line)))
                    (if (string=? "y" answer)
                        ((hash-ref jack-table 'LUCK) x)
                        ((hash-ref jack-table 'BATTLE) x)))))

(hash-set! jack-table 'LUCK-TRY luck-try)

           
;luck 運試し
(define luck (lambda (x)
                (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) x))
                  (match-let (((CARD NAME KIND FIRST SECOND MES ENEMY ITEM GOLD ON FLIP);現在のカード
                               (list-ref *map* (list-ref COORD (list-ref PHASE 0))))) 
                   (let ((c-player (list-ref PLAYERS (list-ref PHASE 0))));今のPLAYERインスタンス
                     (if (>= (car (PLAYER-SKILLP c-player)) (dice));運試し実行
                         ((hash-ref jack-table 'BATTLE) (WORLD PLAYERS SMAP PMAP PHASE COORD #t))
                         ;↑#tならCARDの成功効果を適用してBATTLEへ。実際はBATTLEで処理、最後の#tがBATTLEでの判定用
                         (main-read (WORLD (list-set PLAYERS
                                           (change-status PLAYERS PHASE (list-ref (CARD-FIRST c-card) 3)))
                                           SMAP PMAP (circular PHASE)
                                           (force-coord COORD PHASE (list-ref (list-ref (CARD-FIRST) 3) 3) #f)))
                         ;↑#fならCARDの失敗処理を施したデータで構造体を作り直して次のプレイヤーへ
                         ))))))

(hash-set! jack-table 'LUCK luck)

;PLYAERのステータスを変更する関数
(define (change-status PLAYERS PHASE arg) ; ->PLAYERS
  (match-let (((PLAYER NAME SKILLP HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) (list-ref PLAYERS PHASE)))
   (let ((new-player-status
    (case (list-ref arg 1)
      ((HITP) (PLAYER NAME SKILLP
                      (cons (+ (car HITP) (list-ref arg 2)) (cdr HITP))
                      LUCKP EQUIP GOLD ITEMS SPECIAL WIN)))))
     (list-set PLAYERS PHASE new-player-status))))
  

;座標を無理やり変更する関数（CARD-FIRSTの失敗時の判定の結果）
(define (force-coord COORD PHASE int)
  (list-set COORD (car PHASE) int))

;BATTLE関数
(define battle-read (lambda (x)
                 (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) x))
                  (match-let (((CARD NAME KIND FIRST SECOND MES ENEMY ITEM GOLD ON FLIP) ;現在のカード
                                                              (list-ref *map* (list-ref COORD (list-ref PHASE 0)))))
                    (match-let (((ENEMY ENAME ESKILLP EHITP) ENEMY));今のENEMY
                   (let* ((c-player (list-ref PLAYERS (list-ref PHASE 0)));今のPLAYERインスタンス
                         (c-enemy (if WIN;運試しに勝ったか？
                                      (case (list-ref (list-ref FIRST 2) 1);勝った場合
                                        ((SKILLP) (ENEMY ENAME (+ ESKILLP (list-ref (list-ref FIRST 2) 2)))))
                                      ENEMY)));負けてたらそのまま
                     (display (format "~aとの戦闘だ！" ENAME)) (newline)
                     (battle-read2 c-player c-enemy x)
                     ))))))

(define (input-command player enemy numlist)
  (display (format "どれと戦う?[1]~[~a]~%" (+ 1 (length enemy)))) 
  (cond ((null? player) (reverse numlist))
        (else
      (let ((answer (string->number (read-line))))
        (cond  ((or ((compose not number?) answer) (> answer (length enemy)) (> 1 answer))
                (input-command player enemy numlist))
               (else (input-command (cdr player) enemy (cons answer numlist))))))))

(define (battle-read2 player enemy world)
          (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) world))
           (match-let (((CARD NAME KIND FIRST SECOND MES ENEMY ITEM GOLD ON FLIP) ;現在のカード
                                                              (list-ref *map* (list-ref COORD (list-ref PHASE 0)))))
  (when (null? enemy) (battl-win player enemy world))
  (when CARD-SECOND (display "降参する?[y/n]") (newline)) ;降参オプション有効なとき表示
             (let ((kousan-answer (read-line)))
               (cond ((string=? "y" kousan-answer) ((hash-ref jack-table 'SURRENDER) SECOND world)) ;戦闘中に降参する 未実装
                    (else
                      (for-each display (map (match-lambda (`(,name ,hit)
                                              (format "[~a HIT:~a]~%" name hit)))
                                                 (map (lambda (x) `(,(ENEMY-NAME x) ,(ENEMY-HITP x))) enemy)))  
                      (for-each display (map (match-lambda (`(,name ,hit ,skill)
                                              (format "[~a HIT:~a SKILL:~a]~%" name hit skill)))
                                                 (map (lambda (x) `(,(PLAYER-NAME x) ,(PLAYER-HITP x))) player)))
  (let ((command-list (input-command player enemy '())))
  (battle-eval player enemy world command-list))))))))


(define (battle-eval player enemy world command-list)
  (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) world))
     (match-let (((CARD C-NAME KIND FIRST SECOND MES ENEMY C-ITEM C-GOLD ON FLIP) ;現在のカード
                                                              (list-ref *map* (list-ref COORD (list-ref PHASE 0)))))
       (match-let (((PLAYER P-NAME P-SKILLP P-HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) (car player)))
         (match-let (((ENEMY E-NAME E-SKILLP E-HITP) (car enemy)))

              


  
(define (battle-eval player enemy world command-list counter)
  (match-let (((WORLD PLAYERS SMAP PMAP PHASE COORD WIN) world))
     (match-let (((CARD C-NAME KIND FIRST SECOND MES ENEMY C-ITEM C-GOLD ON FLIP)
                  (list-ref *map* (list-ref COORD (list-ref PHASE 0)))))
       (match-let (((PLAYER P-NAME P-SKILLP P-HITP LUCKP EQUIP GOLD ITEMS SPECIAL WIN) (car player)))
         (match-let (((ENEMY E-NAME E-SKILLP E-HITP) (car enemy)))
		(let ((enemy-attack-list (random-list (length player)))) ;ex (1 1 2)
		(let loop ((player enemy command-list enemy-attack-list counter damage-list))
		(if (null? player) (values pdamage edamage) ;ex (-2 -1 0) (0 0 -1)
			(loop (cdr player) enemy (car command-list) enemy-attack-list (+ 1 counter)
		(cond ((= (car command-list) x)  (taiman (car player) (list-ref enemy (- (car command-list) 1))))
                      ;Playerの狙う相手が1（実際は−1してList-ref）で相手も1（実際は0）だった場合普通の対決、返り値はvalues ex (-1) (0)
		       ((and ((not equal) (car command-list) x) (= (+ 1 counter) x))
                            (bousen (car plyer) (list-ref enemy (- (car command-list) 1))))
                       ;Playerの狙う相手と違う相手がPlayerを攻撃した場合
		       ((and ((not equal) (car command-list) x) (= (car command-list) (+ 1　(list-index x))))
                            (ippouteki (car player) (list-ref enemy (list-index x))))
                       ;Playerだけが相手を狙った場合
                       (else (values 0 0)

(define (battle-zero car-player enemy car-command-list enemy-attack-list counter damage-list);counterは一つ上のLoopで1から増やす
  (cond ((null? enemy-attack-list) (reverse damage-list))
        ((= car-command-list (car enemy-attack-list))
         (battle-zero car-player (cdr enemy) car-command-list (cdr enemy-attack-list) counter
                      (cons (taiman car-player (car enemy)) damage-list)))
        ((and ((not equal) car-command-list (car enemy-attack-list)) (= counter (car enemy-attack-list)))
         (battle-zero car-player (cdr enemy) car-command-list (cdr enemy-attack-list) counter
         (cons (bousen car-player (car enemy)) damage-list)))
        ((and ((not equal) car-command-list (car enemy-attack-list)) ((not eqaul) counter (car enemy-attack-list)))
         (battle-zero car-player (cdr enemy) car-command-list (cdr enemy-attack-list) counter
         (cons (ippouteki car-player (car enemy)))))
        (else (vales 0 0))))
      



P(1 2 3)
E(1 1 2)

;LIST内の特定の要素の場所を返す
(define (list-index num lst count)
  (cond ((null? lst) #f)
         ((= num (car lst)) count)
         (else (list-index num (cdr lst) (+ 1 count)))))
      
;敵ごとにランダムで味方へ攻撃対象を決める（IndexのListで）
(define (random-list e-num p-num e-attack-list)
	(if (null? e-num) (reverse e-attack-list)
		(random-list (cdr e-num) p-num (cons (random (length p-num)) e-attack-lisT)))

 
 
                
                                      




 
#|
(define SA (CARD "SA" 'SELECT ;初期Eval用キー ここではselectクロージャを呼び出す
                 '(LUCK-TRY (numbing-medicine wine) (enemy SKILLP -3) (player HITP -2 24))
                 ;↑#tで続く()で必要アイテム、次の()で成功効果 最後の()で失敗効果最後の真偽はJOK行きかどうか
                 '(LUCKP -2) ;存在した場合は降服可能、BATTLEで参照してメニューを出す
                 'mes-s1 '(enemy-zakura) '(rune-blade) #f #t #t))
|#                  
                     
                     
               

;(main-print world)
(main-read world)









