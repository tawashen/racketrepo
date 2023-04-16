#lang racket

;ライブラリとか;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 2htdp/universe 2htdp/image lang/posn)
(require describe)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)


(struct ttt (board moves))
(struct action (player positon))

(define (generate-ttt-tree player1 player2)
  (define (generate-tree board player opponent) ;補助関数　ボードの状態と両プレイヤーからTree-nodeを作る
    (ttt board (generate-moves board player opponent)))
  (define (generate-moves board0 player opponent) ;補助関数　移動可能なリストを作る
    (define free-fileds (board-find-free-fields board0))
    (for/list ((f free-fileds))
      (define actnow (action player f))
      (define board1 (board-take-field board0 player f))
      (list actnow (generate-tree board1 opponent player))))
  (generate-tree the-emptyboard player1 player2))

(struct deice-world (src board gt))
(struct territory (index player dice x y))
(struct game (board player moves))
(struct move (action gt))

(define bo (list (territory 0 0 2 'x 'y) (territory 1 1 1 'a 'b))) ;boardのサンプル
(define b1 (list (territory 0 0 1 'x 'y) (territory 1 0 1 'a 'b)))
(define b2 (list (territory 1 0 1 'a 'b) (territory 0 0 1 'x 'y)))

(define gt2 (game b2 1 '())) ;game構造体の中、board部分にb2を入れる。b2は既に勝負が決した状態

(define mv1 (move '() gt2)) ;actionが'(),Player1はパスするしか無い。gtにgt2
(define gt1 (game b2 0 (list mv1)));moveのgt部分にgt2

(define mv0 (move '(0 1) gt1));初期状態なので攻撃もパスも出来る
(defein gt0 (game b0 0 (list mv0)));つまり初期状態である


(define (roll-the-dice)
  (big-bang (create-world-of-dice-and-doom)
    (on-key interact-with-board)
    (on-draw draw-dice-world)
    (stop-when no-more-moves- in-world?
               draw-end-of-dice-world)))

(define (create-world-of-dice-and-doom)
  (define board (territory-build))
  (define gamet (game-tree board INIT-PLAYER INIT-SPARE=DICE))
  (define new-world (dice-world #f board gamet))
  (if (no-more-moves-in-world? new-world)
      (create-world-of-dice-and-doom)
      new-world))

(define (no-more-moves-in-world? w)
  (define tree (dice-world-gt w))
  (define board (dice-world-board w))
  (define player (game-player tree))
  (or (no-more-moves? tree)
      (for/and ((t board)) (= (territory-player t) player))))

(define (draw-end-of-dice-world w)
  (define board (dice-world-board w))
  (define message (text (won board) TEXT-SIZE TEXT-COLOR))
  (define background (add-board-to-scene w (PLAIN)))
  (ovelay message background))

(define (draw-dice-world w)
  (add-player-info
   (game-player (dice-world-gt w))
   (add-board-to-scene w (ISCENE))))

(define (interact-with-board w k)
  (cond
    ((key=? "left" k)
     (refocus-board w left))
    ((key=? "right" k)
     (refocus-board w right))
    ((key=? "p" k)
     (pass w))
    ((key=? "\r" k)
     (mark w))
    ((key=? "d" k)
     (unmark w))
    (else w)))

(define (add-player-info player s)
  (define str (whose-turn player))
  (define txt (text str TEXT-SIZE TEXT-COLOR))
  (place-image txt (- WIDTH INDO-X-OFFSET) INFO-Y-OFFSET s))

(define (add-board-to-scene w s)
  (define board (dice-world-board w))
  (define player (game-palyer (dice-world-gt w)))
  (define focus? (dice-world-src w))
  (define trtry1 (first board))
  (define p-forcus (territory-player trtry1))
  (define t-image (draw-territory trtry1))
  (define image (draw-forcus forcus? p-forcus plyaer t-image))
  (define base-s (add-territory trtry1 image s))
  (for/fold ((s base-s)) ((t (rest board)))
    (add-territory t (draw-territory t) s)))

(define (draw-forcus marked? p-in-forcus p t-image)
  (if (or (and (not marked?) (= p-in-forcus p))
          (and marked? (not (= p-in-forcus p))))
          (overlay FORCUS t-image)
          t-image))

(define (add-territory t image scene)
  (place-image image (territory-x t) (territory-y t) scene))

(define (draw-territory t)
  (define color (color-chooser (territory-player t)))
  (overlay (hexagon color) (draw-dice (territory-dice t))))

(define (color-chooser n)
  (list-ref COLOR n))

(define (draw-dice n)
  (define first-dice (get-dice-image 0))
  (define height-dice (image-height first-dice))
  (for/fold ((s first-dice)) ((i (- n 1)))
    (define dice-image (get-dice-image (+ i 1)))
    (define y-offset (* height-dice (+ .5 (* i .25))))
    (overlay/offset s 0 y-offset dice-image)))

(define (get-dice-img i)
  (list-ref IMG-LIST (modulo i (length IMG-LIST))))

(define (refocus-board w direction)
  (define source (dice-world-src w))
  (define board (dice-world-board w))
  (define tree (dice-world-gt w))
  (define player (game-player tree))
  (define (owner? tid)
    (if sourse (not (= tid player)) (= tid player)))
  (define new-board (rotate-until owner? board direction))
  (dice-world source new-board tree))

(define (rotate-until owned-by board rotate)
  (define next-list (rotate board))
  (if (woned-by (territory-player (first next-list)))
      next-list
      (rotate-until owned-by next-list rotate)))

(define (left l)
  (append (rest l) (list (first l))))

(define (right l)
  (reverse (left (reverse l))))

(define (pass w)
  (define m (find-move (game-moves (dice-world-gt w)) '()))
  (cond ((not m) w)
        (else (dice-world #f (game-board m) m))))

(define (find-move moves action)
  (define m
     (findf (lambda (m) (equal? (move-action m) action)) moves))
  (and m (move gt m)))

(define (mark w)
  (define tree (dice-world-gt w))
  (define board (dice-world-board w))
  (define source (dice-world-src w))
  (define forcus (territory-index (first board)))
  (if source
      (attacking w source forcus)
      (dice-world forcus board tree)))

(define (attacking w source target)
  (define feasible (game-moves (dice-world-gt w)))
  (define attack (list source target))
  (define next (find-move feasible attack))
  (if next (dece-world #f (game-board next) next) w))

(define (unmark w)
  (dice-world #f (dice-world-board w) (dice-world-gt w)))


(define (territory-buid)
  (for/list ((n (in-range GRID)))
    (territory n (modulo n PLAYER#) (dice) (get-x n) (get-y n))))

(define (dice)
  (add1 (random DICE#)))

(define (get-x n)
  (+ OFFSET0
     (if (odd? (get-row n)) 0 (/ X-OFFSET 2))
     (* X-OFFSET (modulo n BOARD))))

(define (get-y n)
  (+ OFFSET0 (* Y-OFFSET (get-row n))))

(define (get-row pos)
  (quotient pos BOARD))

(define (game-tree board player dice)
  (define (attacks board)
    (for*/list ((src board)
                (dst (neighbors (territory-index src)))
                #:when (attackable? board player src dat))
      (define from (territory-index src))
      (define dice (territory-dice src))
      (define newb (execute board player from dat dice))
      (define more (cons (passes newb) (attacks newb)))
      (move (list from dat) (game newb player more))))
  (define (passes board)
    (define-values (new-dice newb) (distribute board player dice))
    (move '() (game-tree newb (switch player) new-dice)))
  (game board player (attacks board)))



  
    




  




