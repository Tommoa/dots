(define-module (james)
  #:use-module (base-system)
  #:use-module (gnu))

(operating-system
 (inherit base-operating-system)
 (host-name "james")

 (swap-devices
   (list (swap-space
           (target (uuid "0e5ad987-49a4-4ecb-b9c1-2f0dc3612bc3")))))
 (file-systems
   (cons* (file-system
            (mount-point "/")
            (device
              (uuid "e7475ecf-a8dc-48f7-bce5-863dfd8311e5"
                    'btrfs))
            (type "btrfs"))
          (file-system
            (mount-point "/boot/efi")
            (device (uuid "8E1A-2DA2" 'fat32))
            (type "vfat"))
          %base-file-systems)))
