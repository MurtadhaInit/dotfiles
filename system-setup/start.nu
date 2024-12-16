#!/usr/bin/env nu

def main [--skip, --select, --skip-tasks: list = []] {
  cd $"($nu.home-path)/.dotfiles/system-setup"
  let tasks_dir = match $nu.os-info.name {
    "macos" => {
      print "MacOS detected 🍎"
      "macos-tasks"
    },
    "windows" => {
      print "Windows detected 🪟"
      exit 1
    },
    "linux" => {
      print "Linux detected 🐧"
      exit 1
    },
    _ => {
      print "Unknown OS"
      exit 1
    }
  }

  let tasks = get_tasks $tasks_dir
  mut to_skip = []
  # skip tasks interactively
  if ($skip) {
    $to_skip = $tasks | get name | input list --multi "Select tasks to skip:"
  }
  # skip tasks programmatically
  if ($skip_tasks != []) {
    $to_skip = [...$skip_tasks]
  }
  # select tasks interactively
  if ($select) {
    let selection = $tasks | get name | input list --multi "Select tasks to run:"
    $to_skip = $tasks | get name | where { |task| not ($task in $selection) }
  }

  if ($to_skip != []) {
    print $"Skipping tasks: ($to_skip | str join ', ')"
  }
  for task in $tasks {
    if not ($task.name in $to_skip) {
      ^nu $task.path
    }
  }
  print "Done! 🚀"
}

def get_tasks [tasks_dir: string] {
  glob $"($tasks_dir)/*.nu" | each { |item|
      {
        path: $item,
        name: ($item | path parse).stem,
      }
    } | sort-by name
}

# TODO: test everything on a fresh machine (vm)

# TODO: change system settings
# Check out these files:
# 1. https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# 2. https://github.com/geerlingguy/dotfiles/blob/master/.osx
# 3. https://github.com/eieioxyz/dotfiles_macos/blob/master/setup_macos.zsh

# TODO: copy all apps' settings (.plist files)
# Those mostly located in ~/Library/Preferences

# TODO: sign in to app store is required to install all apps with Brewfile.
# Inform/prompt the user with nushell input before proceeding

# TODO: explore tips found here: https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f