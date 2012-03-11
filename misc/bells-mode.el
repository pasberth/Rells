(eval-when-compile (require 'cl))

(defvar bells-mode-map
  (let ((map (make-sparse-keymap)))
    map)
  "Keymap used in Bells mode.")

(defconst bells-font-lock-keywords
  (list
   ;; functions
   '("^\\s *def\\s +\\([^( \t\n]+\\)"
     1 font-lock-function-name-face)
   ;; keywords
   (cons (concat
          "\\("
          (regexp-opt
           '("require"
             "array"
             "->"
             "$"
             "."
             "--"
             "macro"
             "define"
             "def"
             "object"
             "namespace"
             "class"
             "if"
             "while")
           t)
          "\\)")
         2))
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