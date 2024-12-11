export const order = 10

def setup_warp [] {
  print "Setting up Warp..."
  use ../utils/utils.nu ensure_homebrew_package 

  ensure_homebrew_package warp --cask
  # TODO: don't overwrite files if they already exist
  mkdir $"($nu.home-path)/.warp/themes"
  curl --no-clobber --output-dir $"($nu.home-path)/.warp/themes" -LO https://raw.githubusercontent.com/catppuccin/warp/refs/heads/main/themes/catppuccin_frappe.yml
  curl --no-clobber --output-dir $"($nu.home-path)/.warp/themes" -LO https://raw.githubusercontent.com/catppuccin/warp/refs/heads/main/themes/catppuccin_latte.yml
  curl --no-clobber --output-dir $"($nu.home-path)/.warp/themes" -LO https://raw.githubusercontent.com/catppuccin/warp/refs/heads/main/themes/catppuccin_macchiato.yml
  curl --no-clobber --output-dir $"($nu.home-path)/.warp/themes" -LO https://raw.githubusercontent.com/catppuccin/warp/refs/heads/main/themes/catppuccin_mocha.yml
  print "Successfully downloaded Catppuccin Warp themes into config directory ✅"
}

setup_warp