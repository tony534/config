(defvar ido-enable-prefix nil)
(defvar ido-use-virtual-buffers t)
(defvar ido-enable-flex-matching t)
(defvar ido-create-new-buffer 'prompt)
(defvar ido-use-filename-at-point 'guess)
(defvar ido-save-directory-list-file (concat user-emacs-directory ".cache/ido.last"))

(require 'ido)
(ido-mode t)
(ido-everywhere t)

(require-package 'ido-ubiquitous)
(ido-ubiquitous-mode t)

(require-package 'flx-ido)
(flx-ido-mode t)

(require-package 'ido-vertical-mode)
(ido-vertical-mode)

(defvar smex-save-file (concat user-emacs-directory ".cache/smex-items"))
(require-package 'smex)
(require 'smex)
(smex-initialize)
(setq smex-history-length 100)

;; ido-enhanced imenu   http://www.emacswiki.org/emacs/ImenuMode#toc11
(defun ido-goto-symbol (&optional symbol-list)
      "Refresh imenu and jump to a place in the buffer using Ido."
      (interactive)
      (unless (featurep 'imenu)
        (require 'imenu nil t))
      (cond
       ((not symbol-list)
        (let ((ido-mode ido-mode)
              (ido-enable-flex-matching
               (if (boundp 'ido-enable-flex-matching)
                   ido-enable-flex-matching t))
              name-and-pos symbol-names position)
          (unless ido-mode
            (ido-mode 1)
            (setq ido-enable-flex-matching t))
          (while (progn
                   (imenu--cleanup)
                   (setq imenu--index-alist nil)
                   (ido-goto-symbol (imenu--make-index-alist))
                   (setq selected-symbol
                         (ido-completing-read "Symbol? " symbol-names))
                   (string= (car imenu--rescan-item) selected-symbol)))
          (unless (and (boundp 'mark-active) mark-active)
            (push-mark nil t nil))
          (setq position (cdr (assoc selected-symbol name-and-pos)))
          (cond
           ((overlayp position)
            (goto-char (overlay-start position)))
           (t
            (goto-char position)))))
       ((listp symbol-list)
        (dolist (symbol symbol-list)
          (let (name position)
            (cond
             ((and (listp symbol) (imenu--subalist-p symbol))
              (ido-goto-symbol symbol))
             ((listp symbol)
              (setq name (car symbol))
              (setq position (cdr symbol)))
             ((stringp symbol)
              (setq name symbol)
              (setq position
                    (get-text-property 1 'org-imenu-marker symbol))))
            (unless (or (null position) (null name)
                        (string= (car imenu--rescan-item) name))
              (add-to-list 'symbol-names name)
              (add-to-list 'name-and-pos (cons name position))))))))

(provide 'init-ido)
