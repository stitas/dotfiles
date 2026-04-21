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
