;; use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq         tab-width        4)
(setq         tab-stop-list    (number-sequence 4 120 4))

;; show columns
(column-number-mode 1)

;; move backups into .emacs.d/backups
(setq backup-directory-alist
      (list (cons "." (expand-file-name "backups" user-emacs-directory))))

;; use Ido
(ido-mode                      1)
(setq ido-everywhere           t)
(setq ido-enable-flex-matching t)

;; upgrade normal expansion to Hippie Expand
(global-set-key (kbd "M-/") 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

;; show matching paren, bracket, etc.
(show-paren-mode 1)

;; activate character pairing
(electric-pair-mode 1)
(global-set-key (kbd "'")
                (lambda () (interactive) (insert "'")))  ; don't pair ' anywhere
(add-hook 'ruby-mode-hook
          (lambda () (add-to-list (make-local-variable 'electric-pair-pairs)
                                  '(?| . ?|))))   ; do pair | in Ruby
(add-hook 'css-mode-hook
          (lambda () (add-to-list (make-local-variable 'electric-pair-pairs)
                                  '(?: . ?\;))))   ; pair : with ; in CSS
(add-hook 'markdown-mode-hook
          (lambda () (add-to-list (make-local-variable 'electric-pair-pairs)
                                  '(?` . ?`))))   ; do pair ` in Markdown

;; turn on autoindenting
(electric-indent-mode 1)

;; show junk whitespace
(setq whitespace-style '(face tabs trailing lines empty))
(setq whitespace-line-column jeg2s-wrap-limit)
(global-whitespace-mode 1)
(global-set-key (kbd "C-c SPC")
                (lambda ()
                  (interactive)
                  (untabify (point-min) (point-max))
                  (whitespace-cleanup)))

;; check spelling (requires:  brew install aspell --lang=en)
(add-hook 'text-mode-hook  ;; covers Markdown
          (lambda () (flyspell-mode 1)))
(setq jeg2s-skipped-markdown-faces
      '(markdown-pre-face markdown-reference-face markdown-url-face))
(defun jeg2s-markdown-mode-flyspell-verify ()
  (let ((f (get-text-property (point) 'face)))
    (not (memq f jeg2s-skipped-markdown-faces))))
(put 'markdown-mode 'flyspell-mode-predicate
     'jeg2s-markdown-mode-flyspell-verify)

(setq jeg2s-prog-spelled-modes
      '(css sh emacs-lisp html ruby))
(dolist (mode jeg2s-prog-spelled-modes)
  (add-hook (intern (concat (symbol-name mode) "-mode-hook"))
            (lambda () (flyspell-prog-mode))))

;; expand file type coverage
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$"  . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$"  . ruby-mode))
