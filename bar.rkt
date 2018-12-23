#lang racket

;;; shell commands

(define brightness-cmd
  "xbacklight | sed 's/.*\\(.*\\)%.*/\\1/'")

(define clock-cmd
  "date +%H:%M")

(define battery-cmd
  "acpi | sed 's/.*,\\(.*\\)%,.*/\\1/'")

(define volume-cmd
  "amixer sget Master | tail -n 1 | sed 's/.*\\[\\(.*\\)%\\].*/\\1/'")

;;; helper functions

(define (string-nolast str)
  (list->string (reverse (cdr (reverse (string->list str))))))

(define (system-to-string cmd) 
  (string-nolast (with-output-to-string (lambda () (system cmd)))))

(define (string-reverse str)
  (list->string (reverse (string->list str))))

(define (system-to-num cmd) (string->number (system-to-string cmd)))

(define (string-join lst join)
  (if (null? lst)
      ""
      (if (null? (cdr lst))
	  (car lst)
	  (string-join
	    (cons
	      (string-append (car lst) join (car (cdr lst)))
	      (cdr (cdr lst)))
	    join))))

(define (nchars n c) (if (= n 0) '() (cons c (nchars (- n 1) c))))

(define (char-rep n len char)
  (string-append
    (string-join (nchars n char) " ")
    " "
    (string-join (nchars (- len n) " ") " ")))

(define (slow-print-loop str-fn t)
  (display (str-fn)) (sleep t) (slow-print-loop str-fn t))

;;; functions

(define (brightness)
  (char-rep (round (* (/ (system-to-num brightness-cmd) 100) 5)) 5 "*"))

(define (clock)
  (system-to-string clock-cmd))

(define (battery)
  (system-to-string battery-cmd))

(define (volume)
  (string-reverse
    (char-rep (round (* (/ (system-to-num volume-cmd) 100) 5)) 5 "~")))

;;; bar

(define (bar)
  (string-append
    " %{l}" (brightness) "%{c}" (clock) " " (battery) "%{r}" (volume) " \n"))

;;; main

(slow-print-loop bar 1)
