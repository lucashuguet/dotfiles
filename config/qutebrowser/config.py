import os
import yaml
from yaml.loader import SafeLoader

config.load_autoconfig()
# c.colors.webpage.darkmode.enabled = False

c.fonts.default_family = "FantasqueSansMono Nerd Font Mono"
c.fonts.default_size = "12pt"

searx = "https://searx.be/preferences?preferences=eJxtV8uO6zYM_ZpmY9yg7V0UXWRVoNsW6N0btMTYHEuirh5xPF9fKrZjOZnFeEaHEsXnoUZBwp4DYbz06DCAORlwfYYeL5ATnwwrMHhBdypLxdYbTHjpmXuDJ7KysfWB7_PlR8h4spgG1pd___nvxynCFSNCUMPl11Ma0OIlUjl_ChizSbFl1zqc2gTd5W8wEU-aqRUhmxuGC4Mszxz6E0cF4VtMs1hiuCfFGm_fNITxtGhsF9kDUegShhYM9Vb-XDWDvoFTqNvVogX9mTHMLbk2UZLzDxfIXclREp0qsDELqClCZ-Q4up6cROvPHvq2jawITGNRE_zy-1_gx8ZSCBza9koG4wMT-xr5NjFxwEogZtANG4ptu8b-gSZSbfsIbNnVketreVk3i_RlV3MjjSzo8vuBpi6rEZPsTLJWSn1Lt2oDe3QS6YiVKnE6xoBXcU4RSsgEm9HXNqgcDGGNaMRPiXlrcyT1WN8IXBJnKs1a943GR3CJ3cFrDDyRbluWMgmynmgkDQkOd4gr5afnr9H3qFSyCaGo3m9Y0mLBywH5Fhssf5Avmdx3_Xav1F114GLklsCrITWGekNAbCJf0wQBG00BlaR8XqN_DeRGgjq5PfVSVRBT7VEvpQjdljKp9A5Dvy6XtnvP9Ip7A3MptbgbWUss3wgPxzxrXedtgC5A-az3kdXdHg1yUB3-oDjwLhwlGBCrmw2JrjA3xbNIXwj42ih2vfR7nTTDXUx4DnE1AT7NHEjF3UjhGFAe3LrBebv9NQPs15TiDui5utmD2NhT3BrC5-4spbqufk5SsnUmHsB7WS3wWw4ieoKFXQ5oAUoam_J51gJYKHHYgIhWlJJqohrYQKi7L5Y-8oVoK9sSjzMnlhSMJRKbh2miVNjvlZmyi1ICcajcmGHgQyvNnFPusDL-iTz7GsjMlkv_VttuZJGr9UTdXCu2EIQ0xd9DP8tYuYPT4YiWzu-Yx_gKyqAQrHxX4GfmhK-7Iueg3tDCcZTmN5jnl6hqUumT3QH77fv3P-57hHXW6Payj_jpwB685Q_EsUYc3EpKdiDkbu7RbiXuEcNL5B95kytG6dhpwq4ShWxlEtXh5juN7KSSmzg7drPFyr4Pf_aTO1KrFQ4-DJUgFtaAlxYzWy1_Cb-3hZTz3rVLHoacduJ6KjqhO87Shz5DLt-bYt3W-OFOt7oPOqkWBdbv5Vh2r4z9MiEP1dIlTX2_p1DmVxCdh3rQLIMyNEPemDeJafMhKJik9J3YWYVXpJQrbpJ1Kq4uTlPa9S1EfCD6hZrfArniBxdW7At2GFa9C187qQriXPNShW1Wig_97RA0S3dlOOuKZUGmFW6DoJApyEArQzmiPN0qCzaZsKlMRFiH-1Eek8zGJIN2m7Zel3rfN_lB2Mw9pRTkYdrBXHF37qQpDkdmTzV1HyMmtmpKb0QohSlVdHRVCFaNLD16NTxt1RfH3GWX8lbQ2WPI8RkQeaOSlukuhZSqCfMg1eaVq0pIoDwEnk3IZhkBfqheG1Y618qDoUkBXDQSgfpJxEE7GisgpXCmrbP3F6o3WdoqXkqf3s_r6szQLo_rKcjbdh1Muziiuco7-MpvEvGxVQOq8U0itN9K1kac47Olv758KJNnWbxpGTgmYVAU02RCqa9Me9CQFIda_lmZ5Q1v5Gn1bmqA0sStPE9Fmy0ZPcmclOq7_A-0COEh&save=1"

c.url.default_page = searx
c.url.start_pages = [searx]
c.url.searchengines = {
    "DEFAULT": "https://searx.be/search?q={}"
}

c.downloads.location.prompt = False
c.downloads.position = "bottom"
c.downloads.remove_finished = 200

c.editor.command = ["emacsclient", "-c", "'{}'"]

# c.content.cookies.accept = "no-3rdparty"
c.completion.web_history.max_items = 0
c.content.autoplay = False

config.unbind("ZZ")
config.unbind("ZQ")

config.bind("<y><o>", "yank inline [[{url}][{title}]]")
config.bind("x", "hint links spawn mpv '{hint-url}'")
config.bind("X", "hint links spawn playbox -p '{hint-url}'")
config.bind("z", "hint links spawn addstr.sh '{hint-url}'")
config.bind("Z", "spawn --userscript savebox")
config.bind("e", "spawn --userscript playanim")

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
