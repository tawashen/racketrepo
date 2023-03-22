#lang racket


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

 


  




