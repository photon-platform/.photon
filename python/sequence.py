from rich import print
from rich.console import Console
console = Console()

name = 'WORLD'
#  print(f'[i]HELLO [b]{name}![/b][/i]')
#  print(locals())

from rich import inspect
from rich.color import Color
color = Color.parse("red")
#  inspect(color, methods=True)

console.rule('[frame]HELLO![/frame]', align='left')
console.print('[frame]HELLO![/frame]')
console.print("Google", style="link https://google.com")

console.log(f'[i]hello [b]{name}![/b][/i]')
console.input("What is [i]your[/i] [bold red]name[/]? :smiley: ")
#  with console.status("Monkeying around...", spinner="monkey"):
    #  while True:
        #  pass

from rich.style import Style
danger_style = Style(color="red", blink=True, bold=True)
console.print("Danger, Will Robinson!", style=danger_style)
from rich.theme import Theme
custom_theme = Theme({
    "info": "dim cyan",
    "warning": "magenta",
    "danger": "bold #FF3333"
})
console = Console(theme=custom_theme)
console.print("This is information", style="info")
console.print("[warning]The pod bay doors are locked[/warning]")
console.print("Something terrible happened!", style="danger")
from rich.table import Table

table = Table(title="Star Wars Movies")

table.add_column("Released", justify="right", style="cyan", no_wrap=True)
table.add_column("Title", style="magenta")
table.add_column("Box Office", justify="right", style="green")

table.add_row("Dec 20, 2019", "Star Wars: The Rise of Skywalker", "$952,110,690")
table.add_row("May 25, 2018", "Solo: A Star Wars Story", "$393,151,347")
table.add_row("Dec 15, 2017", "Star Wars Ep. V111: The Last Jedi", "$1,332,539,889")
table.add_row("Dec 16, 2016", "Rogue One: A Star Wars Story", "$1,332,439,889")

console.print(table)

from rich.panel import Panel
from rich.text import Text
panel = Panel(Text("Hello", justify="right"))
print(panel)

from rich.console import Group

panel_group = Group(
    Panel("Hello", style="on blue"),
    Panel("World", style="on red"),
)
print(Panel(panel_group))

from rich.padding import Padding
test = Padding("Hello", (0, 4))
print(test)

import time

from rich.live import Live
from rich.table import Table

table = Table()
table.add_column("Row ID")
table.add_column("Description")
table.add_column("Level")

with Live(table, refresh_per_second=4):  # update 4 times a second to feel fluid
    for row in range(12):
        time.sleep(0.4)  # arbitrary delay
        # update the renderable internally
        table.add_row(f"{row}", f"description {row}", "[red]ERROR")

from rich.bar import Bar

console.print(Bar(5, 5, 5, color='red'))

import getch
# ...
char = getch.getch() # User input, but not displayed on the screen
console.print(char)
# or
char = getch.getche() # also displayed on the screen
console.print(char)

