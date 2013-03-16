(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(add-to-list 'load-path "/Users/andy/.emacs.d")
(add-to-list 'load-path "/Users/andy/code/git-emacs")
(require 'git)
(require 'git-blame)
(require 'egg)

(put 'narrow-to-region 'disabled nil)

(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/color-theme-solarized-20121209.1204")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes (quote ("1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(inhibit-startup-screen t)
 '(large-file-warning-threshold nil)
 '(scroll-bar-mode nil))

(put 'downcase-region 'disabled nil)
(setq truncate-partial-width-windows nil)

;; Mac OS X stuff
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

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

(tool-bar-mode 0)
(load-theme 'solarized-dark t)

(if (eq system-type 'windows-nt)
    ;; When running in Windows, we want to use an alternate shell so we
    ;; can be more unixy.
    (setq shell-file-name "C:/MinGW/msys/1.0/bin/bash")
  (setq explicit-shell-file-name shell-file-name)
  (setenv "PATH"
          (concat ".:/usr/local/bin:/mingw/bin:/bin:"
           (replace-regexp-in-string " " "\\\\ "
            (replace-regexp-in-string "\\\\" "/"
             (replace-regexp-in-string "\\([A-Za-z]\\):" "/\\1"
              (getenv "PATH"))))))
)

(if (eq system-type 'darwin)
 (setq exec-path
       (quote ("/usr/bin"
               "/bin"
               "/usr/sbin"
               "/sbin"
               "/Applications/Emacs.app/Contents/MacOS/bin"
               "/Users/andy/yagarto-4.7.1/bin"
               "/usr/local/bin")))
 (setq gud-gdb-command-name "arm-none-eabi-gdb -i=mi")
)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 113 :width normal)))))
