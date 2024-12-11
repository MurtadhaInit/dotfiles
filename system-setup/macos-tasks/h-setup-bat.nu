export const order = 8

def setup_bat [] {
  use ../utils/utils.nu ensure_homebrew_package
  print "Setting up bat..."
  
  ensure_homebrew_package "bat"
  let themes_dir = $"($nu.home-path)/.config/bat/themes"
  mkdir $themes_dir

  let repo_dir = $"($nu.home-path)/.config/bat/catppuccin"
  if (not ($repo_dir | path exists) or (ls $repo_dir | length) == 0) {
    git clone https://github.com/catppuccin/bat.git $repo_dir
    print "Successfully cloned Catppuccin themes repo ✅"
  } else {
    print "Catppuccin themes repo present ✅"
  }
  
  cp --verbose --no-clobber ...(glob $"($repo_dir)/themes/*") $themes_dir

  bat cache --build
  print "bat is successfully set up ✅"
}

setup_bat