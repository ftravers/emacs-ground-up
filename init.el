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
(use-package helm)                      ; incremental completions and narrowing selections 
(use-package helm-projectile)           ; integrate projectile with helm 
(use-package lispy)                     ; structural lisp editing
(use-package evil-lispy)                ; vi bindings for lispy



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
(setq projectile-completion-system 'helm
      projectile-switch-project-action 'helm-projectile)  


;; ================== Functions ================
(defun in-special-p ()
  (and (evil-lispy-state-p)
       (or (lispy-right-p) (lispy-left-p))))
(defun i-lispy ()
  (interactive)
  (let* ((char-at-point (char-after))
	 (char-b4-point (char-before))
	 (close-paren 41)
	 (open-paren 40))
    (if (region-active-p)
	(lispy-tab)
      (progn
	(if (and char-at-point (= char-at-point open-paren))
	    (if (in-special-p)
		(special-lispy-tab)))))
    (if (not (in-special-p))
	(evil-lispy-state))))
(defun o-lispy ()
  (interactive)
  (evil-open-below 1)
  (call-interactively #'evil-lispy-state))
(defun O-lispy ()
  (interactive)
  (evil-open-above 1)
  (call-interactively #'evil-lispy-state))
(defun a-lispy ()
  (interactive)
  (evil-append 1)
  (call-interactively #'evil-lispy-state))
(defun A-lispy ()
  (interactive)
  (evil-append-line 1)
  (evil-lispy-state))
(defun my-remove-lispy-key (key)
  (define-key lispy-mode-map-base key nil)
  (define-key lispy-mode-map-lispy key nil)
  (define-key lispy-mode-map-oleh key nil)
  (define-key lispy-mode-map-paredit key nil)
  (define-key lispy-mode-map-special key nil))
(defun fenton/open-par-brk-crly-q ()
  "true if on opening paren, brack or curly"
  (let* ((open-paren 40)
         (open-bracket 91)
         (open-curly 123)
         (char-at-point (char-after)))
    (cond ((eq char-at-point open-paren) t)
          ((eq char-at-point open-curly) t)
          ((eq char-at-point open-bracket) t)
          (t nil))))
(defun fenton/close-par-brk-crly-q ()
  "true if on opening paren, brack or curly"
  (let* ((close-paren 41)
         (close-bracket 93)
         (close-curly 125)
         (char-at-point (char-after)))
    (cond ((eq char-at-point close-paren) t)
          ((eq char-at-point close-curly) t)
          ((eq char-at-point close-bracket) t)
          (t nil))))
(defun fenton/first-paren ()
  (interactive)
  (re-search-forward "[]\(\[{}\)]")
  (backward-char)
  (if (fenton/open-par-brk-crly-q)
      (call-interactively #'evil-lispy/enter-state-left))
  (if (fenton/close-par-brk-crly-q)
      (call-interactively #'evil-lispy/enter-state-right)))

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
	 "g" (:ignore t)
	 "gs" magit-status
	 "SPC" helm-M-x
	 "p" (:ignore t)
         "pf" helm-projectile-find-file
         "pp" helm-projectile-switch-project
         "w" (:ignore t)
         "wd" delete-window-balance
         "w0" delete-window-balance
         "wm" delete-other-windows
         "w1" delete-other-windows
         "wv" split-window-vertical-balance
         "w2" split-window-vertical-balance
         "w-" split-window-below-balance
         "w3" split-window-below-balance
         "w=" balance-windows
         "wt" transpose-windows
	 ))

(apply
 'gdk :keymaps '(emacs-lisp-mode-map)
 :states '(normal visual emacs)
 '("" nil
   "i" (i-lispy :wk "insert -> lispy state")
   "o" (o-lispy :wk "open below -> lispy state")
   "O" (O-lispy :wk "open above -> lispy state")
   "a" (a-lispy :wk "append -> lispy state")
   "A" (A-lispy :wk "append line -> lispy state")
   "]" (fenton/first-paren :wk "enter lispy mode right")
   "[" evil-lispy/enter-state-left))

;; ============ Emacs Crap ====================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (helm evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
