(setq user-full-name "Lucas Huguet"
      user-mail-address "lucashuguet31@gmail.com")

(setq doom-theme 'doom-dracula
      doom-font (font-spec :size 16))

(setq display-line-numbers-type t)

(setq org-directory "~/org/")

;; ERC CONFIG
(setq erc-server "irc.eu.libera.chat"
      erc-nick "astrogoat4756"
      erc-prompt (lambda () (concat "[" (buffer-name) "]")))
