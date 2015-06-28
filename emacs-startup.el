(tool-bar-mode -1)
;;(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq split-height-threshold nil)

(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(add-to-list 'load-path (concat user-init-file ".d/lisp"))
(add-to-list 'load-path "/Volumes/Users/andy/code/git-emacs")
(require 'git)
(require 'git-blame)
(require 'egg)
(require 'package)

;; Add the original Emacs Lisp Package Archive
(add-to-list 'package-archives '("elpa"      . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("melpa"     . "http://melpa.org/packages/") t)
;; Add the user-contributed repository
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))


(put 'narrow-to-region 'disabled nil)


(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(when (memq window-system '(mac ns))
  (set-exec-path-from-shell-PATH))

;; Junk for Python
(require 'highlight-indentation)

(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/color-theme-solarized-20121209.1204")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes (quote ("1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))

 '(exec-path (quote ("/opt/local/bin"
                     "/usr/bin"
                     "/bin"
                     "/usr/sbin"
                     "/sbin"
                     "/usr/local/bin"
                     "/Applications/Emacs.app/Contents/MacOS/bin"
                     "/usr/local/arm/gcc-arm-none-eabi-4_7-2013q3/bin")))
 '(gud-gdb-command-name "arm-none-eabi-gdb -i=mi")
 '(inhibit-startup-screen t)
 '(large-file-warning-threshold nil)
 '(scroll-bar-mode nil))

(put 'downcase-region 'disabled nil)
(setq truncate-partial-width-windows nil)

;; Mac OS X stuff
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; look for C++ headers
(setq magic-mode-alist
  (append (list  
       '("\\(.\\|\n\\)*\n[ ]*class" . c++-mode)
       '("\\(.\\|\n\\)*\n[ ]*namespace" . c++-mode))
      magic-mode-alist))


;;(require 'helm-config)

;;(global-set-key (kbd "C-:") 'ac-complete-with-helm)
;;(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)
;;(global-set-key (kbd "C-x C-f") 'helm-find-files)

;;(require 'helm-match-plugin)

;; By an unknown contributor
(require 'whitespace)
(setq whitespace-style '(face empty lines-tail trailing))

(require 'fill-column-indicator)
(defvar auto-minor-mode-alist
  '(("\\.c\\'"  . fci-mode)
    ("\\.cc\\'" . fci-mode)
    ("\\.h\\'"  . fci-mode)

    ("\\.c\\'"  . whitespace-mode)
    ("\\.cc\\'" . whitespace-mode)
    ("\\.c\\'"  . whitespace-mode)
)
  "Alist of filename patterns vs correpsonding minor mode functions, see `auto-mode-alist'
All elements of this alist are checked, meaning you can enable multiple minor modes for the same regexp.")

(package-initialize)

(defun enable-minor-mode-based-on-extension ()
  "check file name against auto-minor-mode-alist to enable minor modes
the checking happens for all pairs in auto-minor-mode-alist"
  (when buffer-file-name
    (let ((name buffer-file-name)
          (remote-id (file-remote-p buffer-file-name))
          (alist auto-minor-mode-alist))
      ;; Remove backup-suffixes from file name.
      (setq name (file-name-sans-versions name))
      ;; Remove remote file name identification.
      (when (and (stringp remote-id)
                 (string-match-p (regexp-quote remote-id) name))
        (setq name (substring name (match-end 0))))
      (while (and alist (caar alist) (cdar alist))
        (if (string-match (caar alist) name)
            (funcall (cdar alist) 1))
        (setq alist (cdr alist))))))

(add-hook 'find-file-hook 'enable-minor-mode-based-on-extension)

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode) (ggtags-mode 1))))

(setq fci-rule-color "darkblue")
(setq-default fci-rule-column 80)
;;(setq fill-column 80)

(global-set-key "%" 'match-paren)
          
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

(defun my-bell-function ()
  (unless (memq this-command
    	'(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

(load-theme 'solarized-dark t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'ecb)
;;(require 'ecb-autoloads)
(setq ecb-compile-window-height 12)

;; Alex Schroeder [http://www.emacswiki.org/cgi-bin/wiki/OccurBuffer]
(defun isearch-occur ()
  "*Invoke `occur' from within isearch."
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

(global-set-key (kbd "C-x g") 'magit-status)
