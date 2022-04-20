from textual.app import App
from textual.widgets import Placeholder

from rich.panel import Panel
p = Panel.fit("Hello, [red]World!")
class SimpleApp(App):

    async def on_mount(self) -> None:
        await self.view.dock(Placeholder(), edge="left", size=40)
        await self.view.dock(Placeholder(), Placeholder(), edge="top")


SimpleApp.run(log="textual.log")
