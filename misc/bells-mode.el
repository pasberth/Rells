(eval-when-compile (require 'cl))

(defvar bells-mode-map
  (let ((map (make-sparse-keymap)))
    map)
  "Keymap used in Bells mode.")

(defconst bells-symbol-re "[^\\\s\\\n0-9][^\\\s\\\n]*")

(defconst bells-font-lock-keywords
  (list
     ;; functions
     (cons (concat "\\(?:^\\|[\\$\\. ]\\) *def +\\(" bells-symbol-re "\\)")
       '(1 font-lock-function-name-face))
     ;; Type
     (cons (concat "\\(?:^\\|[\\$\\. ]\\) *class +\\(" bells-symbol-re "\\)")
       '(1 font-lock-type-face))
     ;; Namespace
     (cons (concat "\\(?:^\\|[\\$\\. ]\\) *namespace +\\(" bells-symbol-re "\\)")
        '(1 font-lock-reference-face))
     ;; Variable
     (cons (concat "\\(?:^\\|[\\$\\. ]\\) *define +\\(" bells-symbol-re "\\)")
        '(1 font-lock-variable-name-face))
     ;; keywords
     (cons (concat
       " +\\("
       (regexp-opt '("$" "." "--")
         t)
        "\\) +")
      2)
     ;; keywords
     (cons (concat
       "\\(?:^\\|[\\$\\. ]\\) *\\("
       (regexp-opt
         '( "require"
            "array"
            "->"
            "macro"
            "define"
            "def"
            "object"
            "namespace"
            "class"
            "if"
            "while")
         t)
        "\\)\\(:?[\\\n ]\\) *")
      2)
     ;; singleton-objects
     '("\\<\\(nil\\|global\\|true\\|false\\)\\>"
       1 font-lock-variable-name-face)
     ;; funcall
     (cons (concat " *[\\$\\.] +\\(" bells-symbol-re "\\)")
       '(1 font-lock-function-name-face))
     ;; funcall
     (cons (concat "^ *\\(" bells-symbol-re "\\)")
       '(1 font-lock-function-name-face)))
    "Additional expressions to highlight in Bells mode.")


;;;###autoload
(defun bells-mode ()
  "test bells mode"
  (interactive)
  (kill-all-local-variables)
  (use-local-map bells-mode-map)
  (set (make-local-variable 'font-lock-defaults)
        '((bells-font-lock-keywords) nil nil))
  (set (make-local-variable 'font-lock-keywords)
        bells-font-lock-keywords)
  (setq mode-name "Bells"))

;;;###autoload
(add-to-list 'auto-mode-alist (cons (purecopy "\\.bells\\'") 'bells-mode))

(provide 'bells-mode)

;;; bells-mode.el ends here