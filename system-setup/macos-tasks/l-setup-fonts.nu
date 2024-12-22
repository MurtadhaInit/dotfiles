def main [
  --encrypt
  --non-interactive = false
  decrypted_dir: string = $"($nu.home-path)/.dotfiles/Fonts/decrypted"
  encrypted_dir: string = $"($nu.home-path)/.dotfiles/Fonts/encrypted"
  key_file: string = $"($nu.home-path)/.keys/key.txt"
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
      if ($non_interactive) {
        decrypt_path_content_with_age $encrypted_dir $decrypted_dir $key_file
      } else {
        decrypt_path_content_with_age $encrypted_dir $decrypted_dir ""
      }
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

# passing an empty string for the key_file will make this function
# look for the identity file in ~/.keys/key.txt and if not found,
# it will prompt the user for the content of the identity file,
# it will then created it in that location and use it for decryption
def decrypt_path_content_with_age [dir: string, dest_dir: string, key_file: string] {
  if not ($dir | path exists) {
    print $"($dir) does not exist ❗️"
    exit 1
  }
  mkdir $dest_dir

  mut key_file = $key_file
  if ($key_file == "") {
    let default_key_file = $"($nu.home-path)/.keys/key.txt"
    if ($default_key_file | path exists) {
      print $"The file ($default_key_file) already exists, using it as an identity..."
      $key_file = $default_key_file
    } else {
      let identity = (input --suppress-output $"Enter the content of the identity file\nThe content of the identity file will be written to ($default_key_file):\n") | str trim
      $key_file = try {
        $identity | save $default_key_file
        $default_key_file
      } catch {
        error make {msg: $"Could not save the identity file at ($default_key_file) ❗️"}
      }
    }
  }

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