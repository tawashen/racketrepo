#lang racket

(require srfi/1)
(require srfi/13)
(require racket/struct)
(require racket/match)

(require "util.rkt")
(require "message.rkt")
(require "monster.rkt")
(require "item.rkt")
(require "page.rkt")


;(start-vlc "picture/battle1.mp4")

(define-syntax status-check
  (syntax-rules ()
    ((_ `((pred1 b1 ...) ...))
     (cond (pred1 (begin b1 ...)) ...))))

(define test `(((> 10 5) "T") ((> 10 3) "G")))
;(status-check (((> 10 5) "T") ((> 10 3) "G")))
(status-check test)
