;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules
  (gnu)
  (gnu system setuid)
  (guix gexp)
  (guix packages)
  (nongnu packages linux)
  (nongnu system linux-initrd))

(use-service-modules
  avahi
  dbus
  docker

  cups
  desktop
  networking
  ssh
  xorg)

(use-package-modules
  libusb
  linux
  nfs

  xdisorg

  curl
  fonts
  fontutils
  freedesktop
  glib
  gnome
  gnupg
  package-management
  rust-apps
  shells
  ssh
  terminals
  tmux
  version-control
  vim
  wm)

;; These go here to override the package modules
(use-modules
  (greetd)
  (globalprotect-openconnect)
  (linux-zen) ;; Use linux-zen instead of linux-libre
  (neovim) ;; Use neovim 0.5 instead of 0.4.4
  (nongnu packages mozilla))

(operating-system
  (kernel linux-zen)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_AU.utf8")
  (timezone "Australia/Perth")
  (keyboard-layout (keyboard-layout "au" "colemak" #:options '("caps:escape")))
  (host-name "james")
  (users (cons* (user-account
                  (name "tommoa")
                  (comment "Tom Almeida")
                  (group "users")
                  (home-directory "/home/tommoa")
                  (shell (file-append zsh "/bin/zsh"))
                  (supplementary-groups
                    '(
                      "audio"
                      "docker"
                      "lp"
                      "netdev"
                      "video"
                      "wheel"
                     )))
                %base-user-accounts))
  (packages
    (append
      (list
        font-awesome mako wob wofi waybar

        fontconfig font-google-noto
        (specification->package "nss-certs")
        alacritty firefox
        neovim vim tmux
        ripgrep fd bat exa
        git openssh curl pinentry
        libappindicator dbus
        xdg-user-dirs xdg-utils xdg-desktop-portal xdg-desktop-portal-wlr
        sway swaybg swayidle swaylock wl-clipboard globalprotect-openconnect
        flatpak)
      %base-packages))
  (services
    (append
      (modify-services (list (service network-manager-service-type))
        (network-manager-service-type config =>
          (network-manager-configuration (inherit config)
            (vpn-plugins (list network-manager-openconnect)))))
      (list (service wpa-supplicant-service-type)
            (service cups-service-type)
            (bluetooth-service #:auto-enable? #t)
            (screen-locker-service swaylock)
            (simple-service 'wayland-env-vars session-environment-service-type
                '(("MOZ_ENABLE_WAYLAND" . "1")
                  ("MOZ_DBUS_REMOTE" . "1")
                  ("CLUTTER_BACKEND" . "wayland")
                  ;; ("QT_QPA_PLATFORM" . "wayland-egl") ;; This seems to not work properly on GUIX
                  ("ECORE_EVAS_ENGINE" . "wayland-egl")
                  ("ELM_ENGINE" . "wayland_egl")
                  ("SDL_VIDEODRIVER" . "wayland")
                  ("_JAVA_AWT_WM_NONREPARENTING" . "1")
                  ("NO_AT_BRIDGE" . "1")
                  ("XDG_CURRENT_DESKTOP" . "Unity")
                  ("XDG_SESSION_DESKTOP" . "sway")
                  ("XDG_SESSION_TYPE" . "wayland")))
            (service globalprotect-openconnect-service-type)
            (service greetd-service-type
                     (greetd-configuration
                       (terminal-vt "next")
                       (greeter (mixed-text-file "greeter"
                                  greetd "/bin/agreety" " --cmd "
                                  sway "/bin/sway"))))
            (service docker-service-type)

            (simple-service 'mtp udev-service-type (list libmtp))
            (service sane-service-type)
            polkit-wheel-service
            (simple-service 'mount-setuid-helpers setuid-program-service-type
                            (map (lambda (program)
                                   (setuid-program
                                     (program program)))
                                 (list (file-append nfs-utils "/sbin/mount.nfs")
                                   (file-append ntfs-3g "/sbin/mount.ntfs-3g"))))
           fontconfig-file-system-service
           (service modem-manager-service-type)
           (service usb-modeswitch-service-type)
           (service avahi-service-type)
           (udisks-service)
           (service upower-service-type)
           (accountsservice-service)
           (service cups-pk-helper-service-type)
           (service colord-service-type)
           (geoclue-service)
           (service polkit-service-type)
           (elogind-service)
           (dbus-service)
           x11-socket-directory-service
           (service ntp-service-type))
      %base-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout keyboard-layout)))
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
