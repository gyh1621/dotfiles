;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
  (load-theme 'doom-tomorrow-night t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

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
      (org-roam-directory "~/org/roam")
      (org-roam-link-title-format "%s")
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n j" . org-roam-jump-to-index)
               ("C-c n b" . org-roam-switch-to-buffer)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))))

(custom-set-faces!
  `(org-roam-link :foreground "yellow2"))

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
;;; https://github.com/org-roam/org-roam/wiki/User-contributed-Tricks
(require 'time-stamp)
(add-hook 'write-file-functions 'time-stamp) ; update when saving

;;; org-roam-templates
(setq org-roam-capture-templates
      '(("d" "Default" plain (function org-roam--capture-get-point)
             :file-name "%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+CREATED_AT: %U\nTime-stamp: <>\n"
             :immediate-finish f)
        ("i" "Intern" plain (function org-roam--capture-get-point)
             :file-name "intern/%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+ROAM_TAGS:amz\n#+CREATED_AT: %U\nTime-stamp: <>\n"
             :immediate-finish t)
        ("a" "Algorithm" plain (function org-roam--capture-get-point)
             :file-name "algorithm/%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+ROAM_TAGS:algorithm\n#+CREATED_AT: %U\nTime-stamp: <>\n"
             :unnarrowed t)
        ("l" "Leetcode" plain (function org-roam--capture-get-point)
             "%[~/org/roam/templates/leetcode]"
             :file-name "algorithm/leetcode/%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+ROAM_TAGS:algorithm leetcode\n#+CREATED_AT: %U\nTime-stamp: <>\n"
             :unnarrowed t)
        ("j" "Daily Note" plain (function org-roam--capture-get-point)
             "%[~/org/roam/templates/daily]"
             :file-name "%<%Y-%m-%d>"
             :head "#+TITLE: %<%Y-%m-%d>\n#+CREATED_AT: %U\nTime-stamp: <>\n\n"
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

;; org-roam-graph
(setq org-roam-graph-viewer
    (lambda (file)
      (let ((org-roam-graph-viewer "open"))
        (org-roam-graph--open (concat "-a Safari " file)))))
(use-package org-roam-server
  :ensure t
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))

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

;; beancount
(add-to-list 'auto-mode-alist '("\\.bean\\'" . beancount-mode))


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
