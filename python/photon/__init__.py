"""
photon apps
"""
from rich.markdown import Markdown

from textual import events
from textual.app import App
from textual.widgets import Header, Footer, Placeholder, ScrollView


from rich.console import Console, ConsoleOptions, RenderableType
from rich.panel import Panel
from rich.repr import rich_repr, Result
from rich.style import StyleType
from rich.table import Table
from rich.text import TextType


class Prompt(App):

    async def on_mount(self) -> None:
        await self.view.dock(Placeholder(), edge="left", size=40)
        await self.view.dock(Placeholder(), Placeholder(), edge="top")


class PhotonHeader(Header):

    
    def render(self) -> RenderableType:
        header_table = Table.grid(padding=(0, 1), expand=True)
        header_table.style = self.style
        header_table.add_column(justify="left", ratio=0, width=8)
        header_table.add_column("title", justify="center", ratio=1)
        header_table.add_column("clock", justify="right", width=8)
        header_table.add_row(
            "", self.full_title, self.get_clock() if self.clock else ""
        )
        header: RenderableType
        header = Panel(header_table, style=self.style) if self.tall else header_table
        return header


class MyApp(Prompt):
    """An example of a very simple Textual App"""

    async def on_load(self, event: events.Load) -> None:
        """Bind keys with the app loads (but before entering application mode)"""
        await self.bind("b", "view.toggle('sidebar')", "Toggle sidebar")
        await self.bind("q", "quit", "Quit")
        await self.bind("escape", "quit", "Quit")

    async def on_mount(self, event: events.Mount) -> None:
        """Create and dock the widgets."""

        # A scrollview to contain the markdown file
        body = ScrollView(gutter=1)

        # Header / footer / dock
        await self.view.dock(PhotonHeader(tall=False, style='gold3 on grey0'), edge="top")
        await self.view.dock(Footer(), edge="bottom")
        await self.view.dock(Placeholder(), edge="left", size=30, name="sidebar")

        # Dock the body in the remaining space
        #  await self.view.dock(body, edge="right")
        await self.view.dock(Placeholder(), edge="right")

        #  async def get_markdown(filename: str) -> None:
            #  with open(filename, "r", encoding="utf8") as fh:
                #  readme = Markdown(fh.read(), hyperlinks=True)
            #  await body.update(readme)

        #  await self.call_later(get_markdown, "richreadme.md")


