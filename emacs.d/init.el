(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(load custom-file 'noerror)

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

(let ((paths-to-add '("/usr/local/bin" "~/.local/bin")))
  (setenv "PATH" (concat (getenv "PATH") (mapconcat 'identity paths-to-add ":")))
  (setq exec-path (append exec-path paths-to-add)))

(setenv "LANG" "en_US.UTF-8")
(setenv "LC_CTYPE" "en_US.UTF-8")

(require 'defuns-cfg)
(require 'enlarge-cfg)
(require 'keybindings-cfg)

(if (member "Monaco" (font-family-list))
    (set-face-attribute 'default nil :font "Monaco 12"))
(if window-system
    (progn
      (setq frame-title-format '(buffer-file-name "%f" ("%b")))
      (tooltip-mode -1)
      (mouse-wheel-mode t)
      (scroll-bar-mode -1))
  (menu-bar-mode -1))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(blink-cursor-mode 1)
(setq-default cursor-type '(bar . 2))
(delete-selection-mode 1)
(transient-mark-mode 1)
(show-paren-mode 1)
(column-number-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-screen t)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(remove-trailing-whitespace-mode)

(global-hl-line-mode t)
(set-face-background 'hl-line "#d6fffb")

(set-face-background 'mode-line "#d6fffb")
(setq visible-bell nil)
(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line))
              (orig-bg (face-background 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (set-face-background 'mode-line "#000000")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg bg)
                                 (set-face-foreground 'mode-line fg)
                                 (set-face-background 'mode-line bg))
                               orig-fg
                               orig-bg))))

(server-start)

;; Bootstrap `use-package'
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (add-to-list 'load-path (expand-file-name "vendor" user-emacs-directory)))

(require 'packages-cfg)

(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

(add-to-list 'auto-mode-alist '("\\.zcml$" . nxml-mode))

(setq latex-run-command "pdflatex")
(put 'narrow-to-region 'disabled nil)
