(setq doom-theme 'xresources
      doom-font (font-spec :family "FantasqueSansMono Nerd Font" :size 20 :weight 'medium)
      display-line-numbers-type t)

(setq inferior-lisp-program "sbcl")

(setq erc-server "irc.eu.libera.chat"
      erc-nick "astrogoat4756"
      erc-prompt (lambda () (concat "[" (buffer-name) "]")))

(setq company-idle-delay 0
      company-show-numbers t)

(setq rustic-cargo-bin "~/.cargo/bin/cargo")

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(setq org-directory "~/Documents/org/")

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.5))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.4))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.3))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.2))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.1))))
)

(add-hook 'org-mode-hook 'org-auto-tangle-mode)
