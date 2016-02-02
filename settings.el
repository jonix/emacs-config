
;; Personal modules outside of Melpa
(add-to-list 'load-path "~/.emacs.d/personal")

(add-hook 'after-save-hook
  'executable-make-buffer-file-executable-if-script-p)

(require 'cask "~/.cask/cask.el")
(cask-initialize)
;; # Update package depandancy list in ~/.emacs.d/Cask file
;; # To manually install dependencies
;; # Run from .emacs.d folder cask install
;; # (To setup cask run cask init from .emacs.d directory)

(require 'better-defaults)

; (load-theme 'solarized-dark t)
(load-theme 'zenburn t)

(menu-bar-mode -1)

(require 'smex)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Font size
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Enable recent-file
(require 'recentf)

;; get rid of `find-file-read-only' and replace it with something more useful.
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)

;; enable recent files mode.
(recentf-mode t)

; 64 files ought to be enough for everyone ;-)
(setq recentf-max-saved-items 64)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

;; Disable Prelude whitespace marking
;; (setq prelude-whitespace nil)

(setq whitespace-cleanup-mode t)

;; Enable to store window configuration
(winner-mode 1)

;; Enable God mode (avoid pressing Ctrl key all the time)
;; Enters a special mode
(require 'god-mode)

(defun my-update-cursor ()
  (setq cursor-type (if (or god-local-mode buffer-read-only)
                      'bar
                      'box)))
(add-hook 'god-mode-enabled-hook 'my-update-cursor)
(add-hook 'god-mode-disabled-hook 'my-update-cursor)

;; Make a tweak to split windows using God-mode
(global-set-key (kbd "C-x C-1") 'delete-other-windows)
(global-set-key (kbd "C-x C-2") 'split-window-below)
(global-set-key (kbd "C-x C-3") 'split-window-right)
(global-set-key (kbd "C-x C-0") 'delete-window)
;; Enable repeat
(define-key god-local-mode-map (kbd ".") 'repeat)

;; Enable God-mode on isearch
;(require 'god-mode-isearch)
;(define-key isearch-mode-map (kbd "<escape>") 'god-mode-isearch-activate)
;(define-key god-mode-isearch-map (kbd "<escape>") 'god-mode-isearch-disable)

;; Bind Caps-lock to M-x under GNU/Linux
;; From http://emacs-fu.blogspot.se/2008/12/remapping-caps-lock.html
(if (eq system-type 'gnu/linux)
    ;(shell-command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'")
  ;; Requires the bash command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'" to be run prior to this binding
  (global-set-key [f13] 'god-mode-all)
)

;; Bind Caps-lock to M-x For Windows
(if (eq system-type 'windows-nt)
    (setq w32-enable-caps-lock nil)
    ;(global-set-key [capslock] 'god-local-mode)
    (global-set-key [capslock] 'god-mode-all)
)

;;; Calender stuff

;; Add week number to Emacs calender
(copy-face font-lock-constant-face 'calendar-iso-week-face)
(set-face-attribute 'calendar-iso-week-face nil
                    :height 0.7)
(setq calendar-intermonth-text
      '(propertize
        (format "%2d"
                (car
                 (calendar-iso-from-absolute
                  (calendar-absolute-from-gregorian (list month day year)))))
        'font-lock-face 'calendar-iso-week-face))

;; End of calender stuff

;; Insert date at current position
(defun jx/current-date () (interactive)
    (insert (shell-command-to-string "echo -n $(date +%Y-%m-%d)")))

;; Insert time at current position
(defun jx/current-time () (interactive)
 (insert (shell-command-to-string "echo -n $(date +%H:%M)")))

;; Show clock in status-bar
(setq display-time t
      display-time-24hr-format t)
(display-time)

(which-key-mode)

;; Use this to automatically google thing at point
;; Shortcut is C-c / g
(require 'google-this)
(google-this-mode 1)

;; Use this to automatically translate a word or a phrase
;; Shortcut is C-ct
(require 'google-translate)
(require 'google-translate-smooth-ui)
(global-set-key "\C-ct" 'google-translate-smooth-translate)

;; Enable multiple-curors....CRAZY STUFF... http://emacsrocks.com/e13.html
(require 'multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;; End multiplce cursor

;; Avoid weaselwords in bread-text when writing thesis and other articles
(require 'writegood-mode)
(global-set-key "\C-cg" 'writegood-mode)

(require 'muse-mode)     ; load authoring mode
(require 'muse-html)     ; load publishing styles
(require 'muse-latex)
(require 'muse-texinfo)
(require 'muse-docbook)
(require 'muse-project)  ; publish files in projects

;; Muse project named website, publishes to folder public_html
(setq muse-project-alist
      '(("website" ("~/Pages" :default "index")
         (:base "html" :path "~/public_html")
         (:base "pdf" :path "~/public_html/pdf"))))

;;; Super-smart Capitalization
;;;
;;; Experimental (need to test it out)
;;;
;; From http://endlessparentheses.com/super-smart-capitalization.html
;; Capitalize word, take in respect sentence construction
(defun endless/convert-punctuation (rg rp)
  "Look for regexp RG around point, and replace with RP.
Only applies to text-mode."
  (let ((f "\\(%s\\)\\(%s\\)")
        (space "?:[[:blank:]\n\r]*"))
    ;; We obviously don't want to do this in prog-mode.
    (if (and (derived-mode-p 'text-mode)
             (or (looking-at (format f space rg))
                 (looking-back (format f rg space))))
        (replace-match rp nil nil nil 1))))

(defun endless/capitalize ()
  "Capitalize region or word.
Also converts commas to full stops, and kills
extraneous space at beginning of line."
  (interactive)
  (endless/convert-punctuation "," ".")
  (if (use-region-p)
      (call-interactively 'capitalize-region)
    ;; A single space at the start of a line:
    (when (looking-at "^\\s-\\b")
      ;; get rid of it!
      (delete-char 1))
    (call-interactively 'subword-capitalize)))

(defun endless/downcase ()
  "Downcase region or word.
Also converts full stops to commas."
  (interactive)
  (endless/convert-punctuation "\\." ",")
  (if (use-region-p)
      (call-interactively 'downcase-region)
    (call-interactively 'subword-downcase)))

(defun endless/upcase ()
  "Upcase region or word."
  (interactive)
  (if (use-region-p)
      (call-interactively 'upcase-region)
    (call-interactively 'subword-upcase)))

(global-set-key "\M-c" 'endless/capitalize)
(global-set-key "\M-l" 'endless/downcase)
(global-set-key "\M-u" 'endless/upcase)

(global-set-key "\C-t" #'transpose-lines)
(define-key ctl-x-map "\C-t" #'transpose-chars)

(projectile-global-mode)

; Add this to your init file and flx match will be enabled for ido.

(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; START Compilation support
;; Let Emacs guess the compilation argument
(require 'smart-compile)
(global-set-key "\C-cc" 'smart-compile)

;; Recompile on save
(require 'recompile-on-save)
(recompile-on-save-advice compile)

;; Auto-update tags file
(autoload 'turn-on-ctags-auto-update-mode "ctags-update" "turn on `ctags-auto-update-mode'." t)
(add-hook 'c-mode-common-hook  'turn-on-ctags-auto-update-mode)

(require 'ibuffer-git)
;; Customization for ibuffer-git is installed in custom.el

;; (require 'ibuffer-projectile)
;; (add-hook 'ibuffer-hook
;;     (lambda ()
;;       (ibuffer-projectile-set-filter-groups)
;;       (unless (eq ibuffer-sorting-mode 'alphabetic)
;;         (ibuffer-do-sort-by-alphabetic))))

;; Better defaults for occur
(defun occur-dwim ()
  "Call `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (thing-at-point 'symbol))
        regexp-history)
  (call-interactively 'occur))
(global-set-key (kbd "M-s o") 'occur-dwim)

(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; --- START ediff
;; Customize ediff to be usable
;; Got this tips from
;; www.oremacs.com/2015/01/17/setting-up-ediff
;;
(defmacro csetq (variable value)
  `(funcall (or (get ',variable 'custom-set)
                'set-default)
            ',variable ,value))

;; Setup frames the correct way
(csetq ediff-window-setup-function 'ediff-setup-windows-plain)

; Ignore whitespace
(csetq ediff-diff-options "-w")

;; Setup window configuration
(csetq ediff-split-window-function 'split-window-horizontally)

;; Restoring windows after quitting ediff
(add-hook 'ediff-after-quit-hook-internal 'winner-undo)

;; Changing keyindings
(defun ora-ediff-hook()
  (ediff-setup-keymap)
  (define-key ediff-mode-map "j" 'ediff-next-difference)
  (define-key ediff-mode-map "k" 'ediff-previous-difference))
(add-hook 'ediff-mode-hook 'ora-ediff-hook)

;; --- End of ediff-configuration

;;; --- START C++
(require 'auto-complete-clang-async)

(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/personal/modules/clang-complete")
  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process)
  )
(defun ac-common-setup ()
  ())
(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(my-ac-config)

;; (require 'auto-complete-clang-async)

;; (defun ac-cc-mode-setup ()
;;   (setq ac-clang-complete-executable "~/.emacs.d/personal/modules/clang-complete")
;;   (setq ac-sources '(ac-source-clang-async))
;;   (ac-clang-launch-completion-process)
;;   )

;; (defun my-ac-config ()
;;   (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
;;   (add-hook 'auto-complete-mode-hook 'ac-common-setup)
;;   (global-auto-complete-mode t))

;; (my-ac-config)


;; CMake support
(require 'cmake-mode)
;; More advanced syntax highlighting
(autoload 'cmake-font-lock-activate "cmake-font-lock" nil t)
(add-hook 'cmake-mode-hook 'cmake-font-lock-activate)

;; Ease use of out-of-tree build in CMake
(require 'cmake-project)
(defun maybe-cmake-project-hook ()
  (if (file-exists-p "CMakeLists.txt") (cmake-project-mode)))
(add-hook 'c-mode-hook 'maybe-cmake-project-hook)
(add-hook 'c++-mode-hook 'maybe-cmake-project-hook)

;; Toggle between implementation and test file
(require 'toggle-test)

(add-to-list 'tgt-projects '((:root-dir "~/Projects/TestDriven/MySoundex")
                             (:src-dirs "src")
                             (:test-dirs "test")
                             (:test-prefixes "Test")))

(global-set-key (kbd "C-c x t") 'tgt-toggle)
; (setq tgt-open-in-new-window <'nil or t>)

;; Toggle between implentation and header
; # Disabled because not in Melpa
; (require 'toggle-header-impl)
; (global-set-key (kbd "C-c x h") 'djw-c-toggle-impl-header-view)

; # Disabled because not in Melpa
; (require 'smarter-compile)
; (defun jonix/bindkey-compile ()
;  "Bind C-c C-c to `compile'."
;  (local-set-key (kbd "C-c C-c") 'smarter-compile))
;(add-hook 'c-mode-common-hook 'jonix/bindkey-compile)
; (add-hook 'c++-mode-hook 'jonix/bindkey-compile)

;(eval-after-load 'C++-mode
;   (define-key c++-mode-map (kbd "C-c C-c") 'smarter-compile))
;(eval-after-load 'c
;(define-key c++-mode-map (kbd "C-c C-c") 'smarter-compile)

;; Code browsing using ECB
(require 'ecb)
                                        ;(require 'ecb-autoloads)
(setq ecb-layout-name "left15")
(setq ecb-show-sources-in-directories-buffer 'always)

;;; --- END C++

;;; --- START PYTHON
;(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)
(elpy-enable)

(defun jx/execute-python ()
  (interactive)
  (python-shell-send-buffer)
  (python-shell-switch-to-shell)
  )
(eval-after-load "python"
  '(progn
     (define-key python-mode-map (kbd "<f5>") 'jx/execute-python)
     (define-key python-mode-map (kbd "C-h f") 'python-eldoc-at-point)
     ))

;; To enforce pyp8 style-rules, rewrite buffers
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)


;;; --- END PYTHON

;;; --- START CUCUMBER


(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))
(require 'cucumber-goto-step)
(setq feature-use-rvm t)
;;; --- END CUCUMBER

;; Enable simple lookup for programming searches
(require 'howdoi)

;; Ability to swap places of buffers
;; Bound to Ctrl-Windows-<arrow>
;; Note that Windows key is little s
(require 'buffer-move)
(global-set-key (kbd "<C-s-up>")     'buf-move-up)
(global-set-key (kbd "<C-s-down>")   'buf-move-down)
(global-set-key (kbd "<C-s-left>")   'buf-move-left)
(global-set-key (kbd "<C-s-right>")  'buf-move-right)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one

;; Make Split window show two different buffers
;; Copied from http://www.reddit.com/r/emacs/comments/25v0eo/you_emacs_tips_and_tricks/chldury
(defun vsplit-last-buffer (prefix)
  "Split the window vertically and display the previous buffer."
  (interactive "p")
  (split-window-vertically)
  (other-window 1 nil)
  (if (= prefix 1)
    (switch-to-next-buffer)))
(defun hsplit-last-buffer (prefix)
  "Split the window horizontally and display the previous buffer."
  (interactive "p")
  (split-window-horizontally)
  (other-window 1 nil)
  (if (= prefix 1) (switch-to-next-buffer)))
(global-set-key (kbd "C-x 2") 'vsplit-last-buffer)
(global-set-key (kbd "C-x 3") 'hsplit-last-buffer)

;; START ace
;; Enable very handy jump within a buffer using  Ctrl-c Space
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c C-j") 'ace-jump-mode)

;
;; enable a more powerful jump back function from ace jump mode
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

(custom-set-faces
 '(aw-leading-char-face
   ((t (:inherit ace-jump-face-foreground :height 3.0)))))

;; END ace

; (require 's3c)

;; Yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; Personal Yasnippet directory outside of Melpa
;; Default is disabled
(setq yas-snippet-dirs '("~/.emacs.d/personal/yasnippet"))

;; Interact with tmux terminal emulator
(require 'emamux)
