#lang racket
(define (world-go w delta)
 (let loop ((back (world-back w))
     (branches (world-branches w))
     (characters (world-characters w))
     (color (world-color w))
     (message (world-message w))
     (scenario (world-scenario w)))
  (let ((s-expression (car scenario)))
   (let ((head (car s-expression)) (tail (cdr s-expression)))
;    ;; デバッグ用
;    (display
;     (format "branches: ~a\ncolor: ~a
;instruction: ~a\ntail: ~a\ninput: ~a\n"
;      branches color head tail delta))
    (case head
     ((back) (loop (car tail) branches '() ;; キャラクタ画像更新
          color message (cdr scenario)))
     ((branch) (loop back (cons tail branches) characters
           color message (cdr scenario)))
     ((break) (cond ((string=? delta "up") ;; 選択肢(上)を選ぶ
           (world back branches characters
             1 message scenario))
           ((string=? delta "down") ;; 選択肢(下)を選ぶ
            (world back branches characters
              2 message scenario))
           ((or (string=? delta "1")
             (string=? delta "2"))
            (world-go
             (world back '() characters
               color message
               (find-label
                (third (assv
                   ;; 文字列->数値変換になる
                   (string->number delta)
                   branches))
                scenario)) "\r"))
           ((or (string=? delta "y")
             (string=? delta "n"))
            (world-go
             (world back '() characters
               color message
               (find-label
                (second (assoc delta
                      (map reverse branches)))
                scenario)) "\r"))
           ;; 選択肢が「選択」された時の「決定」
           ((or (string=? "\r")
             (string=? " "))
            (world-go
             (world back '() characters
               color message
               (find-label
                (third
                 ;; world構造体のカラースロットが
                 ;; 連想リストのキーとなる
                 (assv color branches))
                scenario))
              "\r"))
           (else
            (world back branches characters
              color message scenario))))
     ((end) (world back branches characters
          color *end-message* scenario))
     ((jump) (world-go
         (world back branches characters
           color message (find-label
                 (car tail) scenario))
         "\r"))
     ((label) (world back branches characters color message
          (cons '(break) scenario)))
     ((msg) (world back branches characters
          color (car tail)
          ;; 今回は入力情報を明確化する
          (if (or (string=? delta " ")
            (string=? delta "\r"))
           (cdr scenario)
           scenario)))
     ((putChar) (loop back branches
           (if (member tail characters)
            characters
            (cons tail characters))
            color message (cdr scenario)))
     (else (error "Can't do " head)))))))