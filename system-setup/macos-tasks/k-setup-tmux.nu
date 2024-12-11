def setup_tmux [] {
  use ../utils/utils.nu [ensure_homebrew_package, ensure_repo]
  print "Setting up tmux..."
  
  ensure_homebrew_package "tmux"
  let tpm_dir = $"($nu.home-path)/.config/tmux/plugins/tpm"
  ensure_repo "https://github.com/tmux-plugins/tpm" $tpm_dir
  
  try {
    ^$"($tpm_dir)/bin/install_plugins"
    print "Tmux plugins installed ✅"
  } catch {
    print "Failed to install tmux plugins ❗️"
    return
  }
  
  ^$"($nu.home-path)/.config/tmux/plugins/tpm/bin/update_plugins" all
  print "Successfully updated all tmux plugins ✅"
}

setup_tmux