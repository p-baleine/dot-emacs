;; 文字コードの設定
(set-language-environment "Japanese")
(require 'ucs-normalize)
(prefer-coding-system 'utf-8-hfs)
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

;; anything.el
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
  (setq anything-c-filelist-file-name "~/.emacs.d/anything-filelist/all.filelist")
  (setq anything-grep-candidates-fast-directory-regexp 
        "^/Users/tajima_junpei/\.emacs\.d/anything-filelist"))

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
;; (install-elisp "http://php-mode.svn.sourceforge.net/svnroot/php-mode/tags/php-mode-1.5.0/php-mode.el")
(load-library "php-mode")
(require 'php-mode)

(if window-system
    (progn
      ;; 環境変数の設定
      (setenv "PATH"
	      (concat "/usr/local/git/bin:"
		      "/usr/local/bin/wget:"
		      "/Users/tajima_junpei/opt/ruby/bin:"
		      "/Users/tajima_junpei/opt/lib/ruby/gems/1.8/bin:"
		      (getenv "PATH")))
      (setenv "GEM_HOME" "/Users/tajima_junpei/opt/lib/ruby/gems/1.8")
      ;; Drag & Drop
      (define-key global-map [ns-drag-file] 'ns-find-file)
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