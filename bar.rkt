#lang racket

(define (system-to-string cmd) "NOT IMPLEMENTED")

(define (system-to-num cmd)
  (let ((string-nolast (lambda (str)
	  (string-append (reverse (cdr (reverse (string->list str))))))))
    0.5))

(define (char-rep n len char)
  (letrec ((string-join (lambda (lst join)
			  (if (null? lst)
			      lst
			      (if (null? (cdr lst))
				  (car lst)
				  (string-join
				    (cons
				      (string-append (car lst) join (car (cdr lst)))
				      (cdr (cdr lst))) join)))))
	   (nchars (lambda (n c) (if (= n 0) '() (cons c (nchars (- n 1) c))))))
    (string-append
      (string-join (nchars n "*") " ") " " (string-join (nchars (- len n) " ") " "))))

(define (loop fn)
  (fn) (sleep 1) (loop fn))

(define (brightness)
  (char-rep (round (* (system-to-num "xdisplay") 5)) 5 "*"))

(define (clock)
  (system-to-string "date"))

(define (battery)
  "0%")

(define (volume)
  (char-rep (round (* (system-to-num "amixer") 5)) 5 "*"))

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

(loop bar)

;;; echo $(awk -F'[][]' '/dB/ { print $2 }' <(amixer sget Master) | rev | cut -c 2- | rev)
