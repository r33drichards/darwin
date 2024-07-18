(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("org"   . "https://orgmode.org/elpa/")
	("gnu"   . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))

(package-initialize) 
(package-refresh-contents)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(scroll-bar-mode -2)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

(global-display-line-numbers-mode 1)

(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

(setq hscroll-margin 0)
(setq hscroll-step 1)

(setq  blink-matching-paren t)
(show-paren-mode 1)

(set-face-attribute 'default nil :height 90)

(setq-default tab-width 4)
(setq indent-tabs-mode 1)
(setq js-indent-level 2)
(setq typescript-indent-level 2)

(setq evil-want-keybinding nil)
(use-package evil :ensure t :config (evil-mode 1))

 (use-package base16-theme
   :ensure t)
   

(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))

(use-package helm
  :ensure t
  :init
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-candidate-number-list 50))

(use-package magit :ensure t)

(use-package evil-collection :ensure t)
(evil-collection-init)

;; todo seperate spot for this
(use-package undo-tree :ensure t)
(global-undo-tree-mode)

(evil-set-undo-system 'undo-tree)

(use-package htmlize :ensure t)

(use-package company :ensure t :init (global-company-mode))

(use-package flycheck :ensure t :init (global-flycheck-mode))
(defun disable-fylcheck-in-org-src-block ()
  (setq-local flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(add-hook 'org-src-mode-hook 'disable-fylcheck-in-org-src-block)

(use-package yasnippet :ensure t :init (yas-global-mode))

(use-package smartparens :ensure t :init (smartparens-global-mode))

(use-package restart-emacs :ensure t)

(use-package lsp-mode :hook (prog-mode-hook . lsp) :commands lsp :ensure t)

(use-package lsp-ui :commands lsp-ui-mode :ensure t)
(use-package helm-lsp :commands helm-lsp-workspace-symbol :ensure t)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list :ensure t)
(setq lsp-ui-doc-position 'top)

(setq lsp-completion-provider :capf)
;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

(setq lsp-clients-javascript-typescript-server "typescript-language-server")
(setq lsp-clients-typescript-javascript-server-args "--stdio")

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package typescript-mode :ensure t)

(use-package emojify :ensure t :init (add-hook 'org-mode-hook #'emojify-mode))
(setq emojify-download-emojis-p 'nil)

(use-package projectile
  :ensure t
  :pin melpa
  :init (projectile-mode +1))

(use-package helm-rg :ensure t)

(use-package helm-projectile :ensure t :init (helm-projectile-on))

(use-package rainbow-delimiters
  :ensure t
  :init    (progn (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)))

(use-package auto-complete :ensure t)

(use-package terraform-mode :ensure t)

(use-package yaml-mode
  :ensure t
  :init (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package rjsx-mode
  :ensure t
  :init (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode)))

(use-package prettier-js
  :ensure t
  :init (progn
		  (add-hook 'rjsx-mode-hook 'prettier-js-mode)
		  (add-hook 'typescript-mode-hook 'prettier-js-mode)))

(defun configure-nyan-mode ()
  (setq nyan-animate-nyancat t)
  (setq nyan-wavy-trail t)
  (nyan-mode 1))
(use-package nyan-mode :ensure t :init (configure-nyan-mode))

(use-package fill-column-indicator
  :ensure t)

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2))

(defun configure-web-mode ()
  (add-hook 'web-mode-hook  'my-web-mode-hook)
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))) 
   
(use-package web-mode :ensure t :init (configure-web-mode))

(use-package elisp-format :ensure t)

(use-package markdown-mode :ensure t)
(setq markdown-command "/usr/bin/pandoc")

(use-package dockerfile-mode :ensure t)

(use-package org-pomodoro :ensure t
  :config (progn (setq org-pomodoro-play-sounds t)
		 (setq org-pomodoro-ticking-sound-p t)
		 (setq org-pomodoro-keep-killed-pomodoro-time t)
		 (setq org-pomodoro-ticking-sound-states
		       (quote (:pomodoro :short-break :long-break)))))

(use-package geiser
  :ensure t
  :config (setq geiser-default-implementation 'guile))

(use-package rainbow-mode
  :ensure t
  :config (progn
	    (define-globalized-minor-mode my-global-rainbow-mode rainbow-mode
	      (lambda () (rainbow-mode 1)))
	    (my-global-rainbow-mode 1)))

(use-package org-roam :ensure t :hook (after-init . org-roam-mode))
  (setq org-roam-directory "~/Sync/org/roam/")
  (setq org-roam-completion-system 'helm)

(setq org-roam-db-location "~/Sync/org/roam/org-roam.db")

(use-package aggressive-indent :ensure t :hook (prg-mode . agressive-indent-mode))

(use-package ob-go :ensure t)

(use-package org-download :ensure t
  :config (progn
	    (add-hook 'dired-mode-hook 'org-download-enable)
	    (setq org-download-screenshot-method "flameshot gui --raw > %s")))

(use-package json-mode :ensure t )

(use-package slime :ensure t )
;; (use-package slime-completion :ensure t )
;; ((global-company-mode))
;; (slime-setup '(slime-company))

(when (file-exists-p (expand-file-name "~/quicklisp/slime-helper.el"))
  (load (expand-file-name "~/quicklisp/slime-helper.el"))
  ;; https://github.com/slime/slime/issues/250
  (setq slime-protocol-version 'ignore)
  ;; (add-hook 'slime-load-hook (lambda () (setq slime-protocol-version 'ignore)))
  (slime-connect "127.0.0.1" "4004")
  ;; (slime-load-file "~/.slime-stumpwm-init.lisp")
  (add-hook 'slime-connected-hook
			(lambda () (slime-repl-eval-string "(require :stumpwm) (in-package :stumpwm)"))))

(use-package elfeed :ensure t)
(setq-default elfeed-search-filter "@1-day-ago +unread -aggregator -arxiv")
(setq shr-width 80)

(setq elfeed-feeds
	  '(
		("https://www.bloomberg.com/opinion/authors/ARbTQlRLRjE/matthew-s-levine.rss" finance)
        ("https://www.depesz.com/feed/" database tech blog)
		("https://samharris.org/subscriber-rss/?uid=PNIUOszG9qi8ol9" podcast philosophy politics)
		("https://medium.com/feed/@InstagramEng" tech blog)
		("https://engineering.fb.com/feed/" tech blog)
		("https://medium.com/feed/@netflixtechblog" tech blog)
		("http://feeds.feedburner.com/GDBcode" tech blog)
		("https://blog.twitter.com/engineering/en_us/blog.rss" tech blog)
		("https://medium.com/feed/airbnb-engineering" tech blog)
		("http://feeds.feedburner.com/blogspot/gJZg" tech blog)
		("http://feeds.feedburner.com/GoogleOnlineSecurityBlog" tech blog)
		("https://github.blog/category/engineering/feed/" tech blog)
		("https://about.gitlab.com/atom.xml" tech blog)
		("https://developers.soundcloud.com/blog/blog.rss" tech blog)
		("https://engineering.linkedin.com/blog.rss.html" tech blog)
		("https://aws.amazon.com/blogs/architecture/" tech blog)
		("https://tech.buzzfeed.com/feed" tech blog)
		("https://medium.com/feed/@cfatechblog" tech blog)
		("https://medium.com/feed/palantir" tech blog)
		("https://blog.ipfs.io/index.xml" tech blog)
		("https://blog.golang.org/" tech blog go)
		("https://eng.uber.com/feed/" tech blog)
		("https://medium.com/feed/tinder-engineering" tech blog)
		("https://engineering.atspotify.com/feed/" tech blog)
		("https://open.nytimes.com/feed" tech blog)
		("https://devblogs.microsoft.com/feed" tech blog)
		("https://blog.khanacademy.org/engineering/feed/" tech blog)
		("https://blog.janestreet.com/feed.xml" tech blog)
		("http://nautil.us/rss/all" news)
		("https://www.govinfo.gov/rss/econi.xml" economics usgov govrss)
		("https://www.govinfo.gov/rss/budget.xml" economics usgov govrss)
		("https://www.govinfo.gov/rss/erp.xml" economics usgov govrss)
		("http://congress.gov/rss/senate-floor-today.xml" politics senate usgov govrss)
		("https://www.congress.gov/rss/house-floor-today.xml" politics house usgov govrss)
		("https://www.congress.gov/rss/presented-to-president.xml" politics usgov govrss)
		("https://www.congress.gov/rss/most-viewed-bills.xml" politics usgov govrss)
		("https://www.bls.gov/feed/bls_latest.rss" economics usgov govrss)
		("https://graymirror.substack.com/feed" economics politics)
		("http://s221659.gridserver.com/blackwolf/rss/" politics podcast)
		("http://arxiv.org/rss/astro-ph" arxiv physics astronomy)
		("http://arxiv.org/rss/cond-mat" arxiv)
		("http://arxiv.org/rss/cs" tech computer science arxiv)
		("http://arxiv.org/rss/econ" economics arxiv)
		("http://arxiv.org/rss/eess" electrical engineering arxiv)
		("http://arxiv.org/rss/gr-qc" physics arxiv)
		("http://arxiv.org/rss/hep-ex" physics arxiv)
		("http://arxiv.org/rss/hep-lat" physics arxiv)
		("http://arxiv.org/rss/hep-ph" physics arxiv)
		("http://arxiv.org/rss/hep-th" physics arxiv )
		("http://arxiv.org/rss/math" math arxiv)
		("http://arxiv.org/rss/math-ph" math arxiv)
		("http://arxiv.org/rss/nlin" arxiv)
		("http://arxiv.org/rss/nucl-ex" arxiv nuclear)
		("http://arxiv.org/rss/nucl-th" arxiv nuclear)
		("http://arxiv.org/rss/physics" physics arxiv)
		("http://arxiv.org/rss/q-bio" quant biology arxiv)
		("http://arxiv.org/rss/q-fin" quant finance arxiv)
		("http://arxiv.org/rss/quant-ph" quant physics arxiv)
		("http://arxiv.org/rss/stat" math statistics arxiv)
        ("https://ourworldindata.org/atom.xml" data)
		("https://bernsteinbear.com/feed.xml" blog tech lisp)
		("http://feeds.feedburner.com/marginalrevolution/feed" blog economics)
		("https://www.evanmiller.org/news.xml" blog tech)
		("https://rss.art19.com/monday-morning-podcast" blog)
		("https://fivethirtyeight.com/all/feed" blog)
		("http://n-gate.com/index.rss" blog satire)
		("http://rachelbythebay.com/w/atom.xml" blog tech)
		("https://adamdrake.com/index.xml" blog)
		("https://slatestarcodex.com/feed/" blog)
		("https://lwn.net/headlines/rss" blog tech)
		("https://www.edge.org/feed" news)
		("http://feeds.feedburner.com/Quantocracy" news)
		("https://christine.website/blog.rss" blog tech)
		("https://kubernetes.io/feed.xml" blog tech kubernetes)
		("https://stallman.org/rss/rss.xml" blog tech politics)
		("https://jvns.ca/atom.xml" blog tech)
		("https://overreacted.io/rss.xml" blog tech react javascript)
		("https://reactjs.org/feed.xml" blog tech react javascript)
		("https://devblogs.microsoft.com/typescript/feed/" blog tech javascript)
		("https://nodejs.org/en/feed/blog.xml" blog tech javascript)
		("http://feeds.feedburner.com/PythonInsider" blog tech python)
		("http://feeds.feedburner.com/PythonSoftwareFoundationNews" blog tech python)
		("https://www.djangoproject.com/rss/weblog/" blog tech python django)
		("https://jockopodcast.libsyn.com/rss" podcast)
		("http://podcast.foundmyfitness.com/rss.xml" news health)
		("https://theknowledgeproject.libsyn.com/rss" news)
		("https://feeds.megaphone.fm/revisionisthistory" podcast)
		("http://feeds.soundcloud.com/users/soundcloud:users:494308113/sounds.rss" podcast sports basketball)
		("https://www.youtube.com/feeds/videos.xml?channel_id=UC3HPbvB6f58X_7SMIp6OPYw" youtube sports basketball)
		("https://www.youtube.com/feeds/videos.xml?channel_id=UCYO_jab_esuFRV4b17AJtAw" youtube math)
		("https://audioboom.com/channels/4954758.rss" podcast)
		("https://tim.blog/feed/" blog)
		("https://feeds.soundcloud.com/users/soundcloud%3Ausers%3A88794716/sounds.rss" podcast comedy)
		("https://www.youtube.com/feeds/videos.xml?channel_id=UC-lHJZR3Gqxm24_Vd_AJ5Yw" youtube comedy)
		("https://fs.blog/feed/" news)
		("https://xkcd.com/atom.xml" comic)
		("http://comicfeeds.chrisbenard.net/view/dilbert/default" comic)
		("http://news.mit.edu/rss/feed" news)
		("https://www.lesswrong.com/feed.xml" news aggregator)
		("https://www.eff.org/rss/updates.xml" news)
		("https://static.fsf.org/fsforg/rss/blogs.xml" news tech)
		("https://static.fsf.org/fsforg/rss/news.xml" news tech)
		("https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss" news)
		("https://www.nasa.gov/rss/dyn/breaking_news.rss" news)
		("http://philosophizethis.libsyn.com/rss" podcast philosophy)
		("https://rss.art19.com/the-portal" podcast economics politics)
		("http://feeds.wnyc.org/radiolab" podcast)
		("https://www.omnycontent.com/d/playlist/aaea4e69-af51-495e-afc9-a9760146922b/14a43378-edb2-49be-8511-ab0d000a7030/d1b9612f-bb1b-4b85-9c0c-ab0d004ab37a/podcast.rss" podcast economics)
		("http://rss.slashdot.org/Slashdot/slashdotMain" news aggregator)
		("https://lobste.rs/rss" news aggregator)
		("https://hnrss.org/frontpage" news aggregator)
		("https://old.reddit.com/.rss?feed=f01e8bf8ac3e9a63ff0f36b2e9bc554822afab35&user=mdmacidmthcoke" news reddit aggregator)))

(use-package org-super-agenda :ensure t)

(use-package ob-typescript :ensure t)

(use-package yasnippet :ensure t)
(yas-global-mode 1)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"                 ;; personal snippets
        ))

(use-package forge
  :after magit :ensure t)

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package python-black
  :demand t
  :ensure t
  :after python)

(use-package pip-requirements
  :demand t
  :ensure t
  :after python)

(use-package py-isort
  :demand t
  :ensure t
  :after python)
(add-hook 'before-save-hook 'py-isort-before-save)

(use-package sphinx-doc
  :demand t
  :ensure t
  :after python)
    (add-hook 'python-mode-hook (lambda ()
                                  (require 'sphinx-doc)
                                  (sphinx-doc-mode t)))

;; (use-package mmm-mode
;;   :ensure t)
;; (require 'mmm-mode)
;; (setq mmm-global-mode 'maybe)
;; (mmm-add-classes
;;  '((python-rst
;;     :submode rst-mode
;;     :front "^ *[ru]?\"\"\"[^\"]*$"
;;     :back "^ *\"\"\""
;;     :include-front t
;;     :include-back t
;;     :end-not-begin t)))
;; (mmm-add-mode-ext-class 'python-mode nil 'python-rst)

;(use-package vterm
;    :ensure t)

;(add-to-list 'vterm-eval-cmds '("update-pwd" (lambda (path) (setq default-directory path))))

;(use-package multi-vterm :ensure t)

(use-package org-ql :ensure t)

(use-package general
  :ensure t  )
(general-create-definer  my/general-define-key-template 
            :wrapping general-define-key
	    :states '(normal visual insert emacs)
	    :prefix "SPC"
	    :non-normal-prefix "M-SPC")

(my/general-define-key-template
	   ;; "/"   '(counsel-rg :which-key "ripgrep") ; You'll need counsel package for this
	   "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
	   "SPC" '(helm-M-x :which-key "M-x")
	   ;; Others
	   "at"  '(vterm :which-key "open terminal")
	   "qq"  '(kill-emacs :which-key "quit")
	   "qr"  '(restart-emacs :which-key "restart emacs"))

(my/general-define-key-template
	   ;; "/"   '(counsel-rg :which-key "ripgrep") ; You'll need counsel package for this
	   ;; Others
	   "vt"  '(vterm :which-key "open main terminal")
	   "vm"  '(multi-vterm :which-key "open a terminal")
	   "vn"  '(multi-vterm-next :which-key "next terminal")
	   "vp"  '(multi-vterm-prev :which-key "prev terminal")
	   "vd"  '(multi-vterm-dedicated-toggle :which-key "toggle dedicated term")
	   "vP"  '(multi-vterm-projetile :which-key "projectile terminal"))

;; use this template to add a new keybinding block. make sure that you remove ~:tangle no~ to enable this block
(my/general-define-key-template
 "r"  '(:which-key "re")
 "rl"  '((lambda () (interactive)
	   (load-file "~/.emacs.d/init.el"))
	 :which-key "reload init"))

(my/general-define-key-template
  "g"  '(:which-key "git")
  "gs"  '(magit-status :which-key "git status")
  "gf"  '(:which-key "forge")
  "gfa"  '(forge-add-repository :which-key "forge add")
  "gfi"  '(:which-key "issue")
  "gfil"  '(forge-list-issues :which-key "list")
  "gfib"  '(forge-browse-issue :which-key "list")
  "gfp"  '(:which-key "PR's")
  "gfpl"  '(forge-list-pullreqs :which-key "list")
  "gfpb"  '(forge-browse-pullreq :which-key "list")
  "gfP"  '(forge-pull :which-key "forge pull"))

(use-package forge :ensure t :after magit)

(my/general-define-key-template
 "w"  '(:which-key "window")
 "wl"  '(windmove-right :which-key "move right")
 "wh"  '(windmove-left :which-key "move left")
 "wd"  '(delete-window :which-key "delete window")
 "wk"  '(windmove-up :which-key "move up")
 "wj"  '(windmove-down :which-key "move bottom")
 "w/"  '(split-window-right :which-key "split right")
 "w-"  '(split-window-below :which-key "split bottom")
 "wx"  '(delete-window :which-key "delete window"))

(my/general-define-key-template
 "b"  '(:which-key "buffer")
 "bb"  '(helm-buffers-list :which-key "buffers list")
 "bd"  '(evil-delete-buffer :which-key "buffer delete")
 "bp"  '(previous-buffer :which-key "previous buffer")
 "bn"  '(next-buffer :which-key "previous buffer")
 "br"  '(revert-buffer :which-key "revert buffer")
 ; general-define-key expects an interactive function
 ; https://stackoverflow.com/questions/1250846/wrong-type-argument-commandp-error-when-binding-a-lambda-to-a-key
 "bs"  '((lambda () (interactive) (switch-to-buffer "*scratch*")) :which-key "scratch buffer")
 "bc"  '((lambda () (interactive) (kill-new (buffer-file-name))) :which-key "copy file name"))

(my/general-define-key-template
  "o" '(:which-key "org")
  "oa" '((lambda () (interactive) 
		   (org-ql-search (org-agenda-files)
			 '(and (todo))
			 :title "My Agenda View"
			 ;; The `org-super-agenda-groups' setting is used automatically when set, or it
			 ;; may be overriden by specifying it here:
			 :super-groups 'org-super-agenda-groups)
		   (delete-other-windows)) :which-key "org agenda")
  "od" '(org-deadline :which-key "org agenda")
  "oA" '(org-archive-subtree-default  :which-key "org agenda")
  "op" '(org-priority :which-key "org priority")
  "oP" '(org-pomodoro :which-key "org-pomodoro")
  "oh" '(org-html-export-to-html :which-key "export to html")
  "oe" '(org-set-effort :which-key "org set effort")
  "oF" '(:which-key "Footnote")
  "oFn" '(org-footnote-normalize :which-key "normalize")
  "oFi" '(org-footnote-new :which-key "insert")
  "of" '(:which-key "failure rate")
  "ofc" '(calculate-failure-rate-for-heading
		  :which-key "calculate for heading")
  "ofa" '(aggregate-failure-rate-for-heading
		  :which-key "aggregate failure rate")
  "oT" '(org-todo :which-key "todo")
  "oS" '(org-schedule :which-key "schedule")
  "oc" '(:which-key "org-capture")
  "occ" '(org-capture :which-key "capture")
  "ocf" '(org-capture-finalize :which-key "finalize")
  "ocr" '(org-capture-refile :which-key "refile")
  "ock" '(org-capture-kill :which-key "kill/abort")
  "oC" '(:which-key "clock")
  "oCi" '((lambda () (interactive) (org-todo) (org-pomodoro))
		  :which-key "clock in")
  "oCo" '(org-clock-out
		  :which-key "clock out")

  "ot" '((lambda () (interactive)
		   (org-todo)
		   (org-set-effort)
		   (org-set-property
			"ProbabilitySuccess"
			(read-from-minibuffer "
  some tips on estimating probability of success:
  
  I am confident that this can be done and that there are no unforeseen
  difficulties (~95%)

  I am confident that this can be done modulo Murphy's law (~90%)

  I see the basic path to accomplishing this and all the steps seem
  like they should work (~65%)

  I have the intuition that this should be possible but only have a 
  murky view of the path (~30%)

ProbabilitySuccess: "))
		   (calculate-failure-rate-for-heading)
		   (org-priority)
		   (let ((pri (org-get-current-priority)))
			 (cond ((eq pri 3000)
					(progn (call-interactively 'org-schedule)
						   (org-schedule-effort)))
				   ((eq pri 2000)
					(progn (call-interactively 'org-schedule)
						   (org-schedule-effort)))))
		   (org-ctrl-c-ctrl-c))
		 :which-key "todo")
  "ob" '(:which-key "org babel")
  "obt" '(org-babel-tangle :which-key "org-babel-tangle")
  "ogc" '(org-global-cycle :which-key "org-global-cycle")
  "or" '(:which-key "org roam ")
  "orr" '(org-roam :which-key "org roam")
  "orf" '(org-roam-find-file :which-key "org roam find file")
  "ori" '(org-roam-insert :which-key "org roam insert")
  "orI" '(org-roam-insert-immediate :which-key "org roam insert immediate")
  "orj" '(org-roam-jump-to-index :which-key "org roam jump to index")
  "orb" '(org-roam-switch-to-buffer :which-key "org roam switch to buffer")
  "ord" '(org-roam-db-build-cache :which-key "database build cache")
  "org" '(org-roam-graph :which-key "org roam graph")
  "ors" '(org-roam-store-link :which-key "org roam store link")
  "ol" '(:which-key "org link")
  "oli" '(org-insert-link :which-key "org link insert")
  "ols" '(org-store-link :which-key "org link store")
  "olo" '(org-open-at-point :which-key "org link open")
  "os" '(:which-key "org subtree")

  "osi" '(org-insert-heading-after-current
		  :which-key "org insert heading after current")

  "osI" '(org-insert-subheading  :which-key "org insert subheading")

  "ost" '(org-insert-todo-heading-respect-content
		  :which-key "org insert todo respect content")

  "osT" '(org-insert-todo-subheading
		  :which-key "org insert todo subheading")

  "oss" '(org-show-subtree :which-key "org-show-subtree")

  "osh" '(hide-subtree :which-key "hide-subtree")

  "TAB" '(org-cycle :which-key "cycle tree")

  "o TAB" '(org-cycle :which-key "cycle tree")
  "oi" '(:which-key "insert")
  "ois" '(org-insert-structure-template :which-key "structured template")
  "oit" '((lambda () (interactive)
			(let ((current-prefix-arg '(4))) ; C-u
			  (call-interactively 'org-time-stamp))) :which-key "timestamp")
  "oid" '(org-time-stamp :which-key "datestamp")
  "oif" '(org-footnote-new :which-key "footnote")
  "oo" '(:which-key "page 2")
  "ooa" '(org-toggle-archive-tag :which-key "archive inline")
  "ooc" '(org-ctrl-c-ctrl-c :which-key "org-ctrl-c-ctrl-c")
  "ood" '(:which-key "download")
  "oods" '(org-download-screenshot :which-key "screenshot")
  "oody" '(org-download-yank :which-key "yank")
  "ool" '(:which-key "latex")
  "oolp" '(org-latex-preview :which-key "latex")
  "ooS" '(org-sort :which-key "sort")
  "oos" '(:which-key "source/special")
  "oose" '(org-edit-special :which-key "edit")
  "oosa" '(org-edit-src-abort :which-key "abort")
  "ooss" '(org-edit-src-exit :which-key "save"))

(my/general-define-key-template
 "p" '(:which-key "projectile")
 "pf" '(helm-projectile-find-file :which-key "find file")
 "pp" '(helm-projectile-find-in-known-projectile
	:which-key "project find file ")
 "ps" '(helm-projectile-switch-project :which-key "switch project")
 "pr" '(helm-projectile-rg :which-key "ripgrep"))

(my/general-define-key-template
 "P" '(:which-key "python")
 "Pw" '(pyvenv-workon :which-key "workon venv"))

; from magnars
; modified from spacemacs
(defun thrash/rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
	 (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
	(error "Buffer '%s' is not visiting a file!" name)
      (let* ((dir (file-name-directory filename))
	     (new-name (read-file-name "New name: " dir)))
	(cond ((get-buffer new-name)
	       (error "A buffer named '%s' already exists!" new-name))
	      (t
	       (let ((dir (file-name-directory new-name)))
		 (when (and (not (file-exists-p dir)) (yes-or-no-p (format "Create directory '%s'?" dir)))
		   (make-directory dir t)))
	       (rename-file filename new-name 1)
	       (rename-buffer new-name)
	       (set-visited-file-name new-name)
	       (set-buffer-modified-p nil)
	       (when (fboundp 'recentf-add-file)
		 (recentf-add-file new-name)
		 (recentf-remove-if-non-kept filename))
	       (when (projectile-project-p)
		 (call-interactively #'projectile-invalidate-cache))
	       (message "File '%s' successfully renamed to '%s'" name (file-name-nondirectory new-name))))))))

(defun er-delete-file-and-buffer (bool)
  "Kill the current buffer and deletes the file it is visiting."
  (interactive (list (y-or-n-p (format "Delete %s?" (buffer-file-name)))))
  (when bool
	(let ((filename (buffer-file-name)))
      (when filename
		(if (vc-backend filename)
			(vc-delete-file filename)
          (progn 
			(delete-file filename)
			(message "Deleted file %s" filename)
			(kill-buffer)))))))

(my/general-define-key-template
 "f"  '(:which-key "file")
 "fr"  '(thrash/rename-current-buffer-file :which-key "rename")
 "fd"  '(er-delete-file-and-buffer :which-key "delete")
 "ff"  '(helm-find-files :which-key "find files")
 "fs"  '(save-buffer :which-key "save")
 ;; see shortcuts
 "fq" '(:which-key "quick navigation")
 "fw"  '(:which-key "work")
 "fwt"  '((lambda ()
	    (interactive) (find-file "~/documents/todo.org"))
	  :which-key "work todo")
 "ft"  '((lambda ()
	   (interactive) (find-file "~/Sync/org/roam/20200614114256-todo.org"))
	 :which-key "open todo org file")
 "fg"  '(:which-key "file grimoire")
 "fgt"  '((lambda ()
	    (interactive)
	    (find-file "~/grimoire/todo.org"))
	  :which-key "open grimoire todo org file")
 "fc"  '(:which-key "open a config file")
 "fca" '((lambda ()
	   (interactive) (find-file "~/dotfiles/alacritty.org"))
	 :which-key "alacritty")
 "fcc" '((lambda ()
	   (interactive) (find-file "~/dotfiles/compton.org"))
	 :which-key "compton")
 "fcC" '((lambda ()
	   (interactive) (find-file "~/dotfiles/ci.org"))
	 :which-key "ci")
 "fcd" '((lambda ()
	   (interactive) (find-file "~/dotfiles/dunst.org"))
	 :which-key "dunst")
 "fcD" '((lambda ()
	   (interactive) (find-file "~/dotfiles/dropbox.org"))
	 :which-key "dropbox")
 "fce" '((lambda ()
	   (interactive) (find-file "~/dotfiles/emacs.org"))
	 :which-key "emacs")
 "fcf" '((lambda ()
	   (interactive) (find-file "~/dotfiles/flashfocus.org"))
	 :which-key "flashfocus")
 "fci" '((lambda ()
	   (interactive) (find-file "~/dotfiles/i3.org"))
	 :which-key "i3")
 "fcT" '((lambda ()
	   (interactive) (find-file "~/dotfiles/tmux.org"))
	 :which-key "tmux")
 "fcu" '((lambda ()
	   (interactive) (find-file "~/dotfiles/utils.org"))
	 :which-key "utils")
 "fcx" '((lambda ()
	   (interactive) (find-file "~/dotfiles/x-org.org"))
	 :which-key "x org")
 "fcz" '((lambda ()
	   (interactive) (find-file "~/dotfiles/zsh.org"))
	 :which-key "zsh")
 "fcr" '((lambda ()
	   (interactive) (find-file "~/dotfiles/readme.org"))
	 :which-key "readme")
 "fcs" '((lambda ()
	   (interactive) (find-file "~/dotfiles/stumpwm.org"))
		 :which-key "syncthing")
 "fcS" '((lambda ()
	   (interactive) (find-file "~/dotfiles/syncthing.org"))
		 :which-key "syncthing"))

; makes backspace key in helm-find-file behave like it does in 
; spacemacs
(define-key helm-find-files-map
  (kbd "<backspace>") 'helm-find-files-up-one-level)

(my/general-define-key-template
 "fqg" '(:which-key "grimoire")
 "fqgr" '((lambda () (interactive)
	    (find-file
	     "~/grimoire/README.org"))
	  :which-key "README")
 "fqe" '((lambda () (interactive)
	   (find-file
	    "~/dotfiles/assets/eisenhower-box.jpg"))
	 :which-key "eisenhower box"))

(my/general-define-key-template
  "t"  '(:which-key "toggle")
  "tl"  '(toggle-truncate-lines :which-key "toggle truncate lines")
  "tv"  '(visual-line-mode :which-key "toggle visual line")
  "ta"  '(auto-fill-mode :which-key "toggle auto fill mode")
  "tf"  '(fci-mode :which-key "toggle fci mode")
  "tn"  '(display-line-numbers-mode  :which-key "line numbers")
  "tr" '((lambda () (interactive)
		   (if (eq display-line-numbers 'relative)
			   (setq display-line-numbers t)
			 (setq display-line-numbers 'relative)))
		 :which-key "relative line number")
  "ti"  '(org-toggle-inline-images :which-key "org toggle inline images")
  "l"  '(:which-key "comment")
  "ll"  '(comment-line :which-key "comment line")
  "lr"  '(comment-region :which-key "comment region"))

(my/general-define-key-template
 "d"  '(:which-key "docker")
 "db"  '(dockerfile-build-buffer :which-key "docker build buffer"))

(my/general-define-key-template
 "c"  '(calendar :which-key "calendar"))

 (my/general-define-key-template
  "i" '(:which-key "insert")
  "ie"'(emojify-insert-emoji :which-key "emoji" ))

;; https://emacs.stackexchange.com/questions/14909/how-to-use-flyspell-to-efficiently-correct-previous-word
(defun my/flyspell-correct-previous (&optional words)
  "Correct word before point, reach distant words.

WORDS words at maximum are traversed backward until misspelled
word is found.  If it's not found, give up.  If argument WORDS is
not specified, traverse 12 words by default.

Return T if misspelled word is found and NIL otherwise.  Never
move point."
  (interactive "P")
  (let* ((delta (- (point-max) (point)))
         (counter (string-to-number (or words "12")))
         (result
          (catch 'result
            (while (>= counter 0)
              (when (cl-some #'flyspell-overlay-p
                             (overlays-at (point)))
                (flyspell-correct-word-before-point)
                (throw 'result t))
              (backward-word 1)
              (setq counter (1- counter))
              nil))))
    (goto-char (- (point-max) delta))
    result))

(my/general-define-key-template
  "s" '(:which-key "spelling")
  "sw" '(flyspell-word :which-key "word")
  "sb" '(flyspell-buffer :which-key "buffer")
  "sn" '(flyspell-goto-next-error :which-key "next error")
  "sc" '(flyspell-correct-word-before-point :which-key "correct")
  "sa" '(flyspell-auto-correct-previous-word :which-key "auto correct prev")
  "sp" '(my/flyspell-correct-previous :whick-key "correct prev"))

(setq erc-spelling-mode 1)

 (my/general-define-key-template
  "E" '(erc :which-key "erc"))

(defun elfeed-eww-open (&optional use-generic-p)
  "open with eww"
  (interactive "P")
  (let ((entries (elfeed-search-selected)))
    (cl-loop for entry in entries
             do (elfeed-untag entry 'unread)
             when (elfeed-entry-link entry)
             do (eww-browse-url it))
    (mapc #'elfeed-search-update-entry entries)
    (unless (use-region-p) (forward-line))))

 (my/general-define-key-template
   "e" '(:which-key "elfeed")
   "ee" '(elfeed :which-key "elfeed")
   "eb" '(:which-key "browse url")
   "ebb" '(elfeed-search-browse-url :which-key "browse url")
   "ebe" '(elfeed-eww-open :which-key "browse url")
   "eu" '(elfeed-update :which-key "update")
   "es" '(elfeed-search-show-entry :which-key "show")
   "ef" '(elfeed-search-set-filter :which-key "filter"))

 (my/general-define-key-template
   "y" '(:which-key "yasnippet")
   "yn" '(yas-new-snippet :which-key "yasnippet")
   "ye" '(yas-expand :which-key "yasnippet")
   "yt" '(yas-tryout-snippet :which-key "yasnippet"))

(fset 'grep-to-list
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([65 backspace escape 48 100 119 86 120 107 111 34 S-insert escape 107 74 97 backspace escape 98 98 98 100 119 97 backspace 105 97 109 58 escape 65 44 escape 106 48] 0 "%d")) arg)))

(my/general-define-key-template
   "k" '(:which-key "keyboard macro")
   "kn" '(kmacro-name-last-macro :which-key "yasnippet")
   "kb" '(kmacro-bind-to-key :which-key "yasnippet")
   "ki" '(insert-kbd-macro :which-key "yasnippet")
   "ks" '(:which-key "stored")
   "ksg" '(grep-to-list :which-key "grep-to-list"))

(add-hook 'text-mode-hook #'auto-save-visited-mode)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

(fset 'yes-or-no-p 'y-or-n-p)

(setq flyspell-default-dictionary "english")
;; https://stackoverflow.com/questions/3961119/working-setup-for-hunspell-in-emacs
(setq ispell-dictionary-alist
  '((nil "[A-Za-z]" "[^A-Za-z]" "[']" t ("-d" "en_US") nil utf-8)))
  
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

 (setq-default major-mode 'org-mode)

(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))

 (setq org-bullets-bullet-list '("🔹" "▫" "🔸"))

(setq org-todo-keywords
      '((sequence ":x: TODO(t)" ":ballot_box_with_check: DONE(d)")
					; bug
        (sequence ":bug: BUG(b)" "|")
					; blocked unblocked
        (sequence ":red-circle: BLOCKED(B)" "| " ":yin-yang: UN-BLOCKED(u)")
					; Merge Request under review
        (sequence ":mag: REVIEW(r)" "|")
					; question question answered
        (sequence ":question: QUESTION(q)"  "|" ":grey-question: ANSWERED(Q)")
					; in progress
        (sequence ":construction-worker: IN-PROGESS(i)" "|")
					; "create gitlab issue for this"
        (sequence ":exclamation: ISSUE(I)" "|")
					; feature
        (sequence ":sparkles: FEATURE(f)" "|" )
					; chore
        (sequence ":tractor: CHORE(c)" "|" )
					; RESEARCH
        (sequence ":book: RESEARCH(R)" "|" )
					; delegated
        (sequence ":zap: DELEGATED(D)" "|" )
        (sequence ":eight_spoked_asterisk: DELEGATE(F)" "|" )
        (sequence ":pencil: RECORD(e)" "|" )))


(setq org-enforce-todo-dependencies t)

(setq org-hide-emphasis-markers t)

(setq org-html-checkbox-type 'html)
(setq org-src-preserve-indentation t)
(setq org-log-done 'time)
;; hack to make sure that archives get saved when being archived.
;; otherwise files just get the archive without saving. consequence is that this saves all org buffers but w.e
(add-hook 'org-archive-hook 'org-save-all-org-buffers)

(setq org-babel-default-header-args:typescript '((:cmdline . "--noImplicitAny --target ES2015 --module system --strict true")))
(setq org-babel-go-command "/usr/local/go/bin/go") 
(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (scheme . t)
   (lisp . t)
   (go . t)
   (typescript . t)
   (js . t)
   (python . t)))
   
(setq org-babel-python-command "python3")

(defun org-babel-tangle-collect-blocks-handle-tangle-list (&optional language tangle-file)
  "Can be used as :override advice for `org-babel-tangle-collect-blocks'.
Handles lists of :tangle files."
  (let ((counter 0) last-heading-pos blocks)
    (org-babel-map-src-blocks (buffer-file-name)
      (let ((current-heading-pos
             (org-with-wide-buffer
              (org-with-limited-levels (outline-previous-heading)))))
	(if (eq last-heading-pos current-heading-pos) (cl-incf counter)
	  (setq counter 1)
	  (setq last-heading-pos current-heading-pos)))
      (unless (org-in-commented-heading-p)
	(let* ((info (org-babel-get-src-block-info 'light))
               (src-lang (nth 0 info))
               (src-tfiles (cdr (assq :tangle (nth 2 info))))) ; Tobias: accept list for :tangle
	  (unless (consp src-tfiles) ; Tobias: unify handling of strings and lists for :tangle
            (setq src-tfiles (list src-tfiles))) ; Tobias: unify handling
	  (dolist (src-tfile src-tfiles) ; Tobias: iterate over list
            (unless (or (string= src-tfile "no")
			(and tangle-file (not (equal tangle-file src-tfile)))
			(and language (not (string= language src-lang))))
	      ;; Add the spec for this block to blocks under its
	      ;; language.
              (let ((by-lang (assoc src-lang blocks))
		    (block (org-babel-tangle-single-block counter)))
		(setcdr (assoc :tangle (nth 4 block)) src-tfile) ; Tobias: 
		(if by-lang (setcdr by-lang (cons block (cdr by-lang)))
		  (push (cons src-lang (list block)) blocks)))))))) ; Tobias: just ()
    ;; Ensure blocks are in the correct order.
    (mapcar (lambda (b) (cons (car b) (nreverse (cdr b)))) blocks)))

(defun org-babel-tangle-single-block-handle-tangle-list (oldfun block-counter &optional only-this-block)
  "Can be used as :around advice for `org-babel-tangle-single-block'.
If the :tangle header arg is a list of files. Handle all files"
  (let* ((info (org-babel-get-src-block-info))
	 (params (nth 2 info))
	 (tfiles (cdr (assoc :tangle params))))
    (if (null (and only-this-block (consp tfiles)))
	(funcall oldfun block-counter only-this-block)
      (cl-assert (listp tfiles) nil
		 ":tangle only allows a tangle file name or a list of tangle file names")
      (let ((ret (mapcar
		  (lambda (tfile)
		    (let (old-get-info)
		      (cl-letf* (((symbol-function 'old-get-info) (symbol-function 'org-babel-get-src-block-info))
				 ((symbol-function 'org-babel-get-src-block-info)
				  `(lambda (&rest get-info-args)
				     (let* ((info (apply 'old-get-info get-info-args))
					    (params (nth 2 info))
					    (tfile-cons (assoc :tangle params)))
				       (setcdr tfile-cons ,tfile)
				       info))))
			(funcall oldfun block-counter only-this-block))))
		  tfiles)))
	(if only-this-block
            (list (cons (cl-caaar ret) (mapcar #'cadar ret)))
	  ret)))))

(advice-add 'org-babel-tangle-collect-blocks :override #'org-babel-tangle-collect-blocks-handle-tangle-list)
(advice-add 'org-babel-tangle-single-block :around #'org-babel-tangle-single-block-handle-tangle-list)

(setq org-highest-priority ?1)
(setq org-lowest-priority ?4)
(setq org-default-priority ?4)

(setq org-priority-faces
      '((?1 . (:foreground "#c4676c"))
        (?2 . (:foreground "#ffff66"))
        (?3 . (:foreground "#ffffff"))
	(?4 . (:foreground "#9c6cd3"))))

(defun org-get-current-priority ()
  "Get the priority of the current item.
This priority is composed of the main priority given with the [#A] cookies,
and by additional input from the age of a schedules or deadline entry."
  (if (eq major-mode 'org-agenda-mode)
      (org-get-at-bol 'priority)
    (save-excursion
      (save-match-data
	(beginning-of-line)
	(and (looking-at org-heading-regexp)
	     (org-get-priority (match-string 0)))))))

(defun calculate-failure-rate (psucc time)
  "returns the failure rate of a task given the probability of success
   and estimated time to completion

  PSUCC is the probability of success, represented as a float
  TIME is the estimated time to completion, in minutes

  some tips on estimating probability of success:
  
  I am confident that this can be done and that there are no unforeseen
  difficulties (~95%)

  I am confident that this can be done modulo Murphy's law (~90%)

  I see the basic path to accomplishing this and all the steps seem
  like they should work (~65%)

  I have the intuition that this should be possible but only have a 
  murky view of the path (~30%)"

  (/ (log (/ 1 psucc)) time))

(defun all-failure-rate-subheading ()
    (org-map-entries
     '(string-to-number
       (org-entry-get  nil "FailureRate")) "FailureRate={.}" 'tree))

(defun sum-failure-rate ()
  (apply '+ (all-failure-rate-subheading)))

(defun calculate-failure-rate-for-heading ()
  (interactive)
  (org-set-property
   "FailureRate"
   (number-to-string
    (calculate-failure-rate
     (/ (string-to-number
	 (org-entry-get nil "ProbabilitySuccess"))
	(float 100))
     (to-integer-mins (org-entry-get nil "Effort"))))))
 
(defun aggregate-failure-rate-for-heading ()
  ;; sum here because failure rates are represented as independent 
  ;; poisson proccesses
  (interactive)
  (org-set-property "FailureRate" "") ;; clear value in case already set
  (org-set-property "FailureRate"
		    (number-to-string (sum-failure-rate)))
  (org-set-property "AggregateFailureRate" "t"))

(setq org-confirm-babel-evaluate 'nil)

(defun org-schedule-effort ()
  ;; https://stackoverflow.com/questions/23044588/org-mode-creation-time-range-from-effort-estimate
  (interactive)
  (save-excursion
    (org-back-to-heading t)
    (let* ((element (org-element-at-point))
           (effort (org-element-property :EFFORT element))
           (scheduled (org-element-property :scheduled element))
           (ts-year-start (org-element-property :year-start scheduled))
           (ts-month-start (org-element-property :month-start scheduled))
           (ts-day-start (org-element-property :day-start scheduled))
           (ts-hour-start (org-element-property :hour-start scheduled))
           (ts-minute-start (org-element-property :minute-start scheduled)))
      (when (and effort scheduled ts-hour-start)
	(org-schedule nil (concat
			   (format "%s" ts-year-start)
			   "-"
			   (if (< ts-month-start 10)
			       (concat "0" (format "%s" ts-month-start))
			     (format "%s" ts-month-start))
			   "-"
			   (if (< ts-day-start 10)
			       (concat "0" (format "%s" ts-day-start))
			     (format "%s" ts-day-start))
			   " "
			   (if (< ts-hour-start 10)
			       (concat "0" (format "%s" ts-hour-start))
			     (format "%s" ts-hour-start))
			   ":"
			   (if (< ts-minute-start 10)
			       (concat "0" (format "%s" ts-minute-start))
			     (format "%s" ts-minute-start))
			   "+"
			   effort))))))

(setq org-global-properties
      '(("Effort_ALL" . "0:15 0:30 0:45 1:00 1:30 2:00 2:30 3:00 3:30 4:00")))

(setq org-src-window-setup 'current-window)

(setq org-pomodoro-length 30)

(when (not (getenv "CI")) (require 'org-tempo))

(setq org-capture-templates
      '(("t" "TODO" entry
	 (file "~/Sync/org/roam/20200614114256-todo.org") "* %?")
	("j" "Journal" entry
	 (file "~/Sync/org/roam/20200614114326-journal.org") "* %U\n  %i\n%?")))

(require 'org-protocol)

(require 'org-roam-protocol)

(setq org-roam-ref-capture-templates
      '(("r" "ref" plain (function org-roam-capture--get-point)
	 "%?"
	 :file-name "${slug}"
	 :head "#+TITLE: ${title} \n#+ROAM_KEY: ${ref} \n- tags :: "
	 : unnarrowed t)))

(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.33))

(setq org-babel-python-command "~/anaconda3/bin/python")
(setenv "PYTHONPATH"	"~/anaconda3/bin")

(setq org-super-agenda-groups
	  '(;; Each group has an implicit boolean OR operator between its selectors.
		(:name ":zap: DELEGATED"
               :todo ":zap: DELEGATED"
               )
		(:name ":red-circle: BLOCKED"
               :todo ":red-circle: BLOCKED"
               )
		(:name ":construction-worker: IN PROGRESS"
               :todo ":construction-worker: IN-PROGESS"
               )
		(:name ":stopwatch: Overdue"
               :deadline past
               :scheduled past
               )
		(:name ":calendar: Today"
               :deadline today
               :scheduled today
               )
		(:name ":first_place: Urgent Important/ DO"
               :priority "1"
			   )
		(:name ":second_place: Not Important Urgent/ DELEGATE"
               :priority "3"
			   )
		(:name ":third_place: Important Not Urgent/ SCHEDULE"
               :priority "2"
			   )
		(:name "Upcoming"
               :deadline future
               :scheduled future
			   )))

(org-super-agenda-mode)
(setq org-agenda-prefix-format '((agenda . "        ") (todo . " %i %-12:c") (tags . " %i %-12:c") (search . " %i %-12:c")))
(setq org-agenda-custom-commands
      '(("b" "With deadline columns" alltodo ""
         ((org-agenda-overriding-columns-format "%60ITEM %EFFORT %10FailureRate %1PRIORITY %TODO")
          (org-agenda-view-columns-initially t)))))

(defun my/org-add-ids-to-headlines-in-file ()
  "Add ID properties to all headlines in the current file which
do not already have one."
  (interactive)
  (when (member (replace-regexp-in-string "^\\/\\w+\\/\\w+" "~" (buffer-file-name)) (org-roam--list-files org-roam-directory))
  (org-map-entries 'org-id-get-create)))


(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'my/org-add-ids-to-headlines-in-file nil 'local)))

(defun my/tangle-dotfiles-on-save ()
 (interactive)
 (when (and (string-prefix-p (concat (getenv "HOME") "/dotfiles") (buffer-file-name))
			(string-suffix-p ".org" (buffer-file-name)))
   (org-babel-tangle)))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook 'my/tangle-dotfiles-on-save)))

(setq org-image-actual-width nil)

(setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)

(add-hook 'org-capture-mode-hook 'delete-other-windows)

(setq tramp-default-method "ssh")

(use-package go-mode :ensure t)

(use-package go-autocomplete :ensure t)

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell
	 (replace-regexp-in-string
	  "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

(setenv "GOPATH" "/home/rob/go")
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/go/bin"))
(setenv "PATH" (concat (getenv "PATH") ":/home/rob/go/bin"))

(add-to-list 'exec-path "/usr/local/go/bin")
(add-hook 'before-save-hook 'gofmt-before-save)

(defun auto-complete-for-go ()
  (auto-complete-mode 1))
 (add-hook 'go-mode-hook 'auto-complete-for-go)

(defun auto-complete-for-go ()
  (auto-complete-mode 1))
 (add-hook 'go-mode-hook 'auto-complete-for-go)

(with-eval-after-load 'go-mode (require 'go-autocomplete))

(my/general-define-key-template
 "lg"  '(:which-key "golang keybindings")
 "lgd"  '(godef-jump :which-key "goto definition")
 "lgD"  '(godef-describe :which-key "Describe"))

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 1)))

(defun org-html-fontify-code (code lang)
  "Color CODE with htmlize library.
CODE is a string representing the source code to colorize.  LANG
is the language used for CODE, as a string, or nil."
  (when code
    (cond
     ;; Case 1: No lang.  Possibly an example block.
     ((not lang)
      ;; Simple transcoding.
      (org-html-encode-plain-text code))
     ;; Case 2: No htmlize or an inferior version of htmlize
     ((not (and (require 'htmlize nil t) (fboundp 'htmlize-region-for-paste)))
      ;; Emit a warning.
      (message "Cannot fontify src block (htmlize.el >= 1.34 required)")
      ;; Simple transcoding.
      (org-html-encode-plain-text code))
     (t
      ;; Map language
      (setq lang (or (assoc-default lang org-src-lang-modes) lang))
      (let* ((lang-mode (and lang (intern (format "%s-mode" lang)))))
	(cond
	 ;; Case 1: Language is not associated with any Emacs mode
	 ((not (functionp lang-mode))
	  ;; Simple transcoding.
	  (org-html-encode-plain-text code))
	 ;; Case 2: Default.  Fontify code.
	 (t
	  ;; htmlize
	  (setq code (with-temp-buffer
		       ;; Switch to language-specific mode.
		       (funcall lang-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                       (when (require 'fill-column-indicator nil 'noerror)
                         (fci-mode -1))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		       (insert code)
		       ;; Fontify buffer.
		       (font-lock-fontify-buffer)
		       ;; Remove formatting on newline characters.
		       (save-excursion
			 (let ((beg (point-min))
			       (end (point-max)))
			   (goto-char beg)
			   (while (progn (end-of-line) (< (point) end))
			     (put-text-property (point) (1+ (point)) 'face nil)
			     (forward-char 1))))
		       (org-src-mode)
		       (set-buffer-modified-p nil)
		       ;; Htmlize region.
		       (org-html-htmlize-region-for-paste
			(point-min) (point-max))))
	  ;; Strip any enclosing <pre></pre> tags.
	  (let* ((beg (and (string-match "\\`<pre[^>]*>\n*" code) (match-end 0)))
		 (end (and beg (string-match "</pre>\\'" code))))
	    (if (and beg end) (substring code beg end) code)))))))))

(defun to-integer-mins (s)
  "Convert a string in HH:MM format to integer minutes."
  (if s
      (seq-reduce
       (lambda (x y) (+ y (* x 60)))
       (mapcar #'string-to-number (split-string s ":")) 0)
    0))

(setq-default custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(with-eval-after-load 'outline
  (add-hook 'ediff-prepare-buffer-hook #'org-show-all))

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(defun copy-buffer-file-name ()
  (interactive)
  (let ((path (buffer-file-name)))
	(when path (kill-new path))))

(defun copy-buffer-file-name-org-link (description)
  (interactive "sDescription: ")
  (let ((path (buffer-file-name)))
	(when path (kill-new (format "[[%s][%s]]" path description)))))

(defun shrug ()
  (interactive) (insert "¯\\_(ツ)_/¯"))

(defun replace-in-string (what with in)
  (replace-regexp-in-string (regexp-quote what) with in nil 'literal))

(setq org-agenda-files (directory-files-recursively "~/Sync/org/roam/" "\\.org$"))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

(my/load-default-theme)
