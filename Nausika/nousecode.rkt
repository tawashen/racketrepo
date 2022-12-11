#lang racket


#|
(define (battle-print-loop env) ;バトルPRINT関数LOOP合体版
    (if (null? (master-enemy env)
            (display "to master")
  (match-let (((battle player monster Cdamage Pphp Cturn) env))
    (match-let (((hero pac php equip) player) ((enemy ename eac ehp page limit) monster))
      (display (format (cdr (assq 'turn *battle-messages*)) Cturn))
      (display (format (cdr (assq 'status *battle-messages*)) pac Pphp))
      (cond ((= Cdamage 0) (wait) (display (format (cdr (assq 'tie *battle-messages*)))) (wait)
                          (battle-eval env))
           ((> Cdamage 0) (display (format (cdr (assq 'atack *battle-messages*))))
                         (wait) (display (format (cdr (assq 'damagep *battle-messages*)) (abs Cdamage))) (wait)
                         (if (<= ehp 0)
                            (battle-end-win) (battle-eval env)))
           ((< Cdamage 0) (display (format (cdr (assq 'atacked *battle-messages*)) ename))
                         (wait) (display (format (cdr (assq 'damagedp *battle-messages*)) (abs Cdamage))) (wait)
                         (if (<= php 0)
                            (battle-end-lose) (battle-eval env)))))))
|#


#|
(define (battle-eval-auto env) ;バトルEVAL-AUTO関数
  (match-let (((master page ac hp equip enemies Cdamage Pphp Cturn choice) env))
    (match-let (((enemy name Eac Ehp page human) (car enemies)))
    (let ((Cac (cond ((equip? equip "剣") (+ ac 2))
                    ((equip? equip "短剣") (+ ac 1))
                    ((equip? equip "短剣(セラミック製)") (+ ac 1))
                    (else ac))))
      (let ((damage (- (+ (saikoro) Cac) (+ (saikoro) Eac))))
        (cond ((= damage 0)(battle-print
                             (master page ac hp equip enemies 0 Pphp (+ Cturn 1) choice) env))
             ((> damage 0) (battle-print
                            (master page ac hp equip
                                   (cons (enemy name Eac (- Ehp (abs damage)) page human) (cdr enemies))
                                   damage hp (+ Cturn 1) #f)))
             ((< damage 0) (battle-print
                             (master page ac (- hp (if (equip? equip "額あて")
                                                      (abs (+ damage 1)) (abs damage)))
                                               equip enemies damage hp (+ Cturn 1) #f)))))))))
|#
    