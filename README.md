# dotfiles

## Instalation

### Clone dotfiles to $HOME
```bash
cd $HOME
git clone git@github.com:stitas/dotfiles.git
```

### Update symlinks

Install GNU stow

```bash
sudo dnf install stow
```

Run stow from `dotfiles` dir

```bash
cd dotfiles
stow --adopt .
```

`--adopt` flag overrides existing files with configs from `dotfiles` dir

## Usage

Use the dotfiles dir as the source of truth. All configs should be edited through here and replicated to corresponding dirs via the symlinks

## Info

The .git and README.md files are ignored when creating symlinks. Additional files can be ignored by adding .stow-local-ignore.

```bash
echo ".git" > .stow-local-ignore
echo "README.md" >> .stow-local-ignore
echo "new_file_or_dir" >> .stow-local-ignore
```

## Additional stuff

### yazi

Global clipboard tool installed for yazi file copying but not included in dot files:
```
https://github.com/XYenon/clipboard.yazi
```

### Toggle distractions host script
Enable timer
```
systemctl --user daemon-reload
systemctl --user enable --now toggle-distraction-hosts-on.timer
systemctl --user enable --now toggle-distraction-hosts-off.timer
```

For toggle-distraction-hosts script your user has to be given passwordless sudo access to the shell scripts. Otherwise systemd timer will fail to run the script
```
sudo visudo -f /etc/sudoers.d/toggle-distraction-hosts
```

Insert these lines:
```
{YOUR_USERNAME} ALL=(root) NOPASSWD: /home/{YOUR_USERNAME}/.local/bin/toggle-distraction-hosts-on.sh
{YOUR_USERNAME} ALL=(root) NOPASSWD: /home/{YOUR_USERNAME}/.local/bin/toggle-distraction-hosts-off.sh
```

Give correct permissions and verify:
```
sudo chmod 0440 /etc/sudoers.d/toggle-distraction-hosts
sudo visudo -c
systemctl --user start toggle-distraction-hosts-on.service
journalctl --user -u toggle-distraction-hosts-on.service -n 20
systemctl --user start toggle-distraction-hosts-off.service
journalctl --user -u toggle-distraction-hosts-off.service -n 20
```
