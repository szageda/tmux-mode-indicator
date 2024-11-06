<div align="center">
<h1>Tmux Mode Indicator</h1></div>

Plugin that displays prompt indicating currently active Tmux mode.

**Prefix Prompt**:  
![Prefix Prompt](screenshots/prefix.png)

**Copy Prompt**:  
![Copy Prompt](screenshots/copy.png)

**Sync Prompt**:  
![Sync Prompt](screenshots/sync.png)

**Empty Prompt**:  
![Empty Prompt vi-mode](screenshots/empty-vi.png)  
*vi-mode input*

![Empty Prompt Emacs](screenshots/empty-emacs.png)  
*Emacs input*

*Note: This project was forked from https://github.com/MunifTanjim/tmux-mode-indicator*

## Usage

Add `#{tmux_mode_indicator}` to the `status-left` or `status-right` option of Tmux. For example:

```conf
set -g status-right "#{tmux_mode_indicator} #H"
```

## Installation

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

Add this repository as a TPM plugin in your `.tmux.conf` file:

```conf
set -g @plugin "szageda/tmux-mode-indicator"
```

Press `prefix + I` in Tmux environment to install it.

### Manual Installation

Clone this repository:

```bash
git clone https://github.com/szageda/tmux-mode-indicator.git ~/.tmux/plugins/tmux-mode-indicator
```

Add this line in your `.tmux.conf` file:

```conf
run-shell ~/.tmux/plugins/tmux-mode-indicator/mode-indicator.tmux
```

Reload Tmux configuration file with:

```sh
tmux source-file ~/.tmux.conf
```

## Configuration Options

The following configuration options are available:

```ini
# Prompt to display when tmux prefix key is pressed
set -g @mode_indicator_prefix_prompt " WAIT "

# Prompt to display when tmux is in copy mode
set -g @mode_indicator_copy_prompt " COPY "

# Prompt to display when tmux has synchronized panes
set -g @mode_indicator_sync_prompt " SYNC "

# Prompt to display when tmux is in normal mode
# Note: The script performs logic to check for the input
# method (vi-mode or emacs). If this option is defined,
# the logic is overwritten.
set -g @mode_indicator_empty_prompt " TMUX "

# Style values for prefix prompt
set -g @mode_indicator_prefix_mode_style "bg=cyan,fg=white,bold"

# Style values for copy prompt
set -g @mode_indicator_copy_mode_style "bg=yellow,fg=black,bold"

# Style values for sync prompt
set -g @mode_indicator_sync_mode_style "bg=red,fg=black,bold"

# Style values for empty prompt
set -g @mode_indicator_empty_mode_style "bg=blue,fg=white,bold"
```

## Troubleshooting

### Error: Returned 126

```
'.../.tmux/plugins/tmux-mode-indicator/mode-indicator.tmux' returned 126
```

This error indicates executable permission is not set on `mode-indicator.tmux`. Make the plugin executable by using this command:

```shell
chmod +x ~/.tmux/plugins/tmux-mode-indicator/mode-indicator.tmux
```

## License

Licensed under the MIT License. Check the [LICENSE](./LICENSE) file for details.
