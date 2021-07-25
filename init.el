;;; Package --- Summary
;;; Commentary:
;;; Code:

;; Always load newest byte code
(setq load-prefer-newer t)

; 2021-07-25 - Cask och Emacs uppgradering ger varning
;; Warning (package): Unnecessary call to ‘package-initialize’ in init file [2 times]
; Efter debuggning, så ligger buggen i Cask boot-strap fil
;;; Debug
;(debug-on-entry 'package-initialize)
;; Disbla varningen så länge
(setq warning-suppress-log-types '((package reinitialization)))


(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  ; 2021-07-25, a warning is triggered that package-initialize is run twice
  ;;(package-initialize)
)

(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-echo-area-message t)

(require 'org)
(org-babel-load-file
(expand-file-name "settings.org"
                  user-emacs-directory))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "68d36308fc6e7395f7e6355f92c1dd9029c7a672cbecf8048e2933a053cf27e6" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(doc-view-continuous t)
 '(flymake-cppcheck-enable "warning,performance,information,style")
 '(ledger-reports
   (quote
    (("U" "ledger -f 2016.ledger")
     ("Utgifter" "ledger ")
     ("2016.ledger" "ledger ")
     ("jonix" "ledger -f 2016.ledger report")
     ("frotz" "ledger ")
     ("bal" "ledger -f %(ledger-file) bal")
     ("reg" "ledger -f %(ledger-file) reg")
     ("payee" "ledger -f %(ledger-file) reg @%(payee)")
     ("account" "ledger -f %(ledger-file) reg %(account)"))))
 '(package-selected-packages
   (quote
    (tidy jedi jedi-core jedi-direx flycheck flycheck-cask flycheck-clang-analyzer flycheck-ledger writegood-mode muse ctags-update company-rtags company-auctex buffer-move browse-kill-ring better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))
(put 'upcase-region 'disabled nil)

;(provide init)
;;; init.el ends here
