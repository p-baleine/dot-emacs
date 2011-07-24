(add-to-list 'load-path "~/.emacs.d/")

(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

(setq-default tab-width 4 indent-tabs-mode nil)
(show-paren-mode t)

;; バックスラッシュ
(define-key global-map [?¥] [?\\])
(define-key global-map [?\C-¥] [?\C-\\])
(define-key global-map [?\M-¥] [?\M-\\])
(define-key global-map [?\C-\M-¥] [?\C-\M-\\])

;; オートインデント
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline)

(add-to-list 'default-frame-alist '(cursor-color . "SlateBlue2"))

;; font
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
        ("-cdac$" . 1.3))))

;; looks
(add-to-list 'default-frame-alist '(background-color . "white"))
; (set-frame-parameter (selected-frame) 'alpha '(85 50))

;; スクロールバー
(toggle-scroll-bar nil)
(require 'linum)
(global-linum-mode t)      ; デフォルトで linum-mode を有効にする
(setq linum-format "%4d ") ; 5 桁分の領域を確保して行番号のあとにスペースを入れる

;; 指定行へ移動
(global-set-key "\C-l" 'goto-line)

;; Drag & drop
(define-key global-map [ns-drag-file] 'ns-find-file)

;; Backup
(setq backup-inhibited t)

;; Org mode
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "SOMEDAY(s)" "|" "DONE(d)")))
(setq org-log-done 'time)
(setq org-agenda-files
      (list "~/Documents/git/fbrushfifteen/docs/work/fbR15_todo.org"
            "~/Documents/git/stuffintro/docs/work/社員紹介.org"
            "~/Documents/git/fbmovieuploader/docs/work/youtube.org"
            "~/Documents/git/fb_proxy/fb_proxy.org"))
; (require ‘org-babel-init)
; (require ‘org-babel-php)

;; auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

;; ;; ac-slime
;; (add-to-list 'load-path "~/.emacs.d/ac-slime")
;; (require 'ac-slime)
;; (add-hook 'slime-mode-hook 'set-up-slime-ac)
;; (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

;; ;; clojure-mode
;; (add-to-list 'load-path "/usr/local/clojure-mode")
;; (require 'clojure-mode)

;; ;; slime
;; (eval-after-load "slime" 
;;   '(progn (slime-setup '(slime-repl))))

;; (add-to-list 'load-path "/usr/local/slime")
;; (require 'slime)
;; (slime-setup)

;; Interactively Do Things (highly recommended, but not strictly required)
(require 'ido)
(ido-mode t)
;; Rinari
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)

;;; rhtml-mode
(add-to-list 'load-path "~/.emacs.d/rhtml")
(require 'rhtml-mode)
(add-hook 'rhtml-mode-hook
          (lambda () (rinari-launch)))

;; js2-mode
;; (setq-default c-basic-offset 4)

(when (load "js2" t)
  (setq js2-cleanup-whitespace nil
        js2-mirror-mode nil
        js2-bounce-indent-flag nil)

  (defun indent-and-back-to-indentation ()
    (interactive)
    (indent-for-tab-command)
    (let ((point-of-indentation
           (save-excursion
             (back-to-indentation)
             (point))))
      (skip-chars-forward "\s " point-of-indentation)))
  (define-key js2-mode-map "\C-i" 'indent-and-back-to-indentation)

  (define-key js2-mode-map "\C-m" nil)

  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))

;;php-mode
; (load-library "php-mode")
; (require 'php-mode)

(load "/Users/tajima_junpei/.emacs.d/nxhtml/autostart.el")

(require 'yasnippet)

(setq yas/root-directory "~/.emacs.d/snippets")
(yas/load-directory yas/root-directory)

(setq-default tab-width 4)

(setq auto-mode-alist
      (cons (cons "\\.\\(phtml\\|ctp\\|thtml\\|inc\\|php[s34]?\\)" 'php-mode) auto-mode-alist))
      (autoload 'php-mode "php-mode" "PHP mode" t)

(yas/initialize)

;;; color-moccur.elの設定
(require 'color-moccur)
;; 複数の検索語や、特定のフェイスのみマッチ等の機能を有効にする
;; 詳細は http://www.bookshelf.jp/soft/meadow_50.html#SEC751
(setq moccur-split-word t)
;; migemoがrequireできる環境ならmigemoを使う
(when (require 'migemo nil t) ;第三引数がnon-nilだとloadできなかった場合にエラーではなくnilを返す
  (setq moccur-use-migemo t))

;;; anything-c-moccurの設定
(require 'anything-c-moccur)
;; カスタマイズ可能変数の設定(M-x customize-group anything-c-moccur でも設定可能)
(setq anything-c-moccur-anything-idle-delay 0.2 ;`anything-idle-delay'
      anything-c-moccur-higligt-info-line-flag t ; `anything-c-moccur-dmoccur'などのコマンドでバッファの情報をハイライトする
      anything-c-moccur-enable-auto-look-flag t ; 現在選択中の候補の位置を他のwindowに表示する
      anything-c-moccur-enable-initial-pattern t) ; `anything-c-moccur-occur-by-moccur'の起動時にポイントの位置の単語を初期パターンにする

;;; キーバインドの割当(好みに合わせて設定してください)
(global-set-key (kbd "M-o") 'anything-c-moccur-occur-by-moccur) ;バッファ内検索
(global-set-key (kbd "C-M-o") 'anything-c-moccur-dmoccur) ;ディレクトリ
(add-hook 'dired-mode-hook ;dired
          '(lambda ()
             (local-set-key (kbd "O") 'anything-c-moccur-dired-do-moccur-by-moccur)))
(setq dmoccur-recursive-search t)

;; e3wm
;最小の e2wm 設定例
(require 'e2wm)
(global-set-key (kbd "M-+") 'e2wm:start-management)
