#!/usr/bin/env bash

function aider_todos() {
  @
  aider --read ~/.photon/aider/todos_agent.md todos/*

}

function aider_readme() {
  @
  aider --read ~/.photon/aider/readme_agent.md README.md
}

function aider_docstring() {
  @
  # Consider adding specific source directories/files here
  aider --read ~/.photon/aider/docstring_agent.md
}

function aider_typehints() {
  @
  # Consider adding specific source directories/files here
  aider --read ~/.photon/aider/typehints_agent.md
}

function aider_docsrc() {
  @
  # Add relevant docs source files/dirs, e.g., docs/*.rst docs/conf.py
  aider --read ~/.photon/aider/docsrc_agent.md
}
