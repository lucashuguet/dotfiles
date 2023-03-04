import os
import yaml
from yaml.loader import SafeLoader

config.load_autoconfig()
# c.colors.webpage.darkmode.enabled = False

c.fonts.default_family = "FantasqueSansMono Nerd Font Mono"
c.fonts.default_size = "12pt"

searx = "https://searx.be/preferences?preferences=eJxtV8uO6zYM_ZpmY9yg7V0UXWRVoNsW6N0btMTYHEuirh5JPF9fKrZjOZ7FeEaHMs3nIUdBwp4DYbz06DCAORlwfYYeL2DkwAoMXtCdICdWbL3BhJeeuTd4Iiv3Wh_4MV1-hIwni2lgffn3n_9-nCJcMSIENVx-PaUBLV4ilfdPAWM2KbbsWof3NkF3-RtMxJNmakXI5obhwiDHM4f-xFFB-BbTJJYY7kmxxts3DWE8zRrbWfZEFLqEoQVDvZU_F82gb-AU6naxaEZ_ZgxTS65NlOT9pwvkruQoiU4V2JgZ1BShM_I6up6cBOvPHvq2jawITGNRE_zy-1_gx8ZSCBza9koG4xMT-xp5NjFxwEogZtANG4ptu4T-iSZSbfsMbLnVketreTk3s_TtVnMjjSzo_PuJpi6rEZPcTHJWSn1Lt-oCe3QS6YiVKnE6xoBXcU4RSsgEm9DXNqgcDGGNaMRPiXlrcyT1PN8IXBJnKs1a943GZ3CJ3c5rDHwn3bYsZRLkfKeRNCTYfUNcKT89f40eo1LJ7ghF9faFOS0WvLwgz2KD5Q_yJZPbrd8elbqrDlyMXBN4NaTGUF8IiE3ka7pDwEZTQCUpn5boXwO5kaBObk-9VBXEVHvUSylCt6ZMKr3D0C_Hue2OmV5wb2AqpRY3I2uJ5Rvh7jXPWtd5G6ALUB7L98jqbosGOahe_qA48CYcJRgQqy8bEl1haopnkb4Q8LVR7Hrp9zpphruY8BziYgJ8mimQipuRwjGgPLjlgkO87QrFebuKJoDtu6XaA3quTPEgRvcU1w7xuTtL7S6nn3ep4VrzEzjW2QwfkhLRE8x0s0MLUPLalMerOMBCCcwKRLSilFQT1cAGQt2OsTSWL8xb2ZZ4nDix5GQsoVk9THdKhQ7fqSq7KDURh8qNCQbe9dbEOeUOK-NfyKvRgcxkuTR0de1GFrk636mbasUWgrCo-LvLm8yZBzgd9mihgo55jO-gTA7BynMBfmZO-H4rcg7qgBbSozQdYJ7eoqpJpU92O-y379__eGwR1lmj2_og4qcDu_OWPxDHXYXCraRkA0Luph7tWvMeMbxF_pk3-cQoLXy_Y1eJQrYymupw84NGdlLJTZwcu8liZd-HP_u723OtFVLeTZkgFtaAl54zay1_CR_bohbukiV1vvX3nKAhp43iXl84odtP3acuQy4_mmL2ShHhQbe6QTopIwXWb3Vabi_c_jZLd5Z1SVPfb7mVSRdE565QNMtIDc2QV45OYtq0ixYm6QkndlZxFynlisXknIqrs9OUNn0zZe9Gwkzihwgv-M6FBfuCNoZF78zsTsqFONeEVWGrleJDv2dXSw9lOOuKj0HmGq4jo7AsyOgr4zuiLHmVBatMaFZmJyxrwF4ek0zRJCN5nctel0bYLvlBaM69pBRkg-1gqkg9d9Itu1cmTzWn7yMmtmpKB4aUwpQq2rsqzKtGlua9Gr6v1RfH3GWX8lrQ2WPI8RUQ2WZJyx4ghZSq0fNk2-adxEpIoKwMr-5kM88GP1R7iZWWtrJaNCmAi0YiUC9PHLSjsQJSCmdaW37bZb3J0lbxUnr0cV5O57Lna9nxVVp25Xb9h2CZXttVhnbe2O9BFuaDOKK5ynJ95YNEwtGqAdV4kMjoaCXBI07x1f1f2zmU6TUfDloGjklYGMU0mXLqK9OenkkdqfkfoEmcNeLz0dQApd9b2XlFmy3JP8mslUK9_A8SUQFD&save=1"

c.url.default_page = searx
c.url.start_pages = [searx]
c.url.searchengines = {
    "DEFAULT": "https://searx.be/search?q={}"
}

c.downloads.location.prompt = False
c.downloads.position = "bottom"
c.downloads.remove_finished = 200

c.editor.command = ["emacsclient", "'{}'"]

config.unbind("ZZ")
config.unbind("ZQ")

config.bind("<y><o>", "yank inline [[{url}][{title}]]")
config.bind("x", "hint links spawn mpv '{hint-url}'")
config.bind("X", "hint links spawn playbox -p '{hint-url}'")
config.bind("z", "hint links spawn addstr.sh '{hint-url}'")
config.bind("Z", "spawn --userscript savebox")

config.bind("<Ctrl-a>", "fake-key <Home>", "insert")
config.bind("<Ctrl-e>", "fake-key <End>", "insert")

with open(os.path.expanduser("~/.config/qutebrowser/colors.yml")) as f:
    colors = yaml.load(f, Loader=SafeLoader)

    c.colors.statusbar.normal.bg = colors["colors"]["primary"]["background"]
    c.colors.statusbar.command.bg = colors["colors"]["primary"]["background"]
    c.colors.statusbar.normal.fg = colors["colors"]["primary"]["foreground"]
    c.colors.statusbar.command.fg = colors["colors"]["primary"]["foreground"]
    
    c.colors.tabs.even.bg = colors["colors"]["primary"]["background"]
    c.colors.tabs.odd.bg = colors["colors"]["primary"]["background"]
    c.colors.tabs.even.fg = colors["colors"]["primary"]["foreground"]
    c.colors.tabs.odd.fg = colors["colors"]["primary"]["foreground"]
    c.colors.tabs.selected.even.bg = colors["colors"]["bright"]["black"]
    c.colors.tabs.selected.odd.bg = colors["colors"]["bright"]["black"]
    c.colors.tabs.indicator.stop = colors["colors"]["normal"]["cyan"]
    
    c.colors.completion.even.bg = colors["colors"]["primary"]["background"]
    c.colors.completion.odd.bg = colors["colors"]["primary"]["background"]
    c.colors.completion.odd.bg = colors["colors"]["primary"]["background"]
    c.colors.completion.fg = colors["colors"]["primary"]["foreground"]
    c.colors.completion.category.bg = colors["colors"]["primary"]["background"]
    c.colors.completion.category.fg = colors["colors"]["primary"]["foreground"]
    c.colors.completion.item.selected.bg = colors["colors"]["primary"]["background"]
    c.colors.completion.item.selected.fg = colors["colors"]["primary"]["foreground"]
    
    c.colors.hints.bg = colors["colors"]["primary"]["background"]
    c.colors.hints.fg = colors["colors"]["primary"]["foreground"]

c.statusbar.show = "always"
c.hints.border = "1px solid #ffffff"
c.completion.height = "15%"
