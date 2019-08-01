;; ============= package archives ========
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; ============== use package =============
(package-initialize)
(when (not package-archive-contents) (package-refresh-contents))
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents) 
      (package-install 'use-package)))
(require 'use-package)
(setq use-package-always-ensure t)    ;; download packages if not already downloaded


;; ============= Packages ================
(use-package evil)                      ; vi like key bindings
(use-package magit) 			; git integration
(use-package evil-magit)                ; vi bindings for magit
(use-package general                    ; key binding framework
  :config (general-evil-setup t)) 
(use-package hydra)                     ; hydra menus

(use-package winum)                     ; switch between buffers using numbers
(use-package projectile)                ; navigate git projects

;; ============== Package Config ================
(evil-mode 1)
(load-theme 'wombat t)                  ; color theme
(set-face-attribute 'default nil :height 140 :family "DejaVu Sans Mono") 
(desktop-save-mode 1)
(winum-mode)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(setq-default truncate-lines t) 	; dont wrap long lines
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; =========== Hydras ===============
(defhydra hydra-buffers ()
  "
^^^       BUFFERS ^^^
^ Goto  ^ ^ Save  ^ ^ Misc  ^  
^-------^ ^-------^ ^-------^
_k_ prev  _s_ this  _d_ kill
_j_ next  _a_ all    
"
  ("j" next-buffer nil)
  ("k" previous-buffer nil)

  ("s" save-buffer nil)
  ("a" (lambda () (interactive) (save-some-buffers t)) nil :exit t)

  ("d" kill-this-buffer nil)

  ("q" nil "quit" :exit t :color pink))


;; ============== Leader Key ===============
(fset 'gdk 'general-define-key)

(apply 'gdk 
       :prefix "SPC"
       :states '(normal visual emacs motion)
       '("" nil
	 "1" winum-select-window-1
	 "2" winum-select-window-2
	 "3" winum-select-window-3
	 "4" winum-select-window-4
	 "b" hydra-buffers/body
	 "g" (:ignore t :wk "Magit")
	 "gs" magit-status
	 ))


;; ============ Emacs Crap ====================
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
