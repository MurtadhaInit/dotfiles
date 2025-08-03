#!/usr/bin/env nu

# Setup a workstation through a number of Nushell scripts.
#
# After detecting the OS type, relevant tasks will be shown.
# Each task represents a step to configure the current system.
# Navigate with keyboard and pick the tasks to be performed.
def main [
  --skip # select the tasks to skip and execute the rest (opposite of normal operation)
  --all # execute all tasks (unattended)
  --skip-tasks: list<string> = [] # specify the exact names of tasks to skip
  ]: nothing -> nothing {
  cd $"($nu.home-path)/.dotfiles/system-setup"
  let tasks_dir = match $nu.os-info.name {
    "macos" => {
      print "🍎 MacOS detected"
      "macos-tasks"
    },
    "linux" => {
      print "🐧 Linux detected"
      exit 1
    },
    "windows" => {
      print "🪟 Windows detected, unfortunately..."
      exit 1
    },
    _ => {
      print "❗ Unknown OS"
      exit 1
    }
  }

  let tasks = get_tasks $tasks_dir
  mut to_skip = []

  # skip tasks interactively
  if ($skip) {
    let selection = $tasks | get name | input list --multi "Select tasks to skip"
    if ($selection != null) {
      $to_skip = $selection
    }
  }

  # skip tasks programmatically
  if ($skip_tasks != []) {
    $to_skip = [...$skip_tasks]
  }

  # select tasks interactively
  if (not $all and not $skip and $skip_tasks == []) {
    let selection = $tasks | get name | input list --multi "Select tasks to run"
    if ($selection != null) {
      $to_skip = $tasks | get name | where { |task| not ($task in $selection) }
    } else {
      print "Nothing selected..."
      exit 0
    }
  }

  if ($to_skip != []) {
    print $"Skipping tasks: ($to_skip | str join ', ')\n"
  }
  for task in $tasks {
    if not ($task.name in $to_skip) {
      nu $task.path
    }
  }
  print "🚀 Done!"
}

def get_priority [file: string] {
  try {
    open -r $file
    | lines
    | parse '# priority: {prio}'
    | get prio.0
    | into int
  } catch {
    0
  }
}

def get_tasks [tasks_dir: string] {
  glob $"($tasks_dir)/*.nu"
  | each { |item|
      {
        path: $item,
        name: ($item | path parse).stem,
        priority: (get_priority $item) 
      }
    }
  | sort-by -r priority
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
