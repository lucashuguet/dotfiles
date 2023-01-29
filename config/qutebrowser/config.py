import subprocess

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

def read_xresources(prefix):
    """
    read settings from xresources
    """
    props = {}
    x = subprocess.run(["xrdb", "-query"], stdout=subprocess.PIPE)
    lines = x.stdout.decode().split("\n")
    for line in filter(lambda l: l.startswith(prefix), lines):
        prop, _, value = line.partition(":\t")
        props[prop] = value
    return props


xresources = read_xresources("qutebrowser")

c.colors.statusbar.normal.bg = xresources["qutebrowser.background"]
c.colors.statusbar.command.bg = xresources["qutebrowser.background"]
c.colors.statusbar.normal.fg = xresources["qutebrowser.foreground"]
c.colors.statusbar.command.fg = xresources["qutebrowser.foreground"]
c.statusbar.show = "always"

c.colors.tabs.even.bg = xresources["qutebrowser.background"]
c.colors.tabs.odd.bg = xresources["qutebrowser.background"]
c.colors.tabs.even.fg = xresources["qutebrowser.foreground"]
c.colors.tabs.odd.fg = xresources["qutebrowser.foreground"]
c.colors.tabs.selected.even.bg = xresources["qutebrowser.color8"]
c.colors.tabs.selected.odd.bg = xresources["qutebrowser.color8"]
c.colors.tabs.indicator.stop = xresources["qutebrowser.color14"]

c.colors.completion.even.bg = xresources["qutebrowser.background"]
c.colors.completion.odd.bg = xresources["qutebrowser.background"]
c.colors.completion.odd.bg = xresources["qutebrowser.background"]
c.colors.completion.fg = xresources["qutebrowser.foreground"]
c.colors.completion.category.bg = xresources["qutebrowser.background"]
c.colors.completion.category.fg = xresources["qutebrowser.foreground"]
c.colors.completion.item.selected.bg = xresources["qutebrowser.background"]
c.colors.completion.item.selected.fg = xresources["qutebrowser.foreground"]
c.completion.height = "15%"

c.colors.hints.bg = xresources["qutebrowser.background"]
c.colors.hints.fg = xresources["qutebrowser.foreground"]
c.hints.border = "1px solid #ffffff"
