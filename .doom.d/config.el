;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
                     desc))))
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
             :head "#+TITLE: ${title}\n#+CREATED_AT: %U\nTime-stamp: []\n"
             :immediate-finish t)
        ("i" "Default-Intern" plain (function org-roam--capture-get-point)
             :file-name "intern/%<%Y%m%d%H%M%S>-${slug}"
             :head "#+TITLE: ${title}\n#+ROAM_TAGS:amz\n#+CREATED_AT: %U\nTime-stamp: <>\n"
             :immediate-finish t)
        ("j" "Daily Note" plain (function org-roam--capture-get-point)
             "%[~/org/roam/templates/daily]"
             :file-name "%<%Y-%m-%d>"
             :head "#+TITLE: %<%Y-%m-%d>\n#+CREATED_AT: %U\nTime-stamp: <>\n\n"
             :unnarrowed t)
        ))
