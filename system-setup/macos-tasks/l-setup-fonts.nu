def main [
  --encrypt
  decrypted_dir: string = $"($nu.home-path)/.dotfiles/Fonts/decrypted"
  encrypted_dir: string = $"($nu.home-path)/.dotfiles/Fonts/encrypted"
  key_file: string = $"($nu.home-path)/.ssh/keys/age.txt"
] {
  use ../utils/utils.nu ensure_homebrew_package
  print "Setting up fonts..."
  ensure_homebrew_package "age"

  # The key file is the age identity file (akin to the private key)
  # The key file also contains the recipient (akin to public key) as a comment
  # which is parsed automatically when encrypting with the --identity flag

  if ($encrypt) {
    encrypt_path_content_with_age $decrypted_dir $encrypted_dir $key_file
  }

  def dir_content [dir: string] {
    glob --no-dir --no-symlink $"($dir)/**"
      | where { |path|
        ($path | path basename) != ".DS_Store"
      }
  }

  if ((dir_content $decrypted_dir | length) == 0) {
    try {
      decrypt_path_content_with_age $encrypted_dir $decrypted_dir $key_file
    } catch {
      print "Could not decrypt fonts ❗️"
      return
    }
  } else {
    print "Fonts seem to be already decrypted (directory non-empty) ✅"
  }
  cp --no-clobber --verbose ...(dir_content $decrypted_dir) $"($nu.home-path)/Library/Fonts/"
}

def encrypt_path_content_with_age [dir: string, dest_dir: string, key_file: string] {
  if not ($dir | path exists) {
    print $"($dir) does not exist ❗️"
    exit 1
  }
  mkdir $dest_dir

  for path in (glob $"($dir)/**") {
    if (($path | path basename) != ".DS_Store" and $path != $dir) {
      let rel_path = $path | path relative-to $dir
      let target_path = $dest_dir | path join $rel_path

      if (($path | path type) == dir) {
        mkdir $target_path
      }
      if (($path | path type) == file) {
        let output_path = $target_path + ".age"
        # do not overwrite existing encrypted files
        if not ($output_path | path exists) {
          print $"Encrypting: ($path | path basename)..."
          age --encrypt --identity $key_file --output $output_path $path
        }
      }
    }
  }
}

def decrypt_path_content_with_age [dir: string, dest_dir: string, key_file: string] {
  if not ($dir | path exists) {
    print $"($dir) does not exist ❗️"
    exit 1
  }
  mkdir $dest_dir

  for path in (glob $"($dir)/**") {
    if (($path | path basename) != ".DS_Store" and $path != $dir) {
      let rel_path = $path | path relative-to $dir
      let target_path = $dest_dir | path join $rel_path

      if (($path | path type) == dir) {
        mkdir $target_path
      }
      if (($path | path type) == file) {
        print $"Decrypting: ($path | path basename)..."
        let output_path = $target_path | path parse | reject extension | path join
        age --decrypt --identity $key_file --output $output_path $path
      }
    }
  }
}