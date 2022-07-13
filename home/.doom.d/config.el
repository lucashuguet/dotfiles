(setq user-full-name "Lucas Huguet"
      user-mail-address "lucashuguet31@gmail.com")

(setq doom-theme 'doom-palenight
      doom-font (font-spec :size 16))

(setq display-line-numbers-type t)

(setq dired-dwim-target t)

(setq org-directory "~/org/")

(setq erc-server "irc.eu.libera.chat"
      erc-nick "astrogoat4756"
      erc-prompt (lambda () (concat "[" (buffer-name) "]")))

(setq rustic-cargo-bin "~/.cargo/bin/cargo")

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
