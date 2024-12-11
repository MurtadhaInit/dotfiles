# TODO: turn this into a nushell script if pipx is still required
# pipx apps: ["--include-deps ansible", "ansible-lint", "poetry", "apprise"]

# - name: Install pipx
#   tags: homebrew
#   community.general.homebrew:
#     update_homebrew: true
#     name: pipx
#     state: present

# - name: Install argcomplete to allow for tab completion in pipx
#   ansible.builtin.command:
#     cmd: "pipx install argcomplete"
#   changed_when: true

# - name: Install Python applications with pipx
#   ansible.builtin.command:
#     cmd: "pipx install {{ item }}"
#   with_items: "{{ lookup('file', 'pipx_apps.txt') }}"

#   # NOTE: this assumes Homebrew-installed zsh is the default shell
#   # TODO: test with this to avoid that assumption?:
#   # when: '[ "$(which $SHELL)" = "$(brew --prefix)/bin/zsh" ]'
#   # TODO: check if the _poetry file exists to skip this task
# - name: Setup Poetry command completions
#   environment:
#     # for pipx tools/apps to be accessible (namely, poetry)
#     PATH: ~/.local/bin:{{ ansible_env.PATH }}
#   ansible.builtin.shell:
#     cmd: poetry completions zsh > $(brew --prefix)/share/zsh/site-functions/_poetry
