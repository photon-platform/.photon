"""
Prompt app for base context
"""
from textual import events
from textual.app import App, ComposeResult
from textual.widgets import Header, Footer, Static


class Prompt(App):
    BINDINGS = [("q,escape", "app.exit()", "quit")]

    def compose(self) -> ComposeResult:
        yield Header("PHOTON")
        yield Static("Hello")
        yield Footer()
