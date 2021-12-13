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
  (tommoa packages aerc)
  (gnu home services shells))

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
      (service pipewire-service-type)
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
