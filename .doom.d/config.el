;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yuhang Guo"
      user-mail-address "guoyh01@gmail.com")

;; set org link shortcuts
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c C-l") 'org-insert-link)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-font (font-spec :family "Fira Code" :size 14))
;; (setq doom-theme 'doom-one)
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold nil    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(setq +doom-dashboard-menu-sections
  '(("Reload last session"
    :icon (all-the-icons-octicon "history" :face 'doom-dashboard-menu-title)
    :when (cond ((require 'persp-mode nil t)
                  (file-exists-p (expand-file-name persp-auto-save-fname persp-save-dir)))
                ((require 'desktop nil t)
                  (file-exists-p (desktop-full-file-name))))
    :face (:inherit (doom-dashboard-menu-title bold))
    :action doom/quickload-session)
    ("Open org-roam Daily"
     :icon (all-the-icons-octicon "squirrel" :face 'doom-dashboard-menu-title)
     :when (fboundp 'org-roam-dailies-find-today)
     :action org-roam-dailies-today)
    ("Recently opened files"
    :icon (all-the-icons-octicon "file-text" :face 'doom-dashboard-menu-title)
    :action recentf-open-files)
    ("Open project"
    :icon (all-the-icons-octicon "briefcase" :face 'doom-dashboard-menu-title)
    :action projectile-switch-project)
    ("Jump to bookmark"
    :icon (all-the-icons-octicon "bookmark" :face 'doom-dashboard-menu-title)
    :action bookmark-jump)
    ("Open documentation"
    :icon (all-the-icons-octicon "book" :face 'doom-dashboard-menu-title)
    :action doom/help)))

;; workspace configuration
;;   - do not create new workspace for each session
;;   https://github.com/hlissner/doom-emacs/issues/2202
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; disable writegood minor mood
(after! writegood-mode
  (writegood-mode -1))

;; ====================
;; insert date and time

(defvar current-date-time-format "%a %b %d %H:%M:%S %Z %Y"
  "Format of date to insert with `insert-current-date-time' func
See help of `format-time-string' for possible replacements")

(defvar current-time-format "%a %H:%M:%S"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun insert-current-date-time ()
  "insert the current date and time into current buffer.
Uses `current-date-time-format' for the formatting the date/time."
       (interactive)
;       (insert (let () (comment-start)))
       (insert (format-time-string current-date-time-format (current-time)))
       )

(defun insert-current-time ()
  "insert the current time (1-week scope) into the current buffer."
       (interactive)
       (insert (format-time-string current-time-format (current-time)))
       )

(global-set-key "\C-c\C-d" 'insert-current-date-time)
(global-set-key "\C-c\C-t" 'insert-current-time)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

(use-package org-bullets
  :ensure t
  :init
  (setq org-ellipsis "⚡⚡⚡")
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;; window / frame
(when IS-MAC
  (add-hook 'window-setup-hook #'toggle-frame-maximized))


;;; org-roam
(use-package! org-roam
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "~/Dropbox/org/roam")
      ;; (org-roam-link-title-format "%s")
      :config
      (org-roam-setup)
      (require 'org-roam-protocol))

;; for org-roam-buffer-toggle
;; Recommendation in the official manual
(add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                  (display-buffer-in-direction)
                  (direction . right)
                  (window-width . 0.33)
                  (window-height . fit-window-to-buffer)))


;; showing the number of backlinks for each node in org-roam-node-find
(cl-defmethod org-roam-node-directories ((node org-roam-node))
  (if-let ((dirs (file-name-directory (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (format "(%s)" (car (f-split dirs)))
    ""))

(cl-defmethod org-roam-node-backlinkscount ((node org-roam-node))
  (let* ((count (caar (org-roam-db-query
                       [:select (funcall count source)
                                :from links
                                :where (= dest $s1)
                                :and (= type "id")]
                       (org-roam-node-id node)))))
    (format "[%d]" count)))

(setq org-roam-node-display-template "${directories:10} ${tags:10} ${title:100} ${backlinkscount:6}")


;; custom roam key mapping
(map! :map org-roam-mode-map
;;       :leader "r l" #'org-roam
       :leader "r t a" #'org-transclusion-activate
       :leader "r t d" #'org-transclusion-deactivate
       :leader "r t e" #'org-transclusion-open-edit-src-buffer-at-point
       :leader "r t E" #'org-transclusion-open-src-buffer-at-point)

(custom-set-faces!
  `(org-roam-link :foreground "yellow2"))

(map! :leader "d d d" #'org-roam-dailies-find-today)

;;; DEVONthink link in Org
;;; from https://discourse.devontechnologies.com/t/org-mode-emacs-support/22396/6
(require 'org)

(defun org-dtp-open (record-location)
  "Visit the dtp message with the given Message-ID."
  (shell-command (concat "open x-devonthink-item:" record-location)))

(org-link-set-parameters
 "x-devonthink-item"
 :follow 'org-dtp-open
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "<font color=\"red\"> <a href=\"x-devonthink-item:%s\">%s </a> </font>"
                     path
                     desc))
            ((eq 'md backend)
             (format "[%s](x-devonthink-item:%s)"
                     desc
                     path))))
 :face '(:foreground "red")
 :help-echo "Click me for devonthink link.")

(provide 'org-devonthink)

;;; org-download
(require 'org-download)
;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)
(setq-default org-download-image-dir "./media")
(setq org-image-actual-width nil)

;;; org-mode code highlight
(setq org-src-fontify-natively t)


;;; org-roam save update time after modifying files
;;; org-roam-templates
(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         #'org-roam-capture--get-point
         "* %?"
         :file-name "daily/%<%Y-%m-%d>"
         :head "#+title: %<%Y-%m-%d>\n#+roam_tags: daily-note\n\n")))

(setq org-roam-capture-templates
      '(("d" "Default" plain (function org-roam--capture-get-point)
             :file-name "%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+CREATED_AT: %U\n"
             :immediate-finish f)
        ("o" "On Java 8" plain (function org-roam--capture-get-point)
             "%[~/Dropbox/org/roam/templates/onjava8]"
             :file-name "%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+CREATED_AT: %U\n"
             :unnarrowed t)
        ("i" "amazon" plain (function org-roam--capture-get-point)
             :file-name "%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+ROAM_TAGS:amz\n#+CREATED_AT: %U\n"
             :immediate-finish t)
        ("a" "Algorithm" plain (function org-roam--capture-get-point)
             :file-name "algorithm/%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+ROAM_TAGS:algorithm\n#+CREATED_AT: %U\n"
             :unnarrowed t)
        ("l" "Leetcode" plain (function org-roam--capture-get-point)
             "%[~/Dropbox/org/roam/templates/leetcode]"
             :file-name "algorithm/leetcode/%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+ROAM_TAGS:algorithm leetcode\n#+CREATED_AT: %U\n"
             :unnarrowed t)
        ))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (org-roam))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-roam-link ((t (:foreground "yellow2")))))

;; org-transclusion
(use-package org-transclusion
  :after org-roam
  :load-path "site-lisp/org-transclusion"
  :hook ((org-mode . org-transclusion-mode))
  :custom
  (org-transclusion-activate-persistent-message nil))

;; org-roam-graph
(setq org-roam-graph-viewer
    (lambda (file)
      (let ((org-roam-graph-viewer "open"))
        (org-roam-graph--open (concat "-a Safari " file)))))
;; (use-package org-roam-server
;;   :ensure t
;;   :config
;;   (setq org-roam-server-host "127.0.0.1"
;;         org-roam-server-port 7779
;;         org-roam-server-authenticate nil
;;         org-roam-server-export-inline-images t
;;         org-roam-server-serve-files nil
;;         org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
;;         org-roam-server-network-poll t
;;         org-roam-server-network-arrows nil
;;         org-roam-server-network-label-truncate t
;;         org-roam-server-network-label-truncate-length 60
        ;; org-roam-server-network-label-wrap-length 20))

(defun my-org-protocol-focus-advice (orig &rest args)
  (x-focus-frame nil)
  (apply orig args))

(advice-add 'org-roam-protocol-open-ref :around
            #'my-org-protocol-focus-advice)
(advice-add 'org-roam-protocol-open-file :around
            #'my-org-protocol-focus-advice)

; https://github.com/org-roam/org-roam-server/issues/115
;; (defun org-roam-server-open ()
;;     "Ensure the server is active, then open the roam graph."
;;     (interactive)
;;     (smartparens-global-mode -1)
;;     (org-roam-server-mode 1)
;;    (smartparens-global-mode 1))

;; automatically enable server-mode
;; (after! org-roam
;;   (smartparens-global-mode -1)
;;   (org-roam-server-mode)
  ;; (smartparens-global-mode 1))

; https://github.com/org-roam/org-roam-server/issues/75
;(unless (server-running-p)
;  (org-roam-server-open))
;(org-roam-server-mode)

;; interleave, org-noter
;;(use-package interleave
;;  :defer t
;;  :bind ("C-x i" . interleave-mode)
;;  :config
;;  (setq interleave-disable-narrowing t))
;;(defun widen-interleave-org-buffer ()
;;  (with-current-buffer interleave-org-buffer
;;    (widen)))
;;(add-hook 'interleave-mode-hook #'widen-interleave-org-buffer)
(setq org-noter-property-doc-file "INTERLEAVE_PDF"
      org-noter-property-note-location "INTERLEAVE_PAGE_NOTE")

;; org-mind-map
(require 'ox-org)
(require 'org-mind-map)
(setq org-mind-map-engine "dot")

;; ox-hugo
(use-package ox-hugo
  :after org)

;; org-fc
(use-package org-fc
  :custom (org-fc-directories '("~/Dropbox/org/roam"))
  :config
  (require 'org-fc-hydra))

(map! :leader :desc "flip card" "l l" #'org-fc-review-flip)
(map! :leader :desc "quit review" "l q" #'org-fc-review-quit)
(map! :leader :desc "edit review" "l e" #'org-fc-review-edit)

(map! :leader :desc "rate good" "l g" #'org-fc-review-rate-good)
(map! :leader :desc "rate again" "l a" #'org-fc-review-rate-again)
(map! :leader :desc "rate hard" "l h" #'org-fc-review-rate-hard)
(map! :leader :desc "rate easy" "l e" #'org-fc-review-rate-easy)

;; beancount
;(add-to-list 'auto-mode-alist '("\\.bean\\'" . beancount-mode))


;; scheme
(setq scheme-program-name "chez")
(setq geiser-chez-binary "chez")
(setq geiser-active-implementations '(chez))


;; hide properties
(defun org-cycle-hide-drawers (state)
  "Re-hide all drawers after a visibility state change."
  (when (and (derived-mode-p 'org-mode)
             (not (memq state '(overview folded contents))))
    (save-excursion
      (let* ((globalp (memq state '(contents all)))
             (beg (if globalp
                    (point-min)
                    (point)))
             (end (if globalp
                    (point-max)
                    (if (eq state 'children)
                      (save-excursion
                        (outline-next-heading)
                        (point))
                      (org-end-of-subtree t)))))
        (goto-char beg)
        (while (re-search-forward org-drawer-regexp end t)
          (save-excursion
            (beginning-of-line 1)
            (when (looking-at org-drawer-regexp)
              (let* ((start (1- (match-beginning 0)))
                     (limit
                       (save-excursion
                         (outline-next-heading)
                           (point)))
                     (msg (format
                            (concat
                              "org-cycle-hide-drawers:  "
                              "`:END:`"
                              " line missing at position %s")
                            (1+ start))))
                (if (re-search-forward "^[ \t]*:END:" limit t)
                  (outline-flag-region start (point-at-eol) t)
                  (user-error msg))))))))))

;;; https://github.com/org-roam/org-roam/wiki/User-contributed-Tricks
;(require 'time-stamp)
;(add-hook 'write-file-functions 'time-stamp) ; update when saving


(set-input-method nil)
(use-package! rime
  :bind
  (:map rime-active-mode-map
   ("<tab>" . #'rime-inline-ascii))
  (:map rime-mode-map
   ("M-j" . #'rime-force-enable))
  :hook
  ((after-init kill-emacs) . (lambda ()
                               (when (fboundp 'rime-lib-sync-user-data)
                                 (ignore-errors (rime-sync)))))
  :config
  ;(setq default-input-method "rime"
  (setq rime-user-data-dir (expand-file-name "~/.local/emacs-rime")
        rime-show-candidate 'message
        rime-inline-ascii-trigger 'shift-l)

  ;(add-hook! (org-mode)
  ;  (activate-input-method default-input-method))

  (defun +rime-force-enable ()
    "[ENHANCED] Force into Chinese input state.
If current input method is not `rime', active it first. If it is
currently in the `evil' non-editable state, then switch to
`evil-insert-state'."
    (interactive)
    (let ((input-method "rime"))
      (unless (string= current-input-method input-method)
        (activate-input-method input-method))
      (when (rime-predicate-evil-mode-p)
        (if (= (1+ (point)) (line-end-position))
            (evil-append 1)
          (evil-insert 1)))
      (rime-force-enable)))

  (unless (fboundp 'rime--posframe-display-content)
    (error "Function `rime--posframe-display-content' is not available."))
  (defadvice! +rime--posframe-display-content-a (args)
    "给 `rime--posframe-display-content' 传入的字符串加一个全角空
格，以解决 `posframe' 偶尔吃字的问题。"
    :filter-args #'rime--posframe-display-content
    (cl-destructuring-bind (content) args
      (let ((newresult (if (string-blank-p content)
                           content
                         (concat content "　"))))
        (list newresult)))))

(setq rime-disable-predicates
      '(
        ; 在 evil-mode 的非编辑状态下
        rime-predicate-evil-mode-p
        ; 在英文字符串之后（必须为以字母开头的英文字符串）
        rime-predicate-after-alphabet-char-p
        ; 在 prog-mode 和 conf-mode 中除了注释和引号内字符串之外的区域
        rime-predicate-prog-in-code-p
        ; 在代码的字符串中，不含注释的字符串
        rime-predicate-in-code-string-p
        ; 当要在中文字符且有空格之后输入符号时
        rime-predicate-punctuation-after-space-cc-p
        ; 当要在任意英文字符之后输入符号时
        rime-predicate-punctuation-after-ascii-p
        ; 在行首要输入符号时
        rime-predicate-punctuation-line-begin-p
        ; 在中文字符且有空格之后
        rime-predicate-space-after-cc-p
        ; 将要输入的为大写字母时
        rime-predicate-current-uppercase-letter-p
        ))
(setq rime-inline-predicates
      '(
        ; 在英文字符串之后（必须为以字母开头的英文字符串）
        rime-predicate-after-alphabet-char-p
        ; 在 prog-mode 和 conf-mode 中除了注释和引号内字符串之外的区域
        rime-predicate-prog-in-code-p
        ; 在代码的字符串中，不含注释的字符串
        rime-predicate-in-code-string-p
        ; 当要在中文字符且有空格之后输入符号时
        rime-predicate-punctuation-after-space-cc-p
        ; 当要在任意英文字符之后输入符号时
        rime-predicate-punctuation-after-ascii-p
        ; 在行首要输入符号时
        rime-predicate-punctuation-line-begin-p
        ; 在中文字符且有空格之后
        rime-predicate-space-after-cc-p
        ; 将要输入的为大写字母时
        rime-predicate-current-uppercase-letter-p
        ))
