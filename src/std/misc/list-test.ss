(export list-test)

(import
  :gerbil/gambit/exceptions
  :std/error :std/misc/list :std/test)

(def (error-with-message? message)
  (lambda (e)
    (and (error-exception? e) (equal? (error-exception-message e) message))))

(def (copy-list lst) (foldr cons '() lst))

(def list-test
  (test-suite "test suite for std/misc/list"
    (test-case "test length=?"
      (check-equal? (length=? '(1 2 3) '(a b c)) #t)
      (check-equal? (length=? '(1 2 3) '(a b c d)) #f)
      (check-equal? (length=? '(1 2 3 4) '(a b c)) #f)
      (check-equal? (length=? '(1 2 3) '(a b c . d)) #t)
      (check-equal? (length=? '(1 2 3 . 4) '(a b c)) #t))
    (test-case "test length<?"
      (check-equal? (length<? '(1 2 3) '(a b c d)) #t)
      (check-equal? (length<? '(1 2 3 . 4) '(a b c d)) #t)
      (check-equal? (length<? '(1 2 3) '(a b c)) #f)
      (check-equal? (length<? '(1 2 3 4) '(a b c)) #f)
      (check-equal? (length<? '(1 2 3) '(a b c . d)) #f))
    (test-case "test length=n?"
      (check-equal? (length=n? '(1 2 3) 4) #f)
      (check-equal? (length=n? '(1 2 3) 3) #t)
      (check-equal? (length=n? '(1 2 3) 2) #f)
      (check-equal? (length=n? '(1 2 3) 3.14159) #f)
      (check-equal? (length=n? '(1 2 3) 3.0) #t)
      (check-equal? (length=n? '(1 2 3) 2.5) #f)
      (check-equal? (length=n? '(1 2 3 4) 3) #f)
      (check-equal? (length=n? '(1 2 3 . 4) 3) #t)
      (check-equal? (length=n? '(1 2 3 . 4) 4) #f)
      (check-equal? (length=n? '(1 2 3 . 4) 3.5) #f)
      (check-equal? (length=n? '(1 2 3) -4) #f)
      (check-equal? (length=n? '(1 2 3) 6.022e23) #f)
      (check-equal? (length=n? '(1 2 3) 2+3i) #f)
      (check-exception (length=n? '(1 2 3) 'foo) (error-with-message? "not a number")))
    (test-case "test length<=n?"
      (check-equal? (length<=n? '(1 2 3) 4) #t)
      (check-equal? (length<=n? '(1 2 3) 3) #t)
      (check-equal? (length<=n? '(1 2 3) 2) #f)
      (check-equal? (length<=n? '(1 2 3) 3.14159) #t)
      (check-equal? (length<=n? '(1 2 3) 3.0) #t)
      (check-equal? (length<=n? '(1 2 3) 2.5) #f)
      (check-equal? (length<=n? '(1 2 3 4) 3) #f)
      (check-equal? (length<=n? '(1 2 3 . 4) 4) #t)
      (check-equal? (length<=n? '(1 2 3 . 4) 3) #t)
      (check-equal? (length<=n? '(1 2 3 . 4) 2) #f)
      (check-equal? (length<=n? '(1 2 3) -4) #f)
      (check-equal? (length<=n? '(1 2 3) 6.022e23) #t)
      (check-exception (length<=n? '(1 2 3) 2+3i) (error-with-message? "not a real number"))
      (check-exception (length<=n? '(1 2 3) 'foo) (error-with-message? "not a real number")))
    (test-case "test length<n?"
      (check-equal? (length<n? '(1 2 3) 4) #t)
      (check-equal? (length<n? '(1 2 3) 3) #f)
      (check-equal? (length<n? '(1 2 3) 2) #f)
      (check-equal? (length<n? '(1 2 3) 3.14159) #t)
      (check-equal? (length<n? '(1 2 3) 3.0) #f)
      (check-equal? (length<n? '(1 2 3) 2.5) #f)
      (check-equal? (length<n? '(1 2 3 4) 3) #f)
      (check-equal? (length<n? '(1 2 3 . 4) 4) #t)
      (check-equal? (length<n? '(1 2 3 . 4) 3) #f)
      (check-equal? (length<n? '(1 2 3 . 4) 2) #f)
      (check-equal? (length<n? '(1 2 3) -4) #f)
      (check-equal? (length<n? '(1 2 3) 6.022e23) #t)
      (check-exception (length<n? '(1 2 3) 2+3i) (error-with-message? "not a real number"))
      (check-exception (length<n? '(1 2 3) 'foo) (error-with-message? "not a real number")))
    (test-case "test call-with-list-builder"
      (check-equal?
       (call-with-list-builder
        (lambda (put! _)
          (put! 1) (put! 2) (put! 3)))
       '(1 2 3))
      (check-equal?
       (call-with-list-builder
        (lambda (put! get-list-so-far)
          (put! 1)
          (put! 2)
          (put! (copy-list (get-list-so-far)))
          (put! 3)))
       '(1 2 (1 2) 3)))
    (test-case "test snoc"
      (check-equal? (snoc 3 []) [3])
      (check-equal? (snoc 1 [3 2]) [3 2 1]))
    (test-case "test append1"
      (check-equal? (append1 [] 3) [3])
      (check-equal? (append1 [3 2] 1) [3 2 1]))))