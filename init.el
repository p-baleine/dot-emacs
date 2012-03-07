;; 文字コードの設定
(set-language-environment "Japanese")
(require 'ucs-normalize)
(prefer-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8-hfs)
(setq local-coding-system 'utf-8-hfs)

;; バックスラッシュの設定(Mac OS X用)
(define-key global-map [?¥] [?\\])
(define-key global-map [?\C-¥] [?\C-\\])
(define-key global-map [?\M-¥] [?\M-\\])
(define-key global-map [?\C-\M-¥] [?\C-\M-\\])

;; スクロールバーとメニューバーを非表示に
(toggle-scroll-bar nil)
(menu-bar-mode -1)

;; デフォルトのタブ幅を４、タブの代わりに空白
(setq-default tab-width 4 indent-tabs-mode nil)
;(setq-default tab-width 4 indent-tabs-mode t)
;; ファイルパスの表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))
;; カッコのハイライト
(setq show-paren-delay 0)
(show-paren-mode t)
;; Backupしない
(setq backup-inhibited t)

;; ロードパス
(add-to-list 'load-path "~/.emacs.d/elisp")

;; Auto Install
;; http://www.emacswiki.org/emacs/auto-install.el
;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-compatibility-setup))

;; 行番号を表示する
(global-linum-mode)

;; シェル
;; (install-elisp "http://www.emacswiki.org/emacs/download/multi-term.el")
(when (require 'multi-term nil t)
  (setq multi-term-program "/bin/bash"))

;; コピー＆ペースト
(require 'osx-clipboard)

;; jaspace.el
(require 'jaspace)

;; anything.el;
;; M-x auto-install-batch anything
(when (require 'anything nil t)
  (setq
   anything-idle-delay 0.3
   anything-candidate-number-limit 100
   anything-quick-update t
   anything-enable-shortcuts 'alphabet)
  (require 'anything-match-plugin nil t)
  (when (require 'anything-complete nil t)
    (anything-lisp-complete-symbol-set-timer 150))
  (require 'anything-show-completion nil t)
  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))
  (when (require 'descbinds-anything nil t)
    (descbinds-anything-install))
  (require 'anything-grep nil t)
  (setq warning-suppress-types nil)
  (require 'anything-startup)
  (require 'anything-gtags)
  (setq anything-c-filelist-file-name "~/.emacs.d/anything-filelist/all.filelist")
  (setq anything-grep-candidates-fast-directory-regexp 
        "^/Users/tajima_junpei/\.emacs\.d/anything-filelist"))

(defun my-anything ()
  (interactive)
  (anything-other-buffer
   '(anything-c-source-buffers
     anything-c-source-file-name-history
     anything-c-source-info-pages
     anything-c-source-info-elisp
     anything-c-source-man-pages
     anything-c-source-locate
     anything-c-source-etags-select 
     anything-c-source-gtags-select 
     anything-c-source-emacs-commands)
   " *my-anything*"))

(defun my-anything-from-here ()
  (interactive)
  (anything
   :sources
   '(anything-c-source-buffers
     anything-c-source-file-name-history
     anything-c-source-info-pages
     anything-c-source-info-elisp
     anything-c-source-man-pages
     anything-c-source-locate
     anything-c-source-etags-select 
     anything-c-source-gtags-select 
     anything-c-source-emacs-commands)
   :input
   (thing-at-point 'symbol)))

(global-set-key (kbd "<f1>") 'my-anything)
(global-set-key (kbd "<f2>") 'my-anything-from-here)
(global-set-key (kbd "<f3>") 'anything-filelist+)

;; ELPAとMarmalade
;; (install-elisp "http://repo.or.cz/w/emacs.git/blob_plain/1a0a666f941c99882093d7bd08ced15033bc3f0c:/lisp/emacs-lisp/package.el")
(require 'package)
;リポジトリにMarmaladeを追加
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;;インストールするディレクトリを指定
(setq package-user-dir (concat user-emacs-directory "elisp/elpa"))
;;インストールしたパッケージにロードパスを通してロードする
(package-initialize)

;; color-moccurとmoccur-editとanything-c-moccur
;; (install-elisp "http://www.emacswiki.org/emacs/download/color-moccur.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/moccur-edit.el")
;; (install-elisp "http://svn.coderepos.org/share/lang/elisp/anything-c-moccur/trunk/anything-c-moccur.el")
(when (require 'color-moccur nil t)
  (setq moccur-split-word t)
  (when (require 'migemo nil t)
    (setq moccur-use-migemo t))
  (when (require 'anything-c-moccur nil t)
    ;; カスタマイズ可能変数の設定(M-x customize-group anything-c-moccur でも設定可能)
    (setq anything-c-moccur-anything-idle-delay 0.2
          anything-c-moccur-higligt-info-line-flag t
      anything-c-moccur-enable-auto-look-flag t
      anything-c-moccur-enable-initial-pattern t)
    (global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur)
    (global-set-key (kbd "C-M-o") 'anything-c-moccur-dmoccur)
    (add-hook 'dired-mode-hook
              '(lambda ()
                 (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))))

;; $ cd ~/.emacs.d/elisp
;; $ curl -O http://cx4a.org/pub/auto-complete/auto-complete-1.3.1.tar.bz2
;; $ tar jxvf auto-complete-1.3.1.tar.bz2
;; $ rm auto-complete-1.3.1.tar.bz2
;; M-x load-file ~/.emacs.d/elisp/auto-complete-1.3.1/etc/install.el
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
               "~/.emacs.d/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;; e2wm
;; (auto-install-from-url "http://github.com/kiwanami/emacs-window-layout/raw/master/window-layout.el")
;; (auto-install-from-url "http://github.com/kiwanami/emacs-window-manager/raw/master/e2wm.el")
(require 'e2wm)
(global-set-key (kbd "M-+") 'e2wm:start-management)

;; rinari
;; ELPAから落とせないため自前でビルド
;; $ cd ~/opt
;; $ git clone git://github.com/eschulte/rinari.git
;; $ cd rinari
;; $ git submodule init
;; $ git submodule update
;; $ cd ..
;; $ cp -r rinari ~/.emacs.d/elisp/rinari
(add-to-list 'load-path "~/.emacs.d/elisp/rinari")
(require 'rinari)

;; rhtml-mode
;; $ cd ~/.emacs.d/elisp/
;; $ git clone https://github.com/eschulte/rhtml.git
(add-to-list 'load-path "~/.emacs.d/elisp/rhtml")
(require 'rhtml-mode)
(add-hook 'rhtml-mode-hook
	  (lambda () (rinari-launch)))

;; php-mode
;; (install-elisp "https://raw.github.com/rradonic/php-mode/master/php-mode.el")
(load-library "php-mode")
(require 'php-mode)
(add-hook 'php-mode-hook '(lambda ()
    (setq c-basic-offset 8)
    (setq c-tab-width 8)
    (setq c-indent-level 8)
    (setq tab-width 8)
    (setq indent-tabs-mode t)
    (setq-default tab-width 8)
))

;; php-completion
;; (install-elisp "http://www.emacswiki.org/emacs/download/php-completion.el")
;; (install-elisp "https://raw.github.com/m2ym/auto-complete/master/auto-complete.el")
(add-hook 'php-mode-hook
         (lambda ()
             (require 'php-completion)
             (php-completion-mode t)
             (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
             (require 'auto-complete)
             (make-variable-buffer-local 'ac-sources)
             (add-to-list 'ac-sources 'ac-source-php-completion)
             (auto-complete-mode t)
             (gtags-mode t)))

;; Closure Linter
;; $ sudo easy_install http://closure-linter.googlecode.com/files/closure_linter-latest.tar.gz
;; (install-elisp "https://raw.github.com/gist/561978/f7c1957948c5b2bc1323c53a44d4d56f4e99ce81/gjslint.el")

;; js2-mode
;; M-x package-list-packages js2-mode
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
  (setq js2-basic-offset 8)
  ;(setq js2-auto-indent-p t)
  (setq js2-cleanup-whitespace t)
  ;(setq js2-enter-indents-newline t)
  ;(setq js2-indent-on-enter-key t)
  (add-hook 'js2-mode-hook
	    #'(lambda ()
			(require 'js)
            (setq tab-width 4)
            (setq-default tab-width 8)
			(setq indent-tabs-mode t)
			(setq js-indent-level 4
				  js-expr-indent-offset 8)
			(set (make-local-variable 'indent-line-function) 'js-indent-line)
            (flymake-mode t)))

;; org-mode
;; TODO状態
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "SOMEDAY(s)")))
;; DONEの時刻を記録
(setq org-log-done 'time)
(setq org-agenda-files '("~/Documents/git/beluga/docs/work/beluga_1000.org"))
(global-set-key (kbd "<f4>") 'org-agenda)

;; dart-mode
(require 'dart-mode)
(add-to-list 'auto-mode-alist '("\\.dart$" . dart-mode))
; (add-hook 'dart-mode-hook)

;; gauche
(setq process-coding-system-alist
      (cons '("gosh" utf-8 . utf-8) process-coding-system-alist))

(setq scheme-program-name "/Users/tajima_junpei/opt/Gauche-0.9.2/bin/gosh -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)

;; gtags
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         (local-set-key "\C-t" 'gtags-pop-stack)
         ))

(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         (local-set-key "\C-t" 'gtags-pop-stack)
         ))

;; popwin
;; (install-elisp "https://github.com/m2ym/popwin-el/raw/master/popwin.el")
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

;; edbi
;; (install-elisp "https://github.com/kiwanami/emacs-deferred/raw/master/deferred.el")
;; (auto-install-from-url "https://github.com/kiwanami/emacs-deferred/raw/master/concurrent.el")
;; (auto-install-from-url "https://github.com/kiwanami/emacs-ctable/raw/master/ctable.el")
;; (auto-install-from-url "https://github.com/kiwanami/emacs-epc/raw/master/epc.el")
;; (auto-install-from-url "https://github.com/kiwanami/emacs-edbi/raw/master/edbi.el")
;; https://github.com/kiwanami/emacs-edbi/raw/master/edbi-bridge.plcp 

;; windows.el
;; (install-elisp "http://www.gentei.org/~yuuji/software/revive.el")
;; (install-elisp "http://www.gentei.org/~yuuji/software/windows.el")
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe emacs" t)
(require 'windows)
(win:startup-with-window)
(define-key ctl-x-map "C" 'see-you-again)

;; elisp編集用(テクニックバイブルより)
;; (install-elisp-from-emacswiki "open-junk-file.el")
;; (install-elisp-from-emacswiki "lispxmp.el")
;; (install-elisp "http://mumble.net/~campbell/emacs/paredit.el")
;; (install-elisp-from-emacswiki "auto-async-byte-compile.el")
;; 試行錯誤要ファイルを開くための設定h
(require 'open-junk-file)
;; C-c C-zで試行錯誤ファイルを開く
(global-set-key (kbd "C-c C-z") 'open-junk-file)
;; 式の評価結果を注釈するための設定
(require 'lispxmp)
;; emacs-lis-pmodeでC-c C-dを押すと注釈される
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)
;; 括弧の対応を保持して編集する設定
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)
(require 'auto-async-byte-compile)
;; 自動コンパイルを無効にするファイル名の正規表現
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idole-delay 0.2)
(setq eldoc-minor-mode-string "")
;; 改行と同時にインデントも行う
(global-set-key "\C-m" 'newline-and-indent)
;; find-functionをキー割り当てする
(find-function-setup-keys)

;; nu
(require 'nu)
;; (require 'paredit)

;; (add-hook 'nu-mode-hook (lambda () (paredit-mode +1)) t)

;; (require 'parenface)
;; (set-face-foreground 'paren-face "SteelBlue")
;; (add-hook 'nu-mode-hook (paren-face-add-support nu-font-lock-keywords))

(if window-system
    (progn
      ;; 環境変数の設定
      (setenv "PATH"
	      (concat "/usr/local/git/bin:"
		      "/usr/local/bin/wget:"
		      "/Users/tajima_junpei/opt/ruby/bin:"
		      "/Users/tajima_junpei/opt/lib/ruby/gems/1.8/bin:"
		      "/Users/tajima_junpei/opt/global-6.1/bin:"
              "/Users/tajima_junpei/opt/Gauche-0.9.2/bin:"
		      (getenv "PATH")))
      (setenv "GEM_HOME" "/Users/tajima_junpei/opt/lib/ruby/gems/1.8")
      ;; Drag & Drop
      (define-key global-map [ns-drag-file] 'ns-find-file)
      ;; カーソル色
      (add-to-list 'default-frame-alist '(cursor-color . "SlateBlue2"))
      ;; フォント
      (when (>= emacs-major-version 23)
        (set-face-attribute 'default nil
                            :family "monaco"
                            :height 110)
        (set-fontset-font
         (frame-parameter nil 'font)
         'japanese-jisx0208
         '("Hiragino Maru Gothic Pro" . "iso10646-1"))
        (set-fontset-font
         (frame-parameter nil 'font)
         'japanese-jisx0212
         '("Hiragino Maru Gothic Pro" . "iso10646-1"))
        (set-fontset-font
         (frame-parameter nil 'font)
         'mule-unicode-0100-24ff
         '("monaco" . "iso10646-1"))
        (setq face-font-rescale-alist
              '(("^-apple-hiragino.*" . 1.1)
                (".*osaka-bold.*" . 1.1)
                (".*osaka-medium.*" . 1.1)
                (".*courier-bold-.*-mac-roman" . 1.0)
                (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
                (".*monaco-bold-.*-mac-roman" . 0.9)
                ("-cdac$" . 1.3))))))

