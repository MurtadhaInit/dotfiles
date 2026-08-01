# priority: 2

# Decrypt the content of the `encrypted_dir` into `decrypted_dir` using `age`
#
# By default, if the `decrypted_dir` is empty the files in `encrypted_dir` are decrypted
# to it. And then all files in `decrypted_dir` are copied (without overwriting) to the
# relevant OS fonts directory.
#
# The key file is the age identity file (akin to the private key)
# The key file also contains the recipient (akin to public key) as a comment
# which is parsed automatically when encrypting with the --identity flag
export def main [
  --encrypt # encrypt the content of the `decrypted_dir` into the `encrypted_dir`
  --overwrite # overwrite existing user fonts with the provided ones (useful for font updates)
  decrypted_dir?: string # plaintext content dir (default: ~/.dotfiles/Fonts/decrypted)
  encrypted_dir?: string # cyphertext content dir (default: ~/.dotfiles/Fonts/encrypted)
  key_file?: string # the 'age' identity file (default: ~/.ssh/keys/age.txt)
] {
  use ../utils/utils.nu ensure_homebrew_package
  let decrypted_dir = ($decrypted_dir | default $"($nu.home-dir)/.dotfiles/Fonts/decrypted")
  let encrypted_dir = ($encrypted_dir | default $"($nu.home-dir)/.dotfiles/Fonts/encrypted")
  let key_file = ($key_file | default $"($nu.home-dir)/.ssh/keys/age.txt")
  print "🔄 Setting up fonts..."
  ensure_homebrew_package "age"

  if ($encrypt) {
    encrypt_path_content_with_age $decrypted_dir $encrypted_dir $key_file
    return
  }

  mkdir $decrypted_dir
  if ((dir_content $decrypted_dir | length) == 0) {
    try {
      decrypt_path_content_with_age $encrypted_dir $decrypted_dir $key_file
    } catch {
      print "⚠️ Could not decrypt fonts"
      return
    }
  } else {
    print "✅ Fonts seem to be already decrypted (directory not empty)"
  }

  let arg = (if $overwrite {[]} else {['--no-clobber']})
  if ($nu.os-info.name == "macos") {
    cp ...$arg --verbose ...(dir_content $decrypted_dir) $"($nu.home-dir)/Library/Fonts/"
  } else {
    # or $XDG_DATA_HOME/fonts
    mkdir $"($nu.home-dir)/.local/share/fonts/"
    cp ...$arg --verbose ...(dir_content $decrypted_dir) $"($nu.home-dir)/.local/share/fonts/"
    ^fc-cache -fv
  }
}

# Encrypt the content of `dir` into `dest_dir` using the identity file in `key_file`
export def encrypt_path_content_with_age [
  dir: string # the source directory with plaintext content to encrypt
  dest_dir: string # the destination directory to place cyphertext content into
  key_file: string # the `age` identity file to use for encryption
  --overwrite # overwrite existing destination cyphertext files if found
] {
  if not ($dir | path exists) {
    print $"⚠️ ($dir) does not exist"
    exit 1
  } else if ((dir_content $dir | length) == 0) {
    print $"⚠️ ($dir) is empty"
    exit 1
  }
  mkdir $dest_dir

  let normalized_key = ($key_file | path expand)
  let normalized_dir = if $dir == "./" { $env.PWD } else { $dir | path expand } # to avoid malformed glob patterns

  for path in (glob $"($normalized_dir)/**/*") {
    if (($path | path basename) != ".DS_Store" and $path != $normalized_dir) {
      let rel_path = $path | path relative-to $normalized_dir
      let target_path = $dest_dir | path join $rel_path

      if (($path | path type) == dir) {
        mkdir $target_path
      }
      if (($path | path type) == file) {
        let output_path = $target_path + ".age"
        if ($overwrite) {
            print $"🔄 Encrypting: ($path | path basename)..."
            age --encrypt --identity $normalized_key --output $output_path $path
        # do not overwrite existing encrypted files
        } else if not ($output_path | path exists) {
          print $"🔄 Encrypting: ($path | path basename)..."
          age --encrypt --identity $normalized_key --output $output_path $path
        }
      }
    }
  }
}

# TODO: also add a --overwrite flag and pass it down from the main function
# Decrypt the content of `dir` into `dest_dir` using the identity file in `key_file`
export def decrypt_path_content_with_age [
  dir: string # the source directory with cyphertext content to decrypt
  dest_dir: string # the destination directory to place decrypted content into
  key_file: string # the `age` identity file to use for decryption
] {
  if not ($dir | path exists) {
    print $"⚠️ ($dir) does not exist"
    exit 1
  } else if ((dir_content $dir | length) == 0) {
    print $"⚠️ ($dir) is empty"
    exit 1
  }
  mkdir $dest_dir

  let normalized_key = ($key_file | path expand)
  let normalized_dir = if $dir == "./" { $env.PWD } else { $dir | path expand } # to avoid malformed glob patterns

  for path in (glob $"($normalized_dir)/**/*") {
    if (($path | path basename) != ".DS_Store" and $path != $normalized_dir) {
      let rel_path = $path | path relative-to $normalized_dir
      let target_path = $dest_dir | path join $rel_path

      if (($path | path type) == dir) {
        mkdir $target_path
      }
      if (($path | path type) == file) {
        print $"🔄 Decrypting: ($path | path basename)..."
        let output_path = $target_path | path parse | reject extension | path join
        age --decrypt --identity $normalized_key --output $output_path $path
      }
    }
  }
}

def dir_content [dir: string] {
  let normalized_dir = if $dir == "./" { $env.PWD } else { $dir | path expand } # to avoid malformed glob patterns

  glob --no-dir --no-symlink $"($normalized_dir)/**/*"
    | where { |path|
      ($path | path basename) != ".DS_Store"
    }
}
