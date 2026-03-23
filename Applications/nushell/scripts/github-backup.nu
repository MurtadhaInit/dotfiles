# Full GitHub backup: repos (mirror clones), gists, and metadata
# Clones/updates into a cache directory, then compresses into a timestamped archive
# This requires: `gh`, `tar`, and `zstd`.
#
# Decompress with: `tar --zstd -xf ./file.tar.zst -C ./github-restore`
# Clone from a local mirror into a normal working repo: `git clone repos/MurtadhaInit--dotfiles.git dotfiles`
# Then repoint origin to the new remote: `git remote set-url origin git@github.com:MurtadhaInit/dotfiles.git`
def github-backup [
    --include-forks       # Include forked repositories
    --include-gists       # Include gists
    --include-metadata    # Include metadata (starred repos, SSH/GPG keys)
    --all                 # Include forks, gists, and metadata
    --keep: int = 3       # Number of recent archives to keep (0 = keep all)
    --output-dir: path    # Archive destination (default: ~/Desktop/github-backup)
    --cache-dir: path     # Mirror cache location (default: ~/.cache/github-backup)
] {
    let output_dir = ($output_dir | default $"($nu.home-dir)/Desktop/github-backup" | path expand)
    let cache_dir = ($cache_dir | default $"($nu.home-dir)/.cache/github-backup" | path expand)
    let repos_cache = ($cache_dir | path join "repos")
    let gists_cache = ($cache_dir | path join "gists")
    let meta_cache = ($cache_dir | path join "metadata")

    let do_forks = ($include_forks or $all)
    let do_gists = ($include_gists or $all)
    let do_metadata = ($include_metadata or $all)

    mkdir $output_dir $repos_cache
    if $do_gists { mkdir $gists_cache }
    if $do_metadata { mkdir $meta_cache }

    # --- Repos ---
    print $"(ansi cyan_bold)Fetching repository list...(ansi reset)"
    let repos = (
        gh repo list --limit 9999 --json nameWithOwner,isFork,isPrivate
        | from json
    )

    let repos = if $do_forks { $repos } else { $repos | where isFork == false }
    print $"Found (ansi green_bold)($repos | length)(ansi reset) repos to backup"

    let errors = $repos | each { |repo|
        let name = ($repo.nameWithOwner | str replace "/" "--")
        let dest = ($repos_cache | path join $"($name).git")

        if ($dest | path exists) {
            print $"  Updating ($repo.nameWithOwner)..."
            let result = (git -C $dest remote update --prune e>| complete)
            if $result.exit_code != 0 {
                print $"  (ansi red)Failed to update ($repo.nameWithOwner)(ansi reset)"
                $repo.nameWithOwner
            }
        } else {
            print $"  Cloning ($repo.nameWithOwner)..."
            let result = (git clone --mirror $"git@github.com:($repo.nameWithOwner).git" $dest e>| complete)
            if $result.exit_code != 0 {
                print $"  (ansi red)Failed to clone ($repo.nameWithOwner)(ansi reset)"
                $repo.nameWithOwner
            }
        }
    } | compact

    if ($errors | is-not-empty) {
        print $"\n(ansi yellow_bold)Warning:(ansi reset) Failed to backup ($errors | length) repo\(s\): ($errors | str join ', ')"
    }

    # --- Gists ---
    if $do_gists {
        print $"\n(ansi cyan_bold)Fetching gists...(ansi reset)"
        let gists = (gh api gists --paginate | from json | flatten)
        print $"Found (ansi green_bold)($gists | length)(ansi reset) gists"

        $gists | each { |gist|
            let dest = ($gists_cache | path join $"($gist.id).git")
            if ($dest | path exists) {
                print $"  Updating gist ($gist.id)..."
                git -C $dest remote update --prune e>| complete | ignore
            } else {
                print $"  Cloning gist ($gist.id)..."
                git clone --mirror $gist.git_pull_url $dest e>| complete | ignore
            }
        }
    }

    # --- Metadata ---
    if $do_metadata {
        print $"\n(ansi cyan_bold)Backing up metadata...(ansi reset)"

        # Starred repos
        try {
            gh api user/starred --paginate
            | from json | flatten
            | select full_name html_url description
            | to json
            | save -f ($meta_cache | path join "starred.json")
            print "  Starred repos saved"
        } catch {
            print $"  (ansi yellow)Skipped starred repos(ansi reset)"
        }

        # SSH keys
        try {
            gh api user/keys --paginate
            | save -f ($meta_cache | path join "ssh-keys.json")
            print "  SSH keys saved"
        } catch {
            print $"  (ansi yellow)Skipped SSH keys(ansi reset)"
        }

        # GPG keys
        try {
            gh api user/gpg_keys --paginate
            | save -f ($meta_cache | path join "gpg-keys.json")
            print "  GPG keys saved"
        } catch {
            print $"  (ansi yellow)Skipped GPG keys(ansi reset)"
        }
    }

    # --- Compress into archive ---
    let timestamp = (date now | format date "%Y-%m-%d_%H%M%S")
    let archive_name = $"github-backup-($timestamp).tar.zst"
    let archive_path = ($output_dir | path join $archive_name)

    print $"\n(ansi cyan_bold)Compressing backup...(ansi reset)"
    tar -C $cache_dir -cf - . | zstd -T0 -o $archive_path

    let size = (ls $archive_path | first | get size)
    print $"Archive created: (ansi green_bold)($archive_path)(ansi reset) \(($size)\)"

    # --- Prune old archives ---
    if $keep > 0 {
        let archives = (
            ls $output_dir
            | where name =~ 'github-backup-.*\.tar\.zst$'
            | sort-by modified
            | reverse
        )

        if ($archives | length) > $keep {
            let to_delete = ($archives | skip $keep)
            $to_delete | each { |f|
                print $"  Removing old archive: ($f.name | path basename)"
                rm $f.name
            }
        }
    }

    print $"\n(ansi green_bold)Backup complete!(ansi reset)"
    print $"  Archive: ($archive_path)"
    print $"  Cache: ($cache_dir)"
}
