#lang racket

(require rackunit racket/trace)

;construindo a função build-list
; veja como  ela funciona
;curioso que o range faz basicamente a mesma coisa que o build list,
;na versão com values

(check-equal? (build-list 10 values) (range 0 10))

;existem build-list mais sofisticados, que inserem um procedure na construção da lista

(check-equal? (build-list 10 sub1) '(-1 0 1 2 3 4 5 6 7 8))

;dá para usar inclusive procedimentos anônimos, os lambdas

(check-equal? (build-list 10 (lambda (x) (* 5 x))) '(0 5 10 15 20 25 30 35 40 45))

;basicamente, a função build-list vai construindo uma lista de tamanho n, definido no input, começando a contagem do zero)

;dá para usar o build-list com o range, cria uma lista de listas!

(check-equal? (build-list 10 range) '(()
                                      (0)
                                      (0 1)
                                      (0 1 2)
                                      (0 1 2 3)
                                      (0 1 2 3 4)
                                      (0 1 2 3 4 5)
                                      (0 1 2 3 4 5 6)
                                      (0 1 2 3 4 5 6 7)
                                      (0 1 2 3 4 5 6 7 8)))

(check-equal? (length (build-list 10 range)) 10)

;primeira coisa vou tentar construir uma lista de 0 até (n-1)
;CONSEGUI

#| (define (my-build-list list-len)
  (define (iter list-len lst n)
    (if (= (length lst) list-len)
        (reverse lst)
        (iter list-len (cons n lst) (add1 n))))
  (trace iter)
  (iter list-len '() 0))

(my-build-list 10)

(define (my-build-list-recur list-len lst)
  (cond ((= (length lst) list-len) (reverse lst))
        (else (my-build-list-recur list-len (cons (add1 (car lst)) lst)))))

(trace my-build-list-recur)

(my-build-list-recur 10 '(0)) |#

(define (my-build-list list-len proc)
  (define (iter list-len accu n)
    (if (= (length accu) list-len)
        (reverse accu)
        (iter list-len (cons (proc n) accu) (add1 n))))
  ;(trace iter)
  (iter list-len '() 0))

; veja como o lambda dentro do build-list assume essa forma de (lambda (x) (* x x))
(check-equal? (build-list 5 (lambda (x) (* x x)))
              (my-build-list 5 (lambda (x) (* x x))))

(define (my-build-list-recur list-len proc)
  (if (= list-len 0)
      '()
      (cons  (proc (sub1 list-len)) (my-build-list-recur (sub1 list-len) proc))))

;(trace my-build-list-recur)
(check-equal? (reverse (my-build-list-recur 10 (lambda (x) (* x x))))
              (build-list 10 (lambda (x) (* x x))))

(define (my-build-list-book n f)
 (trace-define (builder k)
   (cond [(= n k) empty]
         [else (cons (f k) (builder (add1 k)))]))
  (builder 0))


(my-build-list-book 10 add1)

