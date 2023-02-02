#lang racket

(require 2htdp/image 2htdp/universe)

;                              
;                              
;                              
;                    ;         
;                              
;  ; ;; ;; ;;;;    ;;;   ; ;;  
;  ;; ;; ;     ;     ;   ;;  ; 
;  ;  ;  ;  ;;;;     ;   ;   ; 
;  ;  ;  ; ;   ;     ;   ;   ; 
;  ;  ;  ; ;  ;;     ;   ;   ; 
;  ;  ;  ;  ;;  ;    ;   ;   ; 
;                              
;                              

;; Number Number -> GuessRange
;; Start playing a new game in [n,m]
;; > (start 0 100)  ; Press up, up, down, q.
;; (interval 76 87)
(define (start lower upper) 
  (big-bang (interval lower upper)
            (on-key deal-with-guess)
            (to-draw render)
            (stop-when single? render)))

;                                     
;                                     
;                                     
;                                     
;           ;             ;           
;    ;;;;  ;;;;;  ;;;;   ;;;;;   ;;;  
;   ;       ;         ;   ;     ;   ; 
;    ;;     ;      ;;;;   ;     ;;;;; 
;      ;    ;     ;   ;   ;     ;     
;       ;   ;     ;  ;;   ;     ;     
;   ;;;;     ;;;   ;;  ;   ;;;   ;;;; 
;                                     
;                                     

(struct interval (small big) #:transparent)
;; A GuessRange is a (interval Number Number)
;; Always true: (interval l u) means (<= l u).

;                                                                 
;                                                                 
;                                                                 
;                                                                 
;                                ;                    ;           
;    ;;;;   ;;;   ; ;;    ;;;;  ;;;;;  ;;;;   ; ;;   ;;;;;   ;;;; 
;   ;      ;   ;  ;;  ;  ;       ;         ;  ;;  ;   ;     ;     
;   ;      ;   ;  ;   ;   ;;     ;      ;;;;  ;   ;   ;      ;;   
;   ;      ;   ;  ;   ;     ;    ;     ;   ;  ;   ;   ;        ;  
;   ;      ;   ;  ;   ;      ;   ;     ;  ;;  ;   ;   ;         ; 
;    ;;;;   ;;;   ;   ;  ;;;;     ;;;   ;;  ; ;   ;    ;;;  ;;;;  
;                                                                 
;                                                                 

(define TEXT-SIZE 11)
(define HELP-TEXT 
  (text "↑ for larger numbers, ↓ for smaller ones" 
        TEXT-SIZE 
        "blue"))
(define HELP-TEXT2 
  (text "Press = when your number is guessed; q to quit." 
        TEXT-SIZE 
        "blue"))
(define WIDTH (+ (image-width HELP-TEXT2) 10))
(define HEIGHT 150)
(define COLOR "red")
(define SIZE 72)
(define TEXT-X 3)
(define TEXT-UPPER-Y 10)
(define TEXT-LOWER-Y 135)
(define MT-SC 
  (place-image/align 
   HELP-TEXT TEXT-X TEXT-UPPER-Y 
   "left" "top" 
   (place-image/align 
    HELP-TEXT2 
    TEXT-X TEXT-LOWER-Y "left" "bottom"
    (empty-scene WIDTH HEIGHT))))

;                                                          
;                                                          
;   ;                        ;  ;;;                        
;   ;                        ;    ;                        
;   ;                        ;    ;                        
;   ; ;;   ;;;;   ; ;;    ;; ;    ;     ;;;   ; ;;;   ;;;; 
;   ;;  ;      ;  ;;  ;  ;  ;;    ;    ;   ;  ;;  ;  ;     
;   ;   ;   ;;;;  ;   ;  ;   ;    ;    ;;;;;  ;       ;;   
;   ;   ;  ;   ;  ;   ;  ;   ;    ;    ;      ;         ;  
;   ;   ;  ;  ;;  ;   ;  ;  ;;    ;    ;      ;          ; 
;   ;   ;   ;;  ; ;   ;   ;; ;    ;     ;;;;  ;      ;;;;  
;                                                          
;                                                          

;; GuessRange -> Boolean
;; Does the interval represent a single number?
;; > (single? (interval 1 1))
;; #t
(define (single? w)
  (= (interval-small w) (interval-big w)))

;; GuessRange -> Number
;; Calculates a guess based on the given interval
;; > (guess (interval 0 100))
;; 50
(define (guess w)
  (quotient (+ (interval-small w) (interval-big w)) 2))

;; GuessRange -> GuessRange
;; Recreates a GuessRange that lowers the upper bound
;; > (smaller (interval 0 100))
;; (interval 0 50)
(define (smaller w)
  (interval (interval-small w)
            (max (interval-small w) 
                 (sub1 (guess w)))))

;; GuessRange -> GuessRange
;; Recreates a interval that raises the lower bound
;; > (bigger (0 100)
;; (interval 51 100)
(define (bigger w)
  (interval (min (interval-big w) 
                 (add1 (guess w)))
            (interval-big w)))

;; GuessRange Key -> GuessRange
;; Handles key input
;; > (key-handler (interval 0 100) "up")
;; (interval 51 100)
;; > (key-handler (interval 0 100) "q")
;; (stop-with (interval 0 100))
(define (deal-with-guess w key)
  (cond [(key=? key "up") (bigger w)]
        [(key=? key "down") (smaller w)]
        [(key=? key "q") (stop-with w)]
        [(key=? key "=") (stop-with w)]
        [else w]))

;                                                                 
;                                                                 
;                            ;                                    
;                            ;                   ;                
;                            ;                                    
;   ; ;;;   ;;;   ; ;;    ;; ;   ;;;   ; ;;;   ;;;   ; ;;    ;; ; 
;   ;;  ;  ;   ;  ;;  ;  ;  ;;  ;   ;  ;;  ;     ;   ;;  ;  ;  ;; 
;   ;      ;;;;;  ;   ;  ;   ;  ;;;;;  ;         ;   ;   ;  ;   ; 
;   ;      ;      ;   ;  ;   ;  ;      ;         ;   ;   ;  ;   ; 
;   ;      ;      ;   ;  ;  ;;  ;      ;         ;   ;   ;  ;  ;; 
;   ;       ;;;;  ;   ;   ;; ;   ;;;;  ;         ;   ;   ;   ;; ; 
;                                                               ; 
;                                                           ;;;;  

;; GuessRange -> Scene
;; Visualize given interval as a scene
;; > (render (interval 0 100))
;; (overlay (text "50" 72 "red") MT-SC)
(define (render w)
  (overlay (text (number->string (guess w)) SIZE COLOR) MT-SC))