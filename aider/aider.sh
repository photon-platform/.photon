#!/usr/bin/env bash

function aider_todos() {
  @
  aider --read ~/.photon/aider/todos_agent.md todos/*

}

function aider_readme() {
  @
  aider --read ~/.photon/aider/readme_agent.md README.md pyproject.toml
}

function aider_docstring() {
  @
  aider --read ~/.photon/aider/docstring_agent.md 
}

function aider_typehints() {
  @
  aider --read ~/.photon/aider/typehints_agent.md 
}

function aider_docsrc() {
  @
  aider --read ~/.photon/aider/docsrc_agent.md docsrc/*
}
