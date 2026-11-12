;; -*- mode: scheme; -*-
(use-modules (gnu) (gnu system nss) (nongnu packages linux) (guix packages) (guix gexp) (nongnu packages mozilla) (gnu packages linux) (guix utils))
(use-service-modules desktop networking xorg sddm virtualization)
(use-package-modules wm xorg text-editors containers base java node web compression gimp package-management games pkg-config toys gnome window-management pulseaudio linux commencement librewolf fonts admin python-xyz
                     terminals version-control gnuzilla xdisorg
                     shells shellutils vim web-browsers)

(define my-custom-kernel
  (package
    (inherit linux-libre)
    (name "linux-7.3.1")
    (version "7.3.1")
    (source (local-file "/home/fraggi/kernel-build/linux-7.3.1"
                        "linux-source"
                        #:recursive? #t))
    (native-inputs
     (modify-inputs (package-native-inputs linux-libre)
       (prepend (local-file "/home/fraggi/kernel-build/linux-7.3.1/.config" "kconfig"))))))

(operating-system
  (host-name "Guix")
  (timezone "Europe/Rome")
  (locale "en_US.utf8")

  (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets (list "/boot/efi"))
              (menu-entries
                (list (menu-entry
                        (label "Windows")
                        (device (uuid "9A5A-7AAA" 'fat))
                        (chain-loader "/EFI/Microsoft/Boot/bootmgfw.efi"))))))

  (kernel my-custom-kernel)

  (firmware (cons linux-firmware %base-firmware))

  (file-systems (append
                 (list (file-system
                         (device "/dev/nvme0n1p3")
                         (mount-point "/")
                         (type "ext4"))
                       (file-system
                         (device "/dev/nvme0n1p1")
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (users (cons (user-account
                (name "fraggi")
                (group "users")
                (shell (file-append zsh "/bin/zsh"))
                (supplementary-groups '("wheel" "kvm" "libvirt" "netdev" "audio" "video" "input" "tty")))
               %base-user-accounts))

  (packages (append (list (@ (gnu packages window-management) niri)
                          (@ (gnu packages window-management) waybar)
			  (@ (gnu packages window-management) swaybg)
                          (@ (nongnu packages mozilla) firefox)
                          zsh
			  podman
			  unzip
			  openjdk
			  node
			  jq
			  coreutils
			  xwayland-satellite
			  starship
                          rofi
                          vim
                          font-jetbrains-mono
                          librewolf
			  mako
			  acpi
			  libnotify
			  cmatrix
			  cowsay
			  asciiquarium
			  flatpak
			  cbonsai
                          git
			  gimp
                          btop
			  htop
			  pipewire
			  wireplumber
			  pulseaudio
			  pavucontrol
			  wl-mirror
			  awww
			  alacritty
			  gcc-toolchain
			  pkg-config
                          fastfetch)
                    %base-packages))

  (services
   (cons* (service sddm-service-type)
	  (service libvirt-service-type)
	  (service virtlog-service-type)
          (modify-services %desktop-services
           (delete gdm-service-type)
           (guix-service-type config =>
            (guix-configuration
             (inherit config)
             (substitute-urls
              (append (list "https://substitutes.nonguix.org")
                      %default-substitute-urls))
             (authorized-keys
              (append (list (plain-file "non-guix.pub"
                                        "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                      %default-authorized-guix-keys))))))))
