(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "unknown" :slant normal :weight normal :height 150 :width normal))))
 '(Info-quoted ((t (:family "FreeMono"))))
 '(org-level-5 ((t (:inherit outline-7))))
 '(org-level-6 ((t (:inherit outline-8))))
 '(org-level-7 ((t (:inherit outline-5))))
 '(org-level-8 ((t (:inherit outline-6)))))




;; Package management commands
(require 'package)

  (push '("marmalade" . "http://marmalade-repo.org/packages/")
        package-archives )
  (push '("melpa" . "http://melpa.milkbox.net/packages/")
        package-archives)
  (package-initialize)




;; general settings
;; (setq debug-on-error nil)
(fringe-mode 0)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(display-battery-mode)
(column-number-mode)
(display-time-mode 1)
(define-key help-map "a" 'apropos)
(setq backup-directory-alist
      `((".*" . "~/emacsTempFiles")))
(setq-default indent-tabs-mode nil)
(add-to-list 'Info-default-directory-list "/usr/share/info/matplotlib_info/")
(setq require-final-newline nil)
(setq mode-require-final-newline nil)   ;Apparently just the above command is not sufficient. This is also needed.
(setq save-interprogram-paste-before-kill 'copyClipboard)
(global-auto-revert-mode 1)
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; adjust transpose-chars to switch previous two characters. Courtesy: http://pragmaticemacs.com/emacs/transpose-characters/
(global-set-key (kbd "C-t")
                (lambda ()
                  (interactive)
                  (let ((original-position (point)))
                    (backward-char)
                    (while (equal (string (char-after (point))) " ")
                      (backward-char))
                    (transpose-chars 1)
                    (goto-char original-position))))
;; Cute. This is nice. I had a problem with C-t but I didn't think of this.
;; I can also do this now: NOTE: This doesn't work in org-mode because, org-mode maps M-t to org-transpose-words.
(global-set-key (kbd "M-t")
                (lambda ()
                  (interactive)
                  (backward-word)
                  (transpose-words 1)))

(global-set-key (kbd "M-c")
                (lambda ()
                  "We want M-c to work as usual but similar to M-t. More specifically, it must go to the word before the cursor, capitalise or lowerise it and come back to where we were"                      
                  (interactive)
                  (let ((original-position (point)))
                    (backward-word)
                    (capitalize-word 1)
                    (goto-char original-position))))

;; Super. Idea from [[http://pragmaticemacs.com/emacs/toggle-between-most-recent-buffers/][Pragmatic Emacs]].
(global-set-key (kbd "C-z") (lambda ()
                              (interactive)
                              (switch-to-buffer (other-buffer (current-buffer) 1))))


(global-set-key (kbd "C-1") 'delete-other-windows)
(global-set-key (kbd "C-0") 'delete-window)
(global-set-key (kbd "C-2") 'split-window-below)
(global-set-key (kbd "C-3") 'split-window-right)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-r") 'isearch-backward)


;; (set 'kill-whole-line 'nonNil)
;; Buffer key bindings

(global-set-key (kbd "C-x k") 'kill-this-buffer)
(show-paren-mode 1)
(set 'show-paren-delay 0)
;; (global-set-key (kbd "C-m") 'backward-delete-char-untabify)
(set 'mode-require-final-new-line nil)	;If this is not nil (by default it is t), then everytime a file is saved, in some modes (which ask for it), a new line is added to the file (if no trailing newlines exist). I don't want this. Even if it is required, I'll take care of it myself

(setenv "PAGER" "cat")	      ;So that things like pydoc use cat pager instead of less pager
(setenv "GIT_PAGER" "")			;So that `git log' doesn't use cat pager
(set 'python-shell-interpreter "python3.5")



;; copied from http://www.emacswiki.org/emacs/UnfillParagraph
(defun unfill-paragraph (&optional region)
      "Takes a multi-line paragraph and makes it into a single line of text."
      (interactive (progn (barf-if-buffer-read-only) '(t)))
      (let ((fill-column (point-max)))
        (fill-paragraph nil region)))

(global-set-key (kbd "M-Q") 'unfill-paragraph)



;; Copied from https://github.com/sri/dotfiles/blob/master/emacs/emacs.d/my-fns.el#L236
(defun my-find-file-as-sudo ()
  (interactive)
  (let ((file-name (buffer-file-name)))
    (when file-name
      (find-alternate-file (concat "/sudo::" file-name)))))


(global-set-key (kbd "C-x C-v") 'my-find-file-as-sudo)

;; Org mode settings
(setq org-agenda-start-with-follow-mode t)
(set 'org-hide-leading-stars 'hideEmAll)
(set 'org-log-done 'time)
(add-hook 'org-mode-hook (lambda ()
			   ""
			   (interactive)
			   (set 'truncate-lines nil)
			   (set 'left-margin-width 30)
			   (set 'right-margin-width 30) ;These are because normal text looks nice with less line width. There are, on this screen 136 chars/line. It is recommended to use 60-70 chars per line. With these settings, I use 66 chars per line.
			   (set 'word-wrap 'someNonNil)
			   (local-set-key (kbd "C-c a") 'org-agenda))) ; Truncating lines and word wrapping seem good for plain text files.
(set 'org-default-notes-file "~/notes.org")
(define-key global-map (kbd "C-c t") 'org-capture)
(set 'org-capture-templates '(("t" "Todo"
			       plain (file "") ;No file name so that it uses org-default-notes-file
			       "* TODO %?%i\n  %a")))
(set 'org-src-fontify-natively t)


;; Taken from http://orgmode.org/manual/Breaking-down-tasks.html
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
(set 'org-agenda-files (list "~/notes.org"))
(setq org-agenda-start-on-weekday nil)



(add-to-list 'load-path "~/.emacs.d/org/contrib/lisp")
(require 'org-drill)                  
(set 'org-drill-right-cloze-delimiter ">")
(set 'org-drill-right-cloze-delimiter "<")
(setq org-drill-hide-item-headings-p t)
(setq org-drill-maximum-items-per-session nil)
(setq org-drill-maximum-duration nil)   ; 30 minutes
(setq org-drill-save-buffers-after-drill-sessions-p nil)


;; Newsticker settings
(add-hook 'newsticker-treeview-item-mode-hook (lambda ()
						(set 'truncate-lines nil)
						(set 'word-wrap 'someNonNil)))

(set 'newsticker-retrieval-interval (* 5 3600)) ;Retrieve once every 5 hrs. I would not have a problem even with 10hrs. Just putting 5 that's it
;; Stardict settings



(defun lookupFunction ()
  "This function looks up the word `INPUT' in the list of dictionaries. stardict package itself puts the result in a buffer by name *Dict*. This function also displays that buffer"
  (interactive)
  (let ((input (completing-read "input: " (apply 'completion-table-merge (mapcar (lambda (element)
										   (nth 1 element))
										 listOfDicts)))))
    (message input)
    (if (get-buffer "*Dict*")
        (with-current-buffer "*Dict*"
          (view-mode -1)))
    (stardict-lookup-list listOfDicts input)
    (display-buffer "*Dict*" '(display-buffer-reuse-window . '()))
    (with-current-buffer "*Dict*"
      (view-mode))))



(add-to-list 'load-path "~/.emacs.d/stardict")
(load "stardict")
(set 'sabdakalpadruma (stardict-open "~/.emacs.d/stardict/dict files/sabdakalpadruma" "sabdakalpadruma"))
(set 'apte (stardict-open "~/.emacs.d/stardict/dict files/apte" "apte"))
(set 'dhatupatha (stardict-open "~/.emacs.d/stardict/dict files/dhatupatha" "dhatupatha"))
(set 'vachaspatyam (stardict-open "~/.emacs.d/stardict/dict files/vachaspatyam" "vachaspatyam"))
(set 'mw-itrans-dev (stardict-open "~/.emacs.d/stardict/dict files/mw-itrans-dev" "mw-itrans-dev"))
(set 'apte-bi (stardict-open "~/.emacs.d/stardict/dict files/apte-bi" "apte-bi"))

(set 'listOfDicts (list sabdakalpadruma apte dhatupatha vachaspatyam mw-itrans-dev apte-bi))

 (set 'jnuTiNanta (stardict-open "~/.emacs.d/stardict/dict files/jnu-tiNanta" "jnu-tiNanta"))
;; Format of apte would be '(ifo-hash idx-hash dictFile)
 (stardict-lookup-list (list sabdakalpadruma apte dhatupatha vachaspatyam mw-itrans-dev) "shii")

(global-set-key (kbd "C-c d s") 'lookupFunction)

;; (nth 1 jnuTiNanta)


;; Gnus settings
;; (gnus-demon-init)
;; (gnus-demon-add-handler 'gnus-demon-scan-news 2 t) ; this does a call to gnus-group-get-new-news
(setq gnus-use-cache t)
(defface my-gnus-summary-sender-face '()
         "This face is to be used for gnus summary buffer in sender")
(set-face-foreground 'my-gnus-summary-sender-face "DarkCyan")

(setq gnus-face-4 'my-gnus-summary-sender-face)
(setq gnus-thread-sort-functions '((not gnus-thread-sort-by-date)))

;; solarized theme settings

(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized-master")
(load-theme 'solarized t)              


;; EMMS setup
(add-to-list 'load-path "~/.emacs.d/emms/lisp")
(require 'emms-setup)                  
(emms-all)
(emms-default-players)


(setq emms-info-asynchronously nil)
(setq emms-playlist-buffer-name "*Music*")
(set 'emms-source-file-directory-tree-function 'emms-source-file-directory-tree-find)
(set 'emms-source-file-default-directory "~/Music")
(global-set-key (kbd "C-c m r") 'emms-random) ; start playing random song. 
(global-set-key (kbd "C-c m f") 'emms-seek-forward) ; seek 10s forward. 

(global-set-key (kbd "C-c m b") 'emms-seek-backward) ; seek 10s backward. 

(global-set-key (kbd "C-c m t") 'emms-pause) ; This name is misleading. This actually toggles the play/pause. See the source code.
;; Windmove settings
(global-set-key (kbd "s-n") 'windmove-down)
(global-set-key (kbd "s-p") 'windmove-up)
(global-set-key (kbd "s-f") 'windmove-right)
(global-set-key (kbd "s-b") 'windmove-left)


;; Yasnippet mode

(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)


;; Compilation commands
(defun compileComp()
  (interactive)
  "Compile the current file using g++. This has to be used only on .cpp files"
  (basic-save-buffer)
  (compile (concat "g++ -Wall -Wconversion -g3 " buffer-file-name)))

(global-set-key (kbd "C-c c") 'compileComp)

(defun runComp()
  (interactive)
  "We want to get a new window at the bottom half of the window and then give it the user input in that window and also see the error in that window. For this we can use terminal mode and instead of running shell, we run a.out program :). r for Run"
  (split-window-below)
  (switch-to-buffer-other-window (current-buffer))
  (set-buffer (make-term "terminal" (concat default-directory "a.out")))
  (term-mode)
  (term-line-mode)
  (switch-to-buffer "*terminal*")
  (set-process-sentinel (get-buffer-process (current-buffer)) 'my-term-sentinel)) ;;this makes sure that we start in line mode. So that C-c e works even there. Now what is remaining is that we have to start the program again once it is finished. I can just call (term "./a.out") instead of all these, but I'm doing these just because I have to use line-mode
					;				(term "./a.out")))


(defun closeOnSuccess (processStatus, exitStatus, exitMessage)
  ;; (interactive)
  (when (and (eq processStatus 'exit)
	     (zerop exitStatus))
    (bury-buffer)
    (delete-window (get-buffer-window (get-buffer "*compilation*")))
    (runComp))
  (cons exitMessage exitStatus))


(global-set-key (kbd "C-c r") (lambda ()
				(interactive)
				;; (set 'compilation-exit-message-function 'closeOnSuccess)
				;; (compileComp)
				(runComp)
				;; (set 'compilation-exit-message-function nil)))
				))
		



(defun my-term-sentinel (proc msg)
  "Sentinel for term buffers.
The main purpose is to get rid of the local keymap."
  (let ((buffer (process-buffer proc)))
    (when (memq (process-status proc) '(signal exit))
      (if (null (buffer-name buffer))
	  ;; buffer killed
	  (set-process-buffer proc nil)
	(with-current-buffer buffer
          ;; Write something in the compilation buffer
          ;; and hack its mode line.
          ;; Get rid of local keymap.
       ;;   (use-local-map nil)
          (term-handle-exit (process-name proc) "------------------------------------\n\n")
          ;; Since the buffer and mode line will show that the
          ;; process is dead, we can delete it now.  Otherwise it
          ;; will stay around until M-x list-processes.
	  ;; (delete-process proc)
	  (term-exec (current-buffer) "terminal" (concat default-directory "a.out") nil nil)
	  (set-process-sentinel (get-buffer-process (current-buffer)) 'my-term-sentinel)))))) ;;this sentinel instead of printing "process finished message", restarts the process. Hola it works. But be careful while making any more changes. Note that I used term-exec here and make-term in the previous one because, make-term creates a new buffer while this does not.
	  

				

(global-set-key (kbd "C-c e") (lambda ()
				(interactive)
				"This should kill the current buffer, close the current window. e for Exit. This command is very easy to be run mistakenly. We have to run this only if the current buffer name is *terminal*"
				(if (equal (buffer-name (current-buffer)) "*terminal*")
				    (progn
				      (set-process-sentinel (get-buffer-process (current-buffer)) 'term-sentinel)
				      (delete-process (get-buffer-process (current-buffer)))
				      (kill-buffer-and-window)) ;;if we just say kill-buffer-and-window, the function `process-kill-buffer-query-function` present in `kill-buffer-query-functions` is called and it asks for confirmation of killing the current process. We don't want to write yes all the time. So we delete the process first. But since we put the sentinel as the one that restarts the process each time it is killed, we restore the original sentinel
				  (message "Did you mean C-c r?"))))







;; Miscellaneous customizations

;; Original idea from
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))




(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))


(defadvice kill-ring-save (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; By default C-w will kill the selected region. With this advice if no region is selected, C-w will kill the current line

;; Similarly M-w used to save the selected region to kill-ring (without killing). With this advice, if no region is selected, M-w will save the current line without killing





(global-set-key "\M-;" 'comment-dwim-line) 


;; (defun forward-block (&optional arg direction)
;;   "This is useful for defining `block' as a `thing'.
;; Ideally, this should handle errors gracefully, but it is still
;; under development"
;;   (or arg (setq arg 1))
;;   (or direction (setq direction 'forward))
;;   (if (> arg 0)
;;       (progn
;;         (up-list)
;;         (while (not (equal (string (char-before)) "}"))
;;           (up-list))
;;         (forward-block (- arg 1) 'backward)))
;;   (if (< arg 0)
;;       (progn
;;         (up-list -1)
;;         (while (not (equal (string (char-after)) "{"))
;;           (up-list -1))
;;         (forward-block (+ arg 1))))
;;   (if (= arg 0)
;;       (if (equal direction 'forward)
;;           (forward-char)
;;         (backward-char))))
      
;; This works but the problem is that after one forward-block, the cursor is after a }. specifically, it has crossed the boundaries of the block. So when we call the forward-block again with -1 as argument, it might give an error. So, what we do is after everything is over, we move if one-step forward or backward. In moving forward (forward-block with +ve argument, we have to move the point backward by 1). In moving backward, we have to move it one forward.

;; So finally how this works is that, we move forward but always remaining inside the final block.

(defun commentBlock ()
  (interactive)
  "This is supposed to comment a block that starts at current line in C++. I have yet to write the uncommenting part."
  ;; (set 'endPosition (progn
		       ;; (save-excursion
			 ;; (move-end-of-line 1)
			 ;; (point))))
  (save-excursion
    (move-beginning-of-line 1)
    (set 'begPosition (point))
    (move-end-of-line 1)
    (set 'endPosition (point)))
  (search-forward "{" endPosition)
  (backward-up-list)
  (forward-sexp)
  (comment-region begPosition (point)))


;; (progn
;;   (move-end-of-line 1)
;;   (point))

(global-set-key (kbd "C-c s") 'commentBlock)



;; (defun writeCin (stringList)
;;   "`stringList' is a list of strings like (s1 s2 s3). 
;; The output will be 'cin >> s1 >> s2 >> s3'.
;; This can be directly inserted into buffer"
;;   (concat "cin" (apply 'concat
;; 		       (mapcar (lambda (a)
;; 				 (concat " >> " a))
;; 			       stringList))
;; 	  ";"))


;; I used this function in C++ mode. See c++-mode-hook. 


;; (defun cin ()
;;   (interactive)
;;   (let ((currentLine (thing-at-point 'line 'noProperties)))
;;     (kill-whole-line)
;;     (insert (writeCin (org-split-string currentLine)))
;;     (c-indent-line-or-region)
;;     (newline)
;;     (newline)
;;     (previous-line)
;;     (c-indent-line-or-region)))

;; (global-set-key (kbd "C-c C-i C-n") 'cin)  


(set 'c++-mode-hook nil)
(add-hook 'c++-mode-hook (lambda ()
                           ;; I no longer use this. Anyway, this was a
                           ;; stupid one
			   ;; (local-set-key (kbd "C-c C-i C-n") 'cin)
			   (local-set-key (kbd "C-c s") 'commentBlock)
                           (local-set-key (kbd "M-j") 'backward-sexp)
                           (local-set-key (kbd "M-k") 'forward-sexp)
                           (local-set-key (kbd "M-h") 'down-list)
                           (local-set-key (kbd "M-l") 'up-list)))















;; Org mode commands



;; LaTeX mode
;; (add-to-list 'load-path "~/.emacs.d/elpa/latex-preview-pane-20140205/")
;; (add-to-list 'load-path "~/latex-preview-pane")


;; Gnu Global
(add-to-list 'load-path "~/.emacs.d/gtags/")
(autoload 'gtags-mode "gtags" "" t)
(add-hook 'gtags-select-mode-hook
	  (lambda ()
	     (setq hl-line-face 'underline)
	     (hl-line-mode 1)))
(set 'gtags-suggested-key-mapping t)
(set 'gtags-auto-update t)



;; Minibuffer settings

;; (defun upperLevel (string)
;;   "This is supposed to be used in minibuffer. It does the following conversions
;; /home/nitish/name -> /home/nitish/
;; /home/nitish/ -> /home/

;; Indirectly it kills the file part of it."
;;   (interactive)
;;   (if (string-suffix-p "/" string)
;;       (file-name-directory (substring string 0 -1))
;;     (file-name-directory string)))

;; (add-hook 'minibuffer-setup-hook (lambda ()
;; 				  (interactive)
;; 				  (local-set-key (kbd "C-q")
;; 						  (lambda ()
;; 						    (interactive)
;; 						    (let ((oldString (minibuffer-contents))) ;; There is a direct function `minibuffer-contents' to obtain the contents of the minibuffer
;; 						      (delete-minibuffer-contents) ;; we cannot use erase-buffer because some part of the minibuffer is read only.
;; 						      (insert (upperLevel oldString)))))))

;; I'm going to use ido mode. It is very fast. Then I don't need this function. I can just press <Backspace> to go up a folder. Anyway, it served me very well :D



;; Emacs Server settings
(server-start)




;; (set 'minibuffer-setup-hook nil)
;; (add-hook 'minibuffer-setup-hook 'minibuffer-history-initialize)
;; (add-hook 'minibuffer-setup-hook 'minibuffer-history-isearch-setup)
;; (add-hook 'minibuffer-setup-hook 'rfn-eshadow-setup-minibuffer)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default-input-method "german-postfix")
 '(display-battery-mode t)
 '(display-time-mode t)
 '(newsticker-url-list
   (quote
    (("Android Developers Blog" "http://android-developers.blogspot.in/" nil nil nil)
     ("Planet Emacsen" "planet.emacsen.org" nil nil nil)
     ("Planet Emacsen" "http://planet.emacsen.org/atom.xml" nil nil nil)
     ("New Planet Emacsen" "http://planet.emacsen.org/atom.xml" nil nil nil)
     ("Pragmatic Emacs" "http://pragmaticemacs.com/feed/" nil nil nil)
     ("Realtime Rendering" "http://www.realtimerendering.com/blog/feed/" nil nil nil)
     ("Arch Linux Updates" "https://www.archlinux.org/feeds/news/" nil nil nil)
     ("Emacs Movies" "http://emacsmovies.org/atom.xml" nil nil nil)
     ("What the .emacs.d" "http://whattheemacsd.com/atom.xml" nil nil nil)
     ("Kultur" "http://www.nachrichtenleicht.de/kultur.2006.de.rss" nil nil nil)
     ("Nachrichten" "http://www.nachrichtenleicht.de/nachrichten.2005.de.rss" nil nil nil)
     ("Vermischtes" "http://www.nachrichtenleicht.de/vermischtes.2007.de.rss" nil nil nil)
     ("Sport" "http://www.nachrichtenleicht.de/sport.2004.de.rss" nil nil nil)
     ("Gnuplotting" "http://www.gnuplotting.org/feed/" nil nil nil)
     ("Programming Praxis" "http://programmingpraxis.com/feed/" nil nil nil)
     ("Emacs Doctor" "http://emacs-doctor.com/feed.xml" nil nil nil)
     ("Placements" "http://placements.iitb.ac.in/blog/?feed=rss2" nil nil nil)
     ("Commitstrip" "http://www.commitstrip.com/en/feed/" nil nil nil)
     ("Netzpolitik" "https://netzpolitik.org/feed" nil nil nil)
     ("Quanta Magazine" "https://www.quantamagazine.org/feed/" nil nil nil)
     ("Erfolgreiches Sprachelernen" "http://erfolgreichessprachenlernen.com/feed/" nil nil nil)
     ("Sprachheld" "http://sprachheld.de/feed/podcast/" nil nil nil)
     ("planet kernel" "http://planet.kernel.org/rss20.xml" nil nil nil))))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-info org-irc org-mhe org-rmail org-w3m)))
 '(package-selected-packages
   (quote
    (latex-preview-pane debbugs yasnippet pdf-tools "magit" magit emms)))
 '(send-mail-function (quote smtpmail-send-it))
 '(show-paren-mode t)
 '(smtpmail-smtp-server "smtp-auth.iitb.ac.in")
 '(smtpmail-smtp-service 25)
 '(tool-bar-mode nil))


;; Shell related applications



(defun runCommand (commandString)
  "This function doesn't do any error checking. Runs the command `commandString' in the existing shell process."
  (with-current-buffer "*shell*"
    (let* ((proc (get-buffer-process (current-buffer)))
           (pmark (process-mark proc))
           (input (buffer-substring pmark (point-max))))
      (kill-region pmark (point-max))
      (insert commandString)
      (comint-send-input)
      (insert input))))




(defun runAsProcess ()
  (let* ((proc (get-buffer-process (current-buffer)))
	 (pmark (process-mark proc))
	 (input (buffer-substring pmark (point-max))))
    (kill-region pmark (point-max))
    (shell-command (concat input " &"))))



(set 'shell-mode-hook nil)

(add-hook 'shell-mode-hook (lambda ()
			     (interactive)
			     ;; (local-set-key (kbd "C-,") (lambda ()
                             ;;                              (interactive)
                             ;;                              (let* ((proc (get-buffer-process (current-buffer)))
                             ;;                                      (pmark (process-mark proc))
                             ;;                                      (input (buffer-substring pmark (point-max))))
                             ;;                                   (kill-region pmark (point-max))
                             ;;                                   (insert (concat input " > output.out")))))
                             ;; I am commenting these because, these are no longer useful to me. This dired one is useful though
                             ;; (runCommand "ls")))
                             (local-set-key (kbd "C-,") (lambda ()
                                                          (interactive)
                                                          (dired default-directory)
                                                          (revert-buffer)))
			     (local-set-key (kbd "C-.") (lambda ()
							  (interactive)
							  (runCommand "cd ..")))
			     (local-set-key (kbd "C-<return>") (lambda ()
							       (interactive)
							       (runAsProcess)))
                             (local-set-key (kbd "M-,") (lambda ()
                                                          (interactive)
                                                          (progn
                                                            (previous-line)
                                                            (move-end-of-line 1)
                                                            (re-search-backward "^.*\\$ ")
                                                            (re-search-forward "\\$[ \\t]*"))))
                             (local-set-key (kbd "M-.") (lambda ()
                                                          (interactive)
                                                          (re-search-forward "^.*\\$ ")))))


(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)


(add-hook 'after-init-hook (lambda ()
			     (shell)))



(defun my-comint-previous-input (original-comint-function arg)
  "Cycle backwards through input history, saving input."
  (interactive "*p")
  (let* ((pmark (process-mark (get-buffer-process (current-buffer))))
	 (input (buffer-substring pmark (point)))
	 (current-position (point)))
    ;; (comint-previous-matching-input (concat "^" input) 1))
    (if (and comint-input-ring-index
	     (or		       ;; leaving the "end" of the ring
	      (and (< arg 0)		; going down
		   (eq comint-input-ring-index 0))
	      (and (> arg 0)		; going up
		   (eq comint-input-ring-index
		       (1- (ring-length comint-input-ring)))))
	     comint-stored-incomplete-input)
	(comint-restore-input)
      (comint-previous-matching-input (concat "^" input) arg)
      (goto-char current-position))))





(advice-add 'comint-previous-input :around #'my-comint-previous-input)






;; Dired mode

(set 'dired-mode-hook nil)
(add-hook 'dired-mode-hook (lambda ()
			     (local-set-key (kbd "r") 'dired-up-directory)
                             (local-set-key (kbd "C-,") (lambda ()
                                                          (interactive)
                                                          (if (not (equal (expand-file-name default-directory)
                                                                          (with-current-buffer "*shell*"
                                                                            (expand-file-name default-directory))))
                                                              (runCommand (concat "cd " default-directory)))
                                                          (switch-to-buffer "*shell*")))
			     (hl-line-mode)))
(put 'narrow-to-region 'disabled nil)



;; These lines, make the last 2 marks (most recent ones on mark ring)
;; visible in different faces. The red one is the most recent one and
;; yellow one is the one previous to the red one. Keep these for some
;; days so as to get the idea of which commands put a mark.
;; (defface visible-mark-active ;; put this before (require 'visible-mark)
  ;; '((((type tty) (class mono)))
    ;; (t (:background "magenta"))) "")

;; (require 'visible-mark)

;; (global-visible-mark-mode 1) ;; or add (visible-mark-mode) to specific hooks
;; (setq visible-mark-max 2)
;; (setq visible-mark-faces `(visible-mark-face1 visible-mark-face2))


;; Ido mode
(ido-mode t)
;; Remember, if you want to open a directory in dired-mode, press C-d when ido is active


;; Magit mode
(global-set-key (kbd "C-x g") 'magit-status)


;; Language input

(add-hook 'input-method-activate-hook (lambda ()
                                        (if (equal current-input-method "german-postfix")
                                            (quail-define-rules
                                             ("AE" ?Ä)
                                             ("ae" ?ä)
                                             ("OE" ?Ö)
                                             ("oe" ?ö)
                                             ("UE" ?Ü)
                                             ("ue" ?ü)
                                             ("sz" ?ß)
                                             ("\"" ?„)
                                             ("\"e" ?“)                             ;e for ending the quotation
                                             ("'e" ?‘)                              ;e for ending the quotation
                                             ("'" ?‚)
                                             ("AEE" ["AE"])
                                             ("aee" ["ae"])
                                             ("OEE" ["OE"])
                                             ("oee" ["oe"])
                                             ("UEE" ["UE"])
                                             ("uee" ["ue"])
                                             ("szz" ["sz"])
                                             ("ge" ["ge"])
                                             ("eue" ["eue"])
                                             ("Eue" ["Eue"])
                                             ("aue" ["aue"])
                                             ("Aue" ["Aue"])
                                             ("que" ["que"])
                                             ("Que" ["Que"])
                                             ))))


(defun extractVar (string)
  (or (car (cdr (org-split-string (substring-no-properties string)))) ""))


;; *scratch* mode
(setq initial-scratch-message nil)



;; pdf-tools cache implementation
;; This would be our cache file.
(setq cache-file-name "~/.emacs.d/pdf-tools-cache.el")

(defun cache-file-closed (fileName pageNumber)
  "Make sure that fileName is an absolute canonical path. Someone
tells this function that file with absolute path `fileName' is
closed and the last seen page is `pageNumber'. This function
makes sure that cache variables are appropriately updated."
  (if (assoc fileName cache-alist)
        (setcar (cdr (assoc fileName cache-alist)) pageNumber)
;fileName isn't present in cache. We have to push a new entry
      (setq cache-alist (append cache-alist (list (list fileName pageNumber))))
      (if (> (length cache-alist)
             cache-maximum-size) ;Now we have to check if alist has
                                 ;exceeded its maximum size.
          (set 'cache-alist (cdr cache-alist)))))


(defun cache-file-opened (fileName)
  "If a pdf file is opened and if it is present in cache, jump to
the last seen page number"
  (if (assoc fileName cache-alist)
      (pdf-view-goto-page (car (cdr (assoc fileName cache-alist))))))



(defun cache-read-conf-file ()
  "Read the config file for pdf-tools-cache"
    (load cache-file-name))

(defun cache-write-config-file ()
  "Write updated values of cache-alist and cache-maximum-size to
`cache-file-name'"
  (let ((fileContents (concat "(setq cache-maximum-size "
                              (number-to-string cache-maximum-size)
                              ")\n(setq cache-alist '"
                              (format "%S" cache-alist)
                              ")")))
    (with-temp-file cache-file-name
      (insert fileContents))))

;; pdf-tools mode
(pdf-tools-install)
(cache-read-conf-file)
(set 'pdf-view-mode-hook nil)
(add-hook 'pdf-view-mode-hook (lambda ()
                                (local-set-key (kbd "j") 'pdf-view-next-line-or-next-page)
                                (local-set-key (kbd "k") 'pdf-view-previous-line-or-previous-page)
                                (local-set-key (kbd "q") 'kill-this-buffer)
                                (local-set-key (kbd ",") 'image-bob)
                                (local-set-key (kbd ".") 'image-eob)
                                (cache-file-opened (expand-file-name (buffer-file-name)))))


(defun killing-function (&rest args)
  "If a pdf is closed, make sure that info related to this pdf is
updated in cache.

Since no one else is using `cache-file-closed', we can -
technically - put the contents of that function here. But I want
to keep cache matters and pdf matters separate."
  (if (equal major-mode 'pdf-view-mode)
      (cache-file-closed (expand-file-name (buffer-file-name))
                         (pdf-view-current-page))))



(advice-add 'kill-this-buffer :before #'killing-function)

(add-hook 'kill-emacs-hook (lambda ()
                             ;; Here we have to make sure that we call
                             ;; this function with pdf-view buffer as
                             ;; the current buffer. If there are
                             ;; multiple such buffers, we have to call
                             ;; it once for each buffer
                             (cache-write-config-file)))


;; my-ding

;; ding-dict minor mode

(defface ding-dict-word-highlight-face '()
         "Just for ding")
(set-face-foreground 'ding-dict-word-highlight-face "MediumBlue")

(setq ding-dict-mode-map (make-sparse-keymap))
(define-key ding-dict-mode-map (kbd "n")
  (lambda ()
    (interactive)
    (forward-char)
    (re-search-forward "^[^ ]")
    (ding-update-overlay)))
(define-key ding-dict-mode-map (kbd "p")
  (lambda ()
    (interactive)
    (backward-char)
    (re-search-backward "^[^ ]")
    (ding-update-overlay)))
(define-key ding-dict-mode-map (kbd "q")
  (lambda ()
    (interactive)
    (kill-buffer-and-window)))


(defun ding-update-overlay ()
  (save-excursion
    (mark-paragraph))
  (move-overlay highlight-overlay (point) (mark))
  (pop-mark))

(define-minor-mode ding-dict-mode
  "This is specifically to imitate the functionality of ding"
  :lighter " Ding-Dict"
  :keymap ding-dict-mode-map
  (setq-local buffer-read-only 'read-only)
  (setq-local highlight-overlay (make-overlay 0 0))
  (overlay-put highlight-overlay 'face 'highlight))

;; count-occurences and recursive-count are brazenly copied from http://stackoverflow.com/a/11848765/2744041
(defun count-occurences (regex string)
  (recursive-count regex string 0))


(defun recursive-count-internal (regex string start count)
  (if (string-match regex string start)
      (recursive-count-internal regex string (match-end 0) (+ 1 count))
    count))

(defun recursive-count (regex string start)
  (recursive-count-internal regex string start 0))
  ;; (if (string-match regex string start)
  ;;     (+ 1 (recursive-count regex string (match-end 0)))
  ;;   0))

(defun score (line original-query)
    "We get a line and we have to tell its score. If that line is
to be discarded, return -1"
  ;; Discard empty lines
  (if (or (string-match "^$" line)
          ;; Discard lines containing word 'grep' or 'Grep'
          (string-match "grep" line)
          ;; Discard comments
          (string-match "^#" line))
      nil
    (let ((pline (replace-regexp-in-string
                  " \\[[^]]*]" ""
                  (replace-regexp-in-string
                   " ([^)]*)" ""
                   (replace-regexp-in-string
                    " {[^}]*}" ""
                    line)))))
      (setq p 0)
      (if (string-match "|" pline)
          ;; Meaning this is a multi-line case
          (progn
            ;; Number of entries i.e., number of `|'s in the pline
            (setq ml (count-occurences "|" pline))
            (setq p 0)
            (if (or
                 (string-match (concat
                               ":: \\(to \\)?"
                               original-query
                               "\\(;.*\\| \\)|")
                               pline)
                 (string-match (concat
                                "^"
                                original-query
                                "\\(;\\| \\).*|.* ::")
                               pline))
                (setq p (+ p 100 ml))
              ;; Next two are to check if our original query is in the first of the list.
              (if (or (string-match (concat
                                     ":: [^|]*"
                                     original-query
                                     ".*|")
                                    pline)
                      (string-match (concat
                                     "^[^|]*"
                                     original-query
                                     ".*|.* ::")
                                    pline))
                  (setq p ml))))
        ;; All that follows is for a single line case
        (setq p 2)
        (if (or (string-match (concat ":: \\(to \\)?"
                                      original-query
                                      "\\(;\\|$\\)")
                              pline)
                (string-match (concat "^"
                                      original-query
                                      "\\(;\\| ::\\)")
                              pline))
            (setq p (+ p 100))
          (if (string-match (concat "; "
                                    original-query
                                    "\\(;\\|$\\)")
                            pline)
              (setq p (+ p 80))))
        (if (string-match " : " pline)
            (setq p (+ p 10))))
      p)))
        
        

(defun my-sort-alist-predicate (association-one association-two)
  ;; We want decreasing sort
  (> (car association-one) (car association-two)))


(defun my-sort-alist (alist)
  (sort alist 'my-sort-alist-predicate))


(defun my-ding-query (query)
  ;; This function takes a query word `query', searches for it in the
  ;; dict file, computes the score for each line of result, returns a
  ;; sorted list (in non-increasing order) of type (A . B) where B is
  ;; a single line of result and A is its score
  (let ((output-string (shell-command-to-string
                        (concat "egrep -h -i -e "
                                query
                                " ~/Downloads/ding/ding-1.8/de-en.txt"))))
    (my-sort-alist
     (delq nil
           (mapcar (lambda (line)
                     (let ((s (score line query)))
                       (if (or s
                               (equal s 0))
                           (cons s line)
                         nil)))
                   (split-string output-string "\n"))))))
                 ;; (with-current-buffer "*grep-ding*"
                 ;;   (split-string
                 ;;    (buffer-substring-no-properties (point-min)
                 ;;                                    (point-max))
                 ;;    "\n"))))))

;; (my-ding-query "gilt")


(require 'dash)
;; We use some functions like -zip-with and -repeat


(defun split-string-fill-column (string column)
  "Given a string `string'. Suppose the fill-column is set to
`column' and this `string' is present in a buffer. How would the
`string' be split into lines? Return the list of all those lines"
  (with-temp-buffer
    (insert string)
    (setq fill-column column)
    (fill-paragraph)
    (split-string (buffer-string) "\n")))


(defun ding-pretty-print (s1 s2 column1 column2 &optional left-padding)
  "Given two strings `s1' and `s2'. Fit `s1' in `column1' columns
and `s2' in `column2' columns. And print the resulting text in
the current buffer. If the optional argument `left-padding' is
given, it is ensured that every entry in the table has
`left-padding' number of spaces preceding it"


  ;; If left-padding is not given, by the above comments, we set it to
  ;; 0
  (unless left-padding
    (setq left-padding 0))
  ;; Split each string appropriately
  (let ((list1 (split-string-fill-column s1 (- column1 left-padding)))
        (list2 (split-string-fill-column s2 (- column2 left-padding))))
    ;; First we have to make these to be of equal size by padding with
    ;; "" strings. This looks not functional at all. But this is what
    ;; I can think of right now
    (if (< (length list1) (length list2))
        (setq list1 (append list1 (-repeat (- (length list2) (length list1)) "")))
      (setq list2 (append list2 (-repeat (- (length list1) (length list2)) ""))))

    
    (-zip-with (lambda (line1 line2)
                 (insert (format (concat (make-string left-padding ? )
                                         "%-"
                                         (number-to-string (- column1 left-padding))
                                         "s  "
                                         (make-string left-padding ? )
                                         "%-"
                                         (number-to-string (- column2 left-padding))
                                         "s\n")
                                 line1
                                 line2)))
               list1
               list2)))










(defun my-ding (&optional query)
  ;; This is the original function that takes a query word and
  ;; displays the buffer with the results similar to the ding format
  (interactive (list (read-string "Query: " (current-word) nil nil t)))
  (setq max-specpdl-size 8000)
  ;; We need this high value for this dict file. Otherwise recursion
  ;; level exceeds for some words. But I don't claim that 8000 is
  ;; minimum required. I just happened to have put this value and it
  ;; works as far as I have tested.
  (let* ((scored-list (my-ding-query query)))
    (if (get-buffer "*ding-dict*")
        (kill-buffer "*ding-dict*"))
    (get-buffer-create "*ding-dict*")
    ;; We obtained the *ding-dict* buffer
    (with-current-buffer "*ding-dict*"
      ;; This View-exit-and-edit is not needed since we decided not to
      ;; use View mode
      ;; (View-exit-and-edit) 
      (erase-buffer)
      ;; We dont't want lines to wrap around. So truncate em'all.
      (setq-local truncate-lines 'truncate-them)
      ;; By now, we have a buffer with name *ding-dict* We know how to
      ;; handle each entry. Now we have to use the same trick on the
      ;; whole list of entries.
      (mapcar (lambda (entry)
                ;; Each entry in this function is a line of result
                ;; from the dict file
                (let* ((a-and-b-list (mapcar (lambda (big-string)
                                               ;; This inner mapcar is
                                               ;; to remove trailing
                                               ;; and leading spaces
                                               ;; in resulting strings
                                               ;; after splitting at |
                                               ;; and ::
                                               (mapcar (lambda (small-string)
                                                         (replace-regexp-in-string
                                                          "^ *" ""
                                                          (replace-regexp-in-string
                                                           " *$" ""
                                                           small-string)))
                                                       (split-string big-string "|")))
                                             (split-string entry "::"))))
                      ;; Now in a-and-b-list we have two lists A and
                      ;; B. First element of B is a translation of
                      ;; first element of A and so on. We have to now
                      ;; place them cleanly in a buffer

                  ;; (insert (format "%-65s %s\n"
                  ;;                 (car (car a-and-b-list))
                  ;;                 (car (car (cdr a-and-b-list)))))
                  (ding-pretty-print (car (car a-and-b-list)) (car (car (cdr a-and-b-list))) 65 65)
                  (-zip-with (lambda (string1 string2)
                               ;; (insert (format "    %-65s     %s\n"
                               ;;                 string1
                               ;;                 string2))
                               (ding-pretty-print string1 string2 65 65 4)
                               )
                             (cdr (car a-and-b-list))
                             (cdr (car (cdr a-and-b-list)))))
                (insert "\n"))
              ;; This mapcar business is just to remove score from the
              ;; list
              (mapcar (lambda (entry-with-score)
                        (cdr entry-with-score))
                      scored-list))
      ;; By now all the content is placed neatly in the buffer. Now we
      ;; have to move the point to the start of the buffer so that we
      ;; see face first in the new window
      (goto-char (point-min))
      ;; (define-key view-mode-map (kbd "p") nil)
      (highlight-regexp (concat "\\b" query "\\b") 'ding-dict-word-highlight-face)
      (highlight-regexp "{..?.?}" 'bold)
      (ding-dict-mode)
      (ding-update-overlay))
    (display-buffer "*ding-dict*" '(display-buffer-reuse-window . '()))
    (other-window 1))
    ;; (switch-to-buffer "*ding-dict*"))
  nil)
    
;; (my-ding "Buch")


(global-set-key (kbd "C-c d g") 'my-ding)