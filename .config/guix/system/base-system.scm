;; This is an operating system configuration generated
;; by the graphical installer.

(define-module (base-system)
  #:use-module (gnu)
  #:use-module (gnu system setuid)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (gnu packages libusb)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nfs)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages wm)
  #:use-module (gnu services avahi)
  #:use-module (gnu services dbus)
  #:use-module (gnu services docker)
  #:use-module (gnu services cups)
  #:use-module (gnu services networking)
  #:use-module (gnu services ssh)
  #:use-module (gnu services xorg)
  #:use-module ((gnu services desktop) #:prefix gnu:)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:use-module (tommoa packages globalprotect-openconnect)
  #:use-module (tommoa packages greetd)
  #:use-module (tommoa packages linux-zen)
  #:use-module (tommoa packages neovim)
  #:use-module (tommoa services globalprotect-openconnect)
  #:use-module (tommoa services greetd)
  #:use-module (nongnu packages mozilla)
  #:export (base-operating-system))

(define %desktop-services
  (modify-services gnu:%desktop-services
                   (network-manager-service-type config =>
                     (network-manager-configuration (inherit config)
                                                    (vpn-plugins (list network-manager-openconnect))))
                   (delete gdm-service-type)))

(define-public base-operating-system
  (operating-system
    (host-name "james")
    (timezone "Australia/Perth")
    (locale "en_AU.utf8")

    ;; Use non-free Linux (and actually linux-zen by default for desktop/laptops) and firmware
    (kernel linux-zen)
    (firmware (list linux-firmware))
    (initrd microcode-initrd)

    ;; Choose US English keyboard layout with Colemak
    ;; I generally prefer setting capslock to escape.
    (keyboard-layout (keyboard-layout "us" "colemak" #:options '("caps:escape")))

    ;; Use the UEFI variant of GRUB with the EFI partition mounted on /boot/efi
    (bootloader (bootloader-configuration
                  (bootloader grub-efi-bootloader)
                  (targets (list "/boot/efi"))
                  (keyboard-layout keyboard-layout)))

    ;; Guix doesn't like it when there isn't a file-systems
    ;; entry, so add one that is meant to be overridden
    (file-systems (cons*
                   (file-system
                     (mount-point "/tmp")
                     (device "none")
                     (type "tmpfs")
                     (check? #f))
                   %base-file-systems))

    (users (cons* (user-account
                    (name "tommoa")
                    (comment "Tom Almeida")
                    (group "users")
                    (home-directory "/home/tommoa")
                    (shell (file-append zsh "/bin/zsh"))
                    (supplementary-groups
                      '(
                        "audio"   ;; control audio devices
                        "docker"  ;; docker
                        "lp"      ;; control bluetooth devices
                        "netdev"  ;; control network devices
                        "realtime";; enable realtime scheduling
                        "video"   ;; control video devices
                        "wheel"   ;; sudo
                       )))
                  %base-user-accounts))

    (packages (append (list
                        fontconfig font-awesome
                        font-google-noto font-inconsolata            ;; Fonts
                        (specification->package "nss-certs")         ;; for HTTPS
                        alacritty firefox                            ;; Standard graphical tools
                        neovim tmux                                  ;; Standard terminal tools
                        ripgrep fd bat exa                           ;; Rust terminal tools
                        git openssh curl pinentry                    ;; Standard terminal utilities
                        libappindicator dbus bluez                   ;; Additional libraries
                        xdg-user-dirs xdg-utils xdg-desktop-portal xdg-desktop-portal-wlr ;; XDG
                        sway swaybg swayidle swaylock wl-clipboard   ;; Sway wayland packages
                        globalprotect-openconnect                    ;; VPN required for work
                        flatpak)
                      %base-packages))

    (groups (cons (user-group (system? #t) (name "realtime"))
                  %base-groups))

    (services
      (append
        (list (service cups-service-type)
              (gnu:bluetooth-service #:auto-enable? #t)
              (screen-locker-service swaylock)
              (simple-service 'wayland-env-vars session-environment-service-type
                  '(("MOZ_ENABLE_WAYLAND" . "1")
                    ("MOZ_DBUS_REMOTE" . "1")
                    ("CLUTTER_BACKEND" . "wayland")
                    ("ECORE_EVAS_ENGINE" . "wayland-egl")
                    ("ELM_ENGINE" . "wayland_egl")
                    ("SDL_VIDEODRIVER" . "wayland")
                    ("_JAVA_AWT_WM_NONREPARENTING" . "1")
                    ("NO_AT_BRIDGE" . "1")
                    ("XDG_CURRENT_DESKTOP" . "sway")
                    ("XDG_SESSION_DESKTOP" . "sway")
                    ("XDG_SESSION_TYPE" . "wayland")))
              (service globalprotect-openconnect-service-type)
              (pam-limits-service
                     (list
                      (pam-limits-entry "@realtime" 'both 'rtprio 99)
                      (pam-limits-entry "@realtime" 'both 'memlock 'unlimited)))
              (service greetd-service-type
                       (greetd-configuration
                         (terminal-vt "next")
                         (greeter `(,greetd "/bin/agreety" " --cmd "
                                    ,sway "/bin/sway"))))
              (service docker-service-type))
        %desktop-services))))
