;; [[file:~/.spacemacs.d/spacemacs.org::*Misc][Misc:1]]
(use-package magithub
  :after magit
  :config (magithub-feature-autoinject t))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package org-recur
  :hook ((org-mode . org-recur-mode)
         (org-agenda-mode . org-recur-agenda-mode))
  :demand t
  :config
  (define-key org-recur-mode-map (kbd "C-c d") 'org-recur-finish)
;; Misc:1 ends here

;; [[file:~/.spacemacs.d/spacemacs.org::*Ivy][Ivy:1]]
(setq ivy-re-builders-alist
      '((swiper . ivy--regex-plus)
        (t      . ivy--regex-fuzzy)))
;; Ivy:1 ends here

;; [[file:~/.spacemacs.d/spacemacs.org::*Appearance][Appearance:1]]
;; ;; Don't let me accidentally edit in invisible areas.
;; (setq org-catch-invisible-edit 'show-and-error)

;; In lists, use letters in addition to bullets and numbers
(setq org-list-allow-alphabetical t)

;; http://www.howardism.org/Technical/Emacs/orgmode-wordprocessor.html
(setq org-hide-emphasis-markers t)

;; (let*
;;     ;; ((variable-tuple (cond ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;;     ;;                         ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
;;     ;;                         ((x-list-fonts "Verdana")         '(:font "Verdana"))
;;     ;;                         ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
;;     ;;                         (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
;;     ;;   (base-font-color     (face-foreground 'default nil 'default))
;;     ;;   (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

;;   (custom-theme-set-faces 'user
;;                           `(org-level-8 ((t (,@headline ,@variable-tuple))))
;;                           `(org-level-7 ((t (,@headline ,@variable-tuple))))
;;                           `(org-level-6 ((t (,@headline ,@variable-tuple))))
;;                           `(org-level-5 ((t (,@headline ,@variable-tuple))))
;;                           `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
;;                           `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
;;                           `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
;;                           `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
;;                           `(org-document-title ((t (,@headline ,@variable-tuple :height 1.5 :underline nil))))))
;; Appearance:1 ends here

;; [[file:~/.spacemacs.d/spacemacs.org::*Agenda][Agenda:1]]
;; Rebind the 'd' key in org-agenda (default: `org-agenda-day-view').
  (define-key org-recur-agenda-mode-map (kbd "d") 'org-recur-finish)
  (define-key org-recur-agenda-mode-map (kbd "C-c d") 'org-recur-finish)

  (setq org-recur-finish-done t
        org-recur-finish-archive t))

;; Here are some org-mode settings that work well in conjunction with org-recur.

;; Refresh the org-agenda whenever a task is rescheduled:

;; Refresh org-agenda after rescheduling a task.
(defun org-agenda-refresh ()
  "Refresh all `org-agenda' buffers."
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when (derived-mode-p 'org-agenda-mode)
        (org-agenda-maybe-redo)))))

(defadvice org-schedule (after refresh-agenda activate)
  "Refresh org-agenda."
  (org-agenda-refresh))

;; Keep the task metadata clean:

;; Log time a task was set to Done.
(setq org-log-done (quote time))

;; Don't log the time a task was rescheduled or redeadlined.
(setq org-log-redeadline nil)
(setq org-log-reschedule nil)

;;Prefer rescheduling to future dates and times:

(setq org-read-date-prefer-future 'time)

;; https://www.tompurl.com/2015-12-29-emacs-eisenhower-matrix.html
(setq org-tag-alist '(("important" . ?i)
		                  ("urgent"    . ?u)))

(setq org-agenda-custom-commands
      '(("1" "Q1" tags-todo "+important+urgent")
        ("2" "Q2" tags-todo "+important-urgent")
        ("3" "Q3" tags-todo "-important+urgent")
        ("4" "Q4" tags-todo "-important-urgent")))
;; Agenda:1 ends here

;; [[file:~/.spacemacs.d/spacemacs.org::*Haskell][Haskell:1]]
;; [TODO] Better implementation of this is in ess-mode. Steal it.
(general-evil-define-key 'insert haskell-mode-map
  "s-i"   "<SPC>-> <SPC>"
  "M-s-^" "<SPC>=> <SPC>"
  ;; [TODO] append space.
  "s-["   "<SPC><-"
  "M-s-“" "<SPC><=")

(add-hook 'org-mode-hook '(lambda ()
                            (visual-line-mode)
                            (org-indent-mode)))
;; Haskell:1 ends here

;; [[file:~/.spacemacs.d/spacemacs.org::*Easy%20Templates][Easy Templates:1]]
(add-to-list 'org-structure-template-alist
  '("u" . "src emacs-lisp :tangle user-config.el"))
;; Easy Templates:1 ends here

;; [[file:~/.spacemacs.d/spacemacs.org::*Key%20bindings][Key bindings:1]]
(general-define-key
 ;; Open a new line below in insert mode.
 :keymaps 'insert
 "C-<return>" "<escape>o")
;; Key bindings:1 ends here

;; [[file:~/.spacemacs.d/spacemacs.org::*Appearance][Appearance:1]]
;; Show matching parens.
;; Delay and other options: https://www.emacswiki.org/emacs/ShowParenMode
(show-paren-mode 1)
(setq show-paren-delay 0)
(set-face-background 'show-paren-match (face-background 'default))
(set-face-foreground 'show-paren-match "#def")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;; Visual line navigation everywhere.
(global-visual-line-mode 1)
(general-define-key
 :keymaps 'normal
 "j" 'evil-next-visual-line
 "k" 'evil-previous-visual-line)

;; Word wrap, but when killing, kill to end of unwrapped line.
;; This allows appears to handle j/k by line number, rather than line end.
(setq-default word-wrap t)
;; Appearance:1 ends here

;; [[file:~/.spacemacs.d/spacemacs.org::*Sensitive%20data][Sensitive data:1]]
(define-minor-mode sensitive-minor-mode
  "For sensitive files like password lists.
   It disables backup creation and auto saving.

   With no argument, this command toggles the mode.
   Non-null prefix argument turns on the mode.
   Null prefix argument turns off the mode."
  ;; The initial value.
  nil
  ;; The indicator for the mode line.
  " Sensitive"
  ;; The minor mode bindings.
  nil
  (if (symbol-value sensitive-mode)
      (progn
	      ;; disable backups
	      (set (make-local-variable 'backup-inhibited) t)	
	      ;; disable auto-save
	      (if auto-save-default
	          (auto-save-mode -1)))
                                      ;resort to default value of backup-inhibited
    (kill-local-variable 'backup-inhibited)
                                      ;resort to default auto save setting
    (if auto-save-default
	      (auto-save-mode 1))))
;; Sensitive data:1 ends here

;; [[file:~/.spacemacs.d/spacemacs.org::*Find%20this%20file][Find this file:1]]
(defun spacemacs/find-config-file ()
  (interactive)
  (find-file (concat dotspacemacs-directory "/spacemacs.org")))

(spacemacs/set-leader-keys "fes" 'spacemacs/find-config-file)
;; Find this file:1 ends here
