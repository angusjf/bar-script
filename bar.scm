#!/usr/bin/scm -f

;;; (define (trim str) (let (lst (string->list str))))
(define (trim str) str)

(define (nchars n c) 
  (if (= n 0)
      '()
      (cons c (nchars (- n 1) c))))

(define (string-join)

(define (loop fn)
  (eval fn)
  (sleep 1)
  (loop fn))

(define (brightness)
  (string-join (nchars 5 "*") " "))

(define (clock)
  (trim (system "date")))

(define (battery) "0%")

(define (volume) "~ ~ ~ ~ ~")

(define (bar)
  (display "%{l}")
  (display (brightness))
  (display "%{c}")
  (display (clock))
  (display " ")
  (display (battery))
  (display "%{r}")
  (display (volume))
  (newline))

(loop '(bar))

;;; echo $(awk -F'[][]' '/dB/ { print $2 }' <(amixer sget Master) | rev | cut -c 2- | rev)
