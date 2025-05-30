# priority: 6

def setup_bat [] {
  use ../utils/utils.nu [ensure_homebrew_package, ensure_repo]
  print "Setting up bat..."
  
  ensure_homebrew_package "bat"
  let themes_dir = $"($nu.home-path)/.config/bat/themes"
  mkdir $themes_dir

  let repo_dir = $"($nu.home-path)/.config/bat/catppuccin"
  ensure_repo "https://github.com/catppuccin/bat.git" $repo_dir
  
  cp --verbose --no-clobber ...(glob $"($repo_dir)/themes/*") $themes_dir

  bat cache --build
  print "bat is successfully set up ✅"
}

setup_bat