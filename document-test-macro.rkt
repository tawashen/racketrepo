#lang racket

;#;
(define-syntax varivariant
  (syntax-rules ()
    ((_ id) (if (number? id) 'number
                (if (symbol? id) 'symbol
                    (if (list? id) 'list
                         (if (string? id) 'string
                              (if struct? id)
                              (with-handlers ([exn:fail
                              ;ここでエラーを起こしてエラーメッセージを捉えたい              
                'void))))))
                

(varivariant )




             