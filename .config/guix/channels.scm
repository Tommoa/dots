(cons* (channel
         (name 'nonguix)
         (url "https://gitlab.com/nonguix/nonguix")
         (introduction
          (make-channel-introduction
           "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
           (openpgp-fingerprint
            "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
       (channel
         (name 'tommoa)
         (url (string-append "file://" (getenv "HOME") "/docs/guix-overrides")))
       ;; This should be uncommented when not developing for tommoa
       ;; (channel
       ;;   (name 'tommoa)
       ;;   (url "https://git.sr.ht/~tommoa/guix-overrides"))
       %default-channels)
