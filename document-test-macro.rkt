#lang racket

(require describe)

(define-syntax varivariant
  (syntax-rules ()
    ((_ id) (if (number? id) 'number
                (if (symbol? id) 'symbol
                    (if (list? id) 'list
                         (if (string? id) 'string
                             (if (struct? id)
                                 (string->symbol (string-trim (symbol->string (vector-ref (struct->vector id) 0)) "struct:"))
                                 ;ここに考えられる限りの術後を追加する
                                  'void))))))))





(struct tawa (name adress) #:transparent)
(define ore (tawa "tawa" "hosida"))

(varivariant ore)
(variant ore)


             