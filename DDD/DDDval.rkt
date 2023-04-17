#lang racket
 
(require 2htdp/universe 2htdp/image lang/posn)
(require describe)
(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)
(require "DDDstruct.rkt")
(provide (all-defined-out))

;キャラクターパーティ変数
(define *chara-list* '())
(define *member-list* '())

;画面表示関連;;;;;;;;;;;;;;;;;;;;;;;;

(define *images* `(,(bitmap/file "picture/01.png") ,(bitmap/file "picture/02.png") ,(bitmap/file "picture/03.png") ,(bitmap/file "picture/04.png")))
(define *width* 620)
(define *height* 558)
(define *step* 62)
(define *image-posns*
  (append-map (lambda (y)
                (map (lambda (x)
                      (make-posn x y))
                        (range (/ *step* 2) *width* *step*)))
                        (range (/ *step* 2) *height* *step*)))

(define *map-data* '((1 1 1 1 1 1 1 1 1 1)
                        (1 0 0 0 0 0 0 0 0 1)
                        (1 0 0 0 0 0 0 0 0 1)
                        (1 0 0 0 0 0 0 0 0 1)
                        (1 0 0 0 0 0 0 0 0 1)
                        (1 0 0 0 0 0 0 0 0 1)
                        (1 0 0 0 0 0 0 0 0 1)
                        (1 0 0 0 0 0 0 0 0 1)
                        (1 1 1 1 1 1 1 1 1 1)))

(define *dir-posns* ;*map-data*に対応するdirのリスト
  (append-map (lambda (y)
                (map (lambda (x)
                      (cons x y))
                        (range  0 10)))
                        (range 0 9)))

(define *map-posn* ;*map-data*の1の部分のdirだけのリスト
  (foldr (lambda (x y z) (if (= x 1) (cons y z) z)) '() (flatten *map-data*) *dir-posns* ))

#|
(define *bgx* 310)
(define *bgy* 279)

(define *background*
 (place-image (place-images (map (lambda (i)
           (list-ref *images* (if (= i 1) i 0)))
         (apply append *map-data*)) ;map-dataを平坦化 (11111111111000000001...)
        *image-posns*
        (empty-scene *width* *height*)) *bgx* *bgy* ;310 279
                             (place-image/align (rectangle 192 160 "outline" "white") 624 552 "left" "bottom"
                                        (rectangle 820 558 "solid" "black"))))
|#

(define *d-pairs* ;(0 . 0) ~ (9 . 6)
 (append-map (lambda (y)
        (map (lambda (x)
           (cons x y))
           (range 0 (length (list-ref *map-data* 0))))) ;x 0-9
           (range 0 (length *map-data*)))) ;y 0-8

(define *d-pairs->posns-table* ;hash形式で変換するテーブル (0 . 0) (posn 31 31)
 (make-hash (map (lambda (x y) ;連想リストからHash作成
          (cons x y)) ;連想リストを作る
         *d-pairs* *image-posns*)))

(define *posns->d-pairs-table*
 (make-hash (map (lambda (x y)
          (cons x y))
         *image-posns* *d-pairs*)))