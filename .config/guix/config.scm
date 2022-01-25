;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu packages golang)
  (gnu services)
  (guix packages)
  (gnu packages mail)
  (guix gexp)
  (tommoa services mail)
  (tommoa services pipewire)
  (tommoa services wlsunset)
  (tommoa packages aerc)
  (tommoa packages pipewire)
  (ice-9 textual-ports)
  (gnu home services shells))

(define add-profile-service-type
  (service-type
    (name 'add-profile-service)
    (extensions
      (list
        (service-extension home-shell-profile-service-type
          (const `(,(local-file (string-append (getenv "HOME") "/.config/profile")))))))))

(home-environment
  (packages
    (map specification->package
         (list "khal"
               "khard"
               "vdirsyncer-oauth"
               "ncurses"
               "w3m"
               "dante"
               "libnotify"
               "aerc"
               "notmuch"
               "isync"
               "msmtp"
               "imv"

               "pipewire"
               "pavucontrol"
               "pamixer"
               "git"
               "pinentry"
               "libappindicator"
               "wl-clipboard"
               "waybar"
               "wofi"
               "wob"
               "mako"
               "bluez"
               "font-awesome"
               "make"
               "gcc-toolchain"
               "curl"
               "font-inconsolata")))
  (services
    (list
      (service pipewire-service-type
               (pipewire-configuration
                 (media-session `("env" "WIREPLUMBER_DEBUG=T" (string-append ,wireplumber "/bin/wireplumber")))))
      (service add-profile-service-type '())
      (service wlsunset-service-type
               (wlsunset-configuration
                 (low-temp  3500)
                 (latitude  31.95)
                 (longitude 115.86)))
      (service imapnotify-service-type (imapnotify-configuration
                                         (configuration (string-append
                                                          (getenv "HOME")
                                                          "/.config/imapnotify/tommoa.conf"))))
      (service imapnotify-service-type (imapnotify-configuration
                                         (configuration (string-append
                                                          (getenv "HOME")
                                                          "/.config/imapnotify/gmail.conf"))))
      (service imapnotify-service-type (imapnotify-configuration
                                         (configuration (string-append
                                                          (getenv "HOME")
                                                          "/.config/imapnotify/arista.conf")))))))
