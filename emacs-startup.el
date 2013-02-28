(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(add-to-list 'load-path "/Users/andy/.emacs.d")
(add-to-list 'load-path "/Users/andy/code/git-emacs")
(require 'git)
(require 'git-blame)
(require 'egg)

(put 'narrow-to-region 'disabled nil)

;; junk for ruby
(add-to-list 'load-path "~/.emacs.d/ruby")
(autoload 'ruby-mode "ruby-mode"
    "Mode for editing ruby source files")
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(autoload 'run-ruby "inf-ruby"
    "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
    "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
    '(lambda ()
        (inf-ruby-keys)))
;; If you have Emacs 19.2x or older, use rubydb2x                              
(autoload 'rubydb "rubydb3x" "Ruby debugger" t)
;; uncomment the next line if you want syntax highlighting                     
(add-hook 'ruby-mode-hook 'turn-on-font-lock)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(exec-path (quote ("/usr/bin" "/bin" "/usr/sbin" "/sbin" "/Applications/Emacs.app/Contents/MacOS/bin" "/Users/andy/yagarto-4.7.1/bin" "/usr/local/bin")))
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

(load-theme 'tango-dark)
(tool-bar-mode 0)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
