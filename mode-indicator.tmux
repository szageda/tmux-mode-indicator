#!/usr/bin/env bash

# File        : mode-indicator.tmux
# Description : Tmux plugin to show the current mode in the status line
# Copyright   : (c) 2020, Munif Tanjim, (c) 2024, Gergely Szabo
# License     : MIT
#
# This code was forked from https://github.com/MunifTanjim/tmux-mode-indicator
#
# Usage:
#   Add #{tmux_mode_indicator} to your status line in your tmux.conf.
#
# Configuration:
#   You may edit the prompt text and styles using these variables in your tmux.conf:
#     set -g @mode_indicator_prefix_prompt
#     set -g @mode_indicator_copy_prompt
#     set -g @mode_indicator_sync_prompt
#     set -g @mode_indicator_empty_prompt
#     set -g @mode_indicator_prefix_mode_style
#     set -g @mode_indicator_copy_mode_style
#     set -g @mode_indicator_sync_mode_style
#     set -g @mode_indicator_empty_mode_style
#

# Exit immediately if a command exits with a non-zero status
set -e

# Define a placeholder for the tmux mode indicator
declare -r mode_indicator_placeholder="\#{tmux_mode_indicator}"

# Declare constants with configuration options
# for various mode indicators and styles
declare -r prefix_prompt_config="@mode_indicator_prefix_prompt"
declare -r copy_prompt_config="@mode_indicator_copy_prompt"
declare -r sync_prompt_config="@mode_indicator_sync_prompt"
declare -r empty_prompt_config="@mode_indicator_empty_prompt"
declare -r prefix_mode_style_config="@mode_indicator_prefix_mode_style"
declare -r copy_mode_style_config="@mode_indicator_copy_mode_style"
declare -r sync_mode_style_config="@mode_indicator_sync_mode_style"
declare -r empty_mode_style_config="@mode_indicator_empty_mode_style"

# Function to retrieve and return the value of a tmux option
tmux_option() {
  # Get the global tmux option value
  local -r option=$(tmux show-option -gqv "$1")
  # Fallback value in case the option is unset
  local -r fallback="$2"

  # Return the fallback value if the option is not set
  echo "${option:-$fallback}" 
}

# Function to format the style for the mode indicator
indicator_style() {
  # Get the style using the tmux_option function
  local -r style=$(tmux_option "$1" "$2")

  # Return formatted style or nothing
  echo "${style:+#[${style//,/]#[}]}"
}

# Function to initialize the tmux mode indicator
init_tmux_mode_indicator() {
  # Retrieve the current mode-keys setting (vi or emacs) from tmux
  local input_mode=$(tmux show-options -gqv mode-keys)
  
  # Check the current mode-keys and format it for display
  if [[ $input_mode == "vi" ]]; then
    input_mode="  VI  "
  elif [[ $input_mode == "emacs" ]]; then
    input_mode=" EMCS "
  else
    # Default to "TMUX" if neither vi nor emacs is set
    input_mode=" TMUX "
  fi

  # Retrieve prompt and style configurations with their fallbacks
  local -r \
    prefix_prompt=$(tmux_option "$prefix_prompt_config" " PRFX ") \
    copy_prompt=$(tmux_option "$copy_prompt_config" " COPY ") \
    sync_prompt=$(tmux_option "$sync_prompt_config" " SYNC ") \
    empty_prompt=$(tmux_option "$empty_prompt_config" "$input_mode") \
    prefix_style=$(indicator_style "$prefix_mode_style_config" "bg=cyan,fg=white,bold") \
    copy_style=$(indicator_style "$copy_mode_style_config" "bg=yellow,fg=black,bold") \
    sync_style=$(indicator_style "$sync_mode_style_config" "bg=red,fg=black,bold") \
    empty_style=$(indicator_style "$empty_mode_style_config" "bg=blue,fg=white,bold")

  # Construct the mode_prompt and mode_style variables based on condition
  local -r \
    mode_prompt="#{?client_prefix,$prefix_prompt,#{?pane_in_mode,$copy_prompt,#{?pane_synchronized,$sync_prompt,$empty_prompt}}}" \
    mode_style="#{?client_prefix,$prefix_style,#{?pane_in_mode,$copy_style,#{?pane_synchronized,$sync_style,$empty_style}}}"

  # Combine style and prompt into the final mode indicator
  local -r mode_indicator="#[default]$mode_style$mode_prompt#[default]"

  # Update the tmux status-left option with the mode indicator
  local -r status_left_value="$(tmux_option "status-left")"
  tmux set-option -gq "status-left" "${status_left_value/$mode_indicator_placeholder/$mode_indicator}"

  # Update the tmux status-right option similarly
  local -r status_right_value="$(tmux_option "status-right")"
  tmux set-option -gq "status-right" "${status_right_value/$mode_indicator_placeholder/$mode_indicator}"
}

# Call the function to initialize the tmux mode indicator
init_tmux_mode_indicator
