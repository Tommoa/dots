(define-module (auto-system-config)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim))

;; We always load the base system
(load (string-append (dirname (current-filename)) "/base-system.scm"))

;; Load the file that describes our hostname
(let* ((process (open-input-pipe "uname -n"))
       (hostname (read-line process))
       (status (close-pipe process)))
  (if (not (eqv? 0 (status:exit-val status)))
      (error "Cannot get hostname. Try running directly")
      (load (string-append
              (dirname (current-filename)) "/" hostname ".scm"))))
