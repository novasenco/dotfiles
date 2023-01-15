# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

# from __future__ import (absolute_import, division, print_function)

from ranger.api.commands import Command
from datetime import datetime

class today(Command):
    """:today [extension]

        Create a file with the format %Y_%m_%d_%a.{ext} (default {ext} is "md")
        - eg, 2021_08_23_Mon.md
    """

    def execute(self):
        base = datetime.today().strftime("%Y_%m_%d_%a")
        if self.arg(1):
            ext = self.rest(1)
        else:
            ext = "md"
        fname = f"{base}.{ext}"
        self.fm.edit_file(fname)

    def tab(self, tabnum):
        return ("md", "txt", "rtf", "tex")
