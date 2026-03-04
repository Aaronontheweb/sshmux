# sshmux

A bash tool for managing SSH + tmux sessions across multiple remote machines.

## Install

```bash
git clone https://github.com/aaronontheweb/sshmux
cd sshmux
bash install.sh
```

The install script copies `sshmux` to `~/.local/bin/`, creates `~/.config/sshmux/`, and walks you through adding your first machine.

Make sure `~/.local/bin` is on your `PATH` (add to `~/.bashrc` if needed):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Requirements

- `bash` 4+
- `ssh` + `tmux` on your remote machines
- `fzf` (for `sshmux hosts` and `sshmux sessions`)
- `python3` (for config editing — standard on Ubuntu)
- Zellij or tmux locally (optional, for `sshmux tabs`)

## Config

Config lives at `~/.config/sshmux/config`:

```ini
[default]
machine = ubuntu24-dev

[machine.ubuntu24-dev]
user = petabridge
host = ubuntu24-dev
default_session = work

[machine.ubuntu22-build]
user = builder
host = 192.168.1.50
default_session = main
```

See [`example/config`](example/config) for a fully annotated example.

## Commands

```
sshmux                              Connect to default machine, session "work"
sshmux connect [machine] [session]  Connect to a machine and session
sshmux list                         Show all configured machines (table)
sshmux hosts                        fzf: pick host → pick session → connect
sshmux sessions [machine]           fzf: pick a tmux session on a machine
sshmux tabs [machine]               Open one tab per session (Zellij/tmux-aware)
sshmux new <session> [machine]      Create / attach a named tmux session
sshmux add                          Add a new machine interactively
sshmux default <machine>            Set the default machine
sshmux init                         First-run onboarding
sshmux help                         Show help
```

### Quick connect

```bash
# Connect to default machine, session "work"
sshmux

# Connect to a specific machine, default session
sshmux ubuntu22-build

# Connect to a specific machine + session
sshmux connect ubuntu24-dev build
```

### Interactive pickers (requires fzf)

```bash
# Pick a host (skipped if only one configured), then pick a session
sshmux hosts

# Pick a session on the default machine
sshmux sessions

# Pick a session on a specific machine
sshmux sessions ubuntu22-build
```

### Tabs

Opens one tab per detected tmux session. Adapts to your local multiplexer:

| Local environment | Behavior |
|---|---|
| Zellij | Opens a new Zellij tab per session |
| tmux | Opens a new tmux window per session |
| Neither | Prints `sshmux connect` commands to run manually |

```bash
# Open tabs for all sessions on the default machine
sshmux tabs

# Open tabs for all sessions on a specific machine
sshmux tabs ubuntu22-build
```

### Managing machines

```bash
# Add a new machine (interactive prompts)
sshmux add

# Change the default machine
sshmux default ubuntu22-build

# List all machines
sshmux list
```

## tmux setup on remote machines

Install tmux and optionally add a `~/.tmux.conf` for a better experience:

```bash
sudo apt update && sudo apt install -y tmux
```

Recommended `~/.tmux.conf`:

```conf
unbind C-b
set -g prefix C-a
bind C-a send-prefix

set -g mouse on
set -g base-index 1
set -g history-limit 50000
set -g allow-rename off

bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind r source-file ~/.tmux.conf \; display "Reloaded"
```
