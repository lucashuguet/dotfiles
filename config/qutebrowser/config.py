import os
import yaml
from yaml.loader import SafeLoader

config.load_autoconfig()
# c.colors.webpage.darkmode.enabled = False

c.fonts.default_family = "FantasqueSansMono Nerd Font Mono"
c.fonts.default_size = "12pt"

c.url.default_page = "https://www.startpage.com/"
c.url.start_pages = ["https://www.startpage.com/"]
c.url.searchengines = {
    "DEFAULT": "https://www.startpage.com/sp/search?query={}"
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
