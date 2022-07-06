import os
import re
import socket
import subprocess
from typing import List
from libqtile.command import lazy
from libqtile.widget import Spacer
from libqtile.command.client import Client
from libqtile import layout, bar, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen, Rule

mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')

@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

myTerm = "alacritty"

keys = [
    # SUPER + FUNCTION KEYS
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "v", lazy.spawn('pavucontrol')),
    Key([mod], "d", lazy.spawn('nwggrid -p -o 0.4')),
    Key([mod], "e", lazy.spawn('pcmanfm')),
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key([mod], "Return", lazy.spawn(myTerm)),
    Key([mod], "x", lazy.shutdown()),

    # SUPER + SHIFT KEYS
    Key([mod, "shift"], "d", lazy.spawn("dmenu_run -i -nb '#191919' -nf '#c0c5ce' -sb '#c0c5ce' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'")),
    Key([mod, "shift"], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.restart()),

    # CONTROL + ALT KEYS
    Key(["mod1", "control"], "o", lazy.spawn(home + '/.config/qtile/scripts/picom-toggle.sh')),

    # ALT + ... KEYS
    Key(["mod1"], "f", lazy.spawn('firefox')),
    Key(["mod1"], "m", lazy.spawn('pcmanfm')),
    Key(["mod1"], "w", lazy.spawn('garuda-welcome')),
    Key(["mod1"], "e", lazy.spawn('emacsclient -c -a \"emacs\"')),
    Key(["mod1"], "q", lazy.spawn('qutebrowser')),

    # CONTROL + SHIFT KEYS
    Key([mod2, "shift"], "Escape", lazy.spawn('alacritty -e bpytop')),

    # SCREENSHOTS
    Key([], "Print", lazy.spawn('flameshot full -p ' + home + '/Pictures/screenshots')),

    # INCREASE/DECREASE BRIGHTNESS
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 5%- ")),

    # MULTIMEDIA KEYS
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer set Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer set Master 5%+")),

    Key([], "XF86Launch4", lazy.spawn("amixer -q set Capture toggle")),
    Key([], "Next", lazy.spawn("amixer set Capture 5%-")),
    Key([], "Prior", lazy.spawn("amixer set Capture 5%+")),

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

    # ASUS ROG AURA KEYS
    Key([], "XF86KbdBrightnessUp", lazy.spawn("rogauracore brightness 3")),
    Key([], "XF86KbdBrightnessDown", lazy.spawn("rogauracore brightness 0")),
    Key([], "XF86Launch3", lazy.spawn("rogauracore single_colorcycle 2")),
    Key([], "XF86Launch2", lazy.spawn("rogauracore cyan")),

    # QTILE LAYOUT KEYS
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "space", lazy.next_layout()),

    # CHANGE FOCUS
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),


    # RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),

    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),

    # FLIP LAYOUT
    Key([mod, "shift"], "f", lazy.layout.flip()),

    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),

    # MOVE WINDOWS UP OR DOWN
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Left", lazy.layout.swap_left()),
    Key([mod, "shift"], "Right", lazy.layout.swap_right()),

    # TREETAB CONTROLS
    Key([mod, "control"], "k",
        lazy.layout.section_up(),
        desc='Move up a section in treetab'),
    Key([mod, "control"], "j",
        lazy.layout.section_down(),
        desc='Move down a section in treetab'),

    # TOGGLE FLOATING LAYOUT
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),
]

groups = []

group_names = ["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "minus", "egrave", "underscore", "ccedilla", "agrave",]

# group_labels = ["1 ", "2 ", "3 ", "4 ", "5 ", "6 ", "7 ", "8 ", "9 ", "0",]
group_labels = ["α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ",]
#group_labels = ["", "", "", "", "",]
#group_labels = ["Web", "Edit/chat", "Image", "Gimp", "Meld", "Video", "Vb", "Files", "Mail", "Music",]

group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall",]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend([
        #CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod], "Tab", lazy.screen.next_group()),
        Key([mod, "shift" ], "Tab", lazy.screen.prev_group()),
        Key(["mod1"], "Tab", lazy.screen.next_group()),
        Key(["mod1", "shift"], "Tab", lazy.screen.prev_group()),

        # MOVE WINDOW TO SELECTED WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])


def init_layout_theme():
    return {
        "margin": 10,
        "border_width": 2,
        "border_focus": "#ff00ff",
        "border_normal": "#f4c2c2"
    }

layout_theme = init_layout_theme()

layouts = [
    layout.MonadTall(margin=8, border_width=2, border_focus="#ff00ff", border_normal="#f4c2c2"),
    layout.MonadWide(margin=8, border_width=2, border_focus="#ff00ff", border_normal="#f4c2c2"),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme),
    layout.Columns(**layout_theme),
    layout.Stack(**layout_theme),
    layout.Tile(**layout_theme),
    layout.TreeTab(
        sections=['FIRST', 'SECOND'],
        bg_color = '#141414',
        active_bg = '#0000ff',
        inactive_bg = '#1e90ff',
        padding_y =5,
        section_top =10,
        panel_width = 280),
    layout.VerticalTile(**layout_theme),
    layout.Zoomy(**layout_theme)
]

# COLORS FOR THE BAR
def init_colors():
    return [
        ["#6830c8", "#6830c8"], #0 purple
        ["#2c3155", "#2c3155"], #1 dark blue
        ["#c0c5ce", "#c0c5ce"], #2 gray
        ["#ff5050", "#ff5050"], #3 orange-red
        ["#f4c2c2", "#f4c2c2"], #4 light pink
        ["#ffffff", "#ffffff"], #5 white
        ["#ffd47e", "#ffd47e"], #6 yellow
        ["#62FF00", "#62FF00"], #7 green
        ["#000000", "#000000"], #8 black
        ["#c40234", "#c40234"], #9 red
        ["#6790eb", "#6790eb"], #10 light blue
        ["#ff00ff", "#ff00ff"], #11 fuchsia
        ["#4c566a", "#4c566a"], #12 dark gray
        ["#282c34", "#282c34"], #13 dark dark gray
        ["#212121", "#212121"], #14 black
        ["#e44eaf", "#e44eaf"], #15 pink
        ["#2aa899", "#2aa899"], #16 turquoise
        ["#abb2bf", "#abb2bf"], #17 gray
        ["#81a1c1", "#81a1c1"], #18 pastel blue
        ["#56b6c2", "#56b6c2"], #19 dark turquoise
        ["#1a1fd2", "#1a1fd2"], #20 blue
        ["#e06c75", "#e06c75"], #21 candy pink
        ["#fb9f7f", "#fb9f7f"], #22 light salmon
        ["#f0cc9c", "#f0cc9c"]  #23 light orange
    ]

colors = init_colors()

def base(fg = "text", bg = "dark"):
    return {
        'foreground': colors[14],
        'background': colors[15]
    }

# WIDGETS FOR THE BAR
def init_widgets_defaults():
    return dict(
        font="Noto Sans",
        fontsize = 12,
        padding = 2,
        background=colors[20]
    )

widget_defaults = init_widgets_defaults()

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
        widget.GroupBox(
            **base(bg=colors[15]),
            font = "Noto Sans",

            fontsize = 15,
            margin_y = 2,
            margin_x = 0,
            padding_y = 5,
            padding_x = 5,
            borderwidth = 3,

            active=colors[5],
            inactive=colors[6],
            this_current_screen_border=colors[0],
            this_screen_border=colors[17],
            other_current_screen_border=colors[13],
            other_screen_border=colors[17],

            rounded= False,
            highlight_method='block',
            urgent_alert_method='block',
            disable_drag=True,
        ),

        widget.TaskList(
            highlight_method = 'border',
            max_title_width=250,
            rounded=True,

            icon_size=17,
            fontsize=14,

            padding_x=5,
            padding_y=0,
            margin_y=0,
            margin=5,
            borderwidth = 1,

            border=colors[15],
            foreground=colors[5],
            background=colors[20],

            txt_floating='🗗', # overlap emoji
            txt_minimized='>_ ',
        ),

        # widget.CPU(
        #     font="Noto Sans Bold",
        #     fontsize = 12,

        #     update_interval = 1,
        #     mouse_callbacks = {'Button1': lambda : qtile.cmd_spawn(myTerm + ' -e bpytop')},
        #     format = "CPU used at {load_percent}%",

        #     foreground = colors[5],
        #     background = colors[22],
        # ),

        widget.CPUGraph(
            border_color = colors[22],
            graph_color = colors[22],

            margin_x = 0,
            margin_y = 0
        ),

        widget.MemoryGraph(
            border_color = colors[16],
            graph_color = colors[16],

            margin_x = 0,
            margin_y = 0
        ),

        widget.CurrentLayoutIcon(
            custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],

            padding = 0,
            scale = 0.7,

            foreground = colors[5],
            background = colors[3],
        ),

        widget.CurrentLayout(
            font = "Noto Sans Bold",
            fontsize = 12,

            foreground = colors[5],
            background = colors[3]
        ),

        widget.Battery(
            font = "Noto Sans Bold",
            fontsize = 12,

            format='Battery: {percent:2.0%}',
            update_interval = 1,

            foreground = colors[5],
            background = colors[1],
        ),

        # widget.Memory(
        #     font="Noto Sans Bold",
        #     fontsize = 12,

        #     measure_mem = 'M',
        #     update_interval = 1,
        #     format = '{MemUsed: .0f}M/{MemTotal: .0f}M',
        #     mouse_callbacks = {'Button1': lambda : qtile.cmd_spawn(myTerm + ' -e bpytop')},

        #     foreground = colors[5],
        #     background = colors[16],
        # ),

        widget.Clock(
            font = "Noto Sans Bold",
            fontsize = 12,

            format="%Y-%m-%d %H:%M",

            foreground = colors[5],
            background = colors[23],
        ),

        widget.Systray(
            icon_size=15,
            padding = 4,

            background=colors[10],
        ),
    ]
    
    return widgets_list

widgets_list = init_widgets_list()

def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2

widgets_screen1 = init_widgets_screen1()
widgets_screen2 = init_widgets_screen2()

def init_screens():
    return [
        Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=20, opacity=0.85, background= "000000")),
        Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=20, opacity=0.85, background= "000000"))
    ]

screens = init_screens()

# MOUSE CONFIGURATION
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder = None
dgroups_app_rules = []

main = None

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

@hook.subscribe.startup
def start_always():
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

@hook.subscribe.focus_change
def mpv():
    home = os.path.expanduser('~')
    subprocess.Popen([home + "/.config/qtile/scripts/mpv.py"])

floating_types = ["notification", "toolbar", "splash", "dialog"]

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(
    float_rules = [
        *layout.Floating.default_float_rules,
        Match(wm_class='confirm'),
        Match(wm_class='dialog'),
        Match(wm_class='download'),
        Match(wm_class='error'),
        Match(wm_class='file_progress'),
        Match(wm_class='notification'),
        Match(wm_class='splash'),
        Match(wm_class='toolbar'),
        Match(wm_class='confirmreset'),
        Match(wm_class='makebranch'),
        Match(wm_class='maketag'),
        Match(wm_class='Arandr'),
        Match(wm_class='feh'),
        Match(wm_class='Galculator'),
        Match(title='branchdialog'),
        Match(title='Open File'),
        Match(title='pinentry'),
        Match(wm_class='ssh-askpass'),
        Match(wm_class='lxpolkit'),
        Match(wm_class='Lxpolkit'),
        Match(wm_class='yad'),
        Match(wm_class='Yad'),
        Match(wm_class='Cairo-dock'),
        Match(wm_class='cairo-dock'),
    ],
    fullscreen_border_width = 0,
    border_width = 0
)

auto_fullscreen = True

focus_on_window_activation = "focus"
wmname = "LG3D"
