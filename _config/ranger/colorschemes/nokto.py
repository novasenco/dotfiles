
from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import reverse, bold, normal, invisible

class Nokto(ColorScheme):

    # palette
    fg             = 252
    bg             = 16
    grey           = 236
    red            = 161
    green          = 151
    orange         = 138
    blue           = 110
    magenta        = 139
    cyan           = 109
    white          = 252
    bright_grey    = 244
    pink           = 175
    bright_green   = 107
    yellow         = 180
    dark_cyan      = 66
    bright_magenta = 140
    bright_cyan    = 72
    bright_white   = 254

    lighter_grey  = 238
    brighter_grey = 248
    faint_grey    = 234
    select        = 235
    invis         = 233

    progress_bar_color = orange
    default_colors = (fg, -1, normal)

    def use(self, context):
        fg, bg, attr = self.default_colors

        if context.reset:
            return self.default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                fg = self.pink
            if context.border:
                fg = self.bright_grey
            if context.image:
                fg = self.brighter_grey
            if context.video:
                fg = self.magenta
            if context.audio:
                fg = self.bright_cyan
            if context.document:
                fg = self.fg
            if context.container:
                attr |= bold
                fg = self.magenta
            if context.directory:
                attr |= bold
                fg = self.blue
            elif context.executable and not \
                    any({context.media, context.container,
                         context.fifo, context.socket}):
                fg = self.green
            if context.socket:
                attr |= bold
                fg = self.orange
            if context.fifo or context.device:
                fg = self.yellow
                if context.device:
                    attr |= bold
            if context.link:
                fg = self.cyan if context.good else self.red
            if context.bad:
                bg = self.faint_grey
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (self.red, self.pink):
                    fg = self.select
                else:
                    fg = self.yellow
            if not context.selected and (context.cut or context.copied):
                fg = self.dark_cyan
                bg = self.faint_grey
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = self.yellow
            if context.badinfo:
                if attr & reverse:
                    bg = self.pink
                else:
                    fg = self.pink

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = self.red if context.bad else self.yellow
            elif context.directory:
                fg = self.blue
            elif context.tab:
                if context.good:
                    bg = self.orange
            elif context.link:
                fg = self.cyan

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = self.dark_cyan
                elif context.bad:
                    fg = self.red
            if context.marked:
                attr |= bold | reverse
                fg = self.yellow
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = self.red
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = self.cyan
                attr &= ~bold
            if context.vcscommit:
                fg = self.magenta
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = self.cyan

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = self.pink
            elif context.vcschanged:
                fg = self.orange
            elif context.vcsunknown:
                fg = self.orange
            elif context.vcsstaged:
                fg = self.dark_cyan
            elif context.vcssync:
                fg = self.dark_cyan
            elif context.vcsignored:
                fg = self.fg

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync:
                fg = self.dark_cyan
            elif context.vcsbehind:
                fg = self.orange
            elif context.vcsahead:
                fg = self.cyan
            elif context.vcsdiverged:
                fg = self.pink
            elif context.vcsunknown:
                fg = self.red

        return fg, bg, attr
