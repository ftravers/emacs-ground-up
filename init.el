;; ============== Package Archives ==============
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents) (package-refresh-contents))
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents) 
      (package-install 'use-package)))
(require 'use-package)
(setq use-package-always-ensure t)    ;; download packages if not already downloaded


;; ============== Packages ======================
(use-package evil)                      ; vi like key bindings


;; ============== Package Config ================
(evil-mode 1)
(load-theme 'wombat t)                  ; color theme
(set-face-attribute 'default nil :height 140 :family "DejaVu Sans Mono") 
(desktop-save-mode 1)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq-default truncate-lines t) 	; dont wrap long lines
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)


;; ============== Emacs Crap ====================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
