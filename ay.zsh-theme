# Based on ys theme by Abraham Yang
# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# July 2023 Abraham Yang

# VCS
AY_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
AY_VCS_PROMPT_PREFIX2=":%{$terminfo[bold]$fg[cyan]%}"
AY_VCS_PROMPT_PREFIX3="%{$terminfo[bold]$fg[blue]%}"
AY_VCS_PROMPT_SUFFIX="%{$reset_color%}"
AY_VCS_PROMPT_DIRTY=" %{$fg[red]%}🔥"
AY_VCS_PROMPT_CLEAN=" %{$fg[green]%}👌"

# Git info

local git_commit_hash='$(git_commit_hash)'
local git_info='$(git_prompt_info)'
git_commit_hash() {
  if [ -d .git ]; then
    echo -n "%{$fg[white]%} # %{$terminfo[bold]$fg[blue]%}"
    git rev-parse HEAD | cut -c -8
  fi
}
ZSH_THEME_GIT_PROMPT_PREFIX="${AY_VCS_PROMPT_PREFIX1}git${AY_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$AY_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$AY_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$AY_VCS_PROMPT_CLEAN"


# HG info
local hg_info='$(ay_hg_prompt_info)'
ay_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${AY_VCS_PROMPT_PREFIX1}hg${AY_VCS_PROMPT_PREFIX2}"
		echo -n "$(hg branch 2>/dev/null)"
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$AY_VCS_PROMPT_DIRTY"
		else
			echo -n "$AY_VCS_PROMPT_CLEAN"
		fi
		echo -n "$AY_VCS_PROMPT_SUFFIX"
	fi
}

# Node info
local node_info='$(ay_node_prompt_info)'
ay_node_prompt_info() {
  # make sure this is a node dir
  if [ -f 'package.json' ]; then
    echo -n "node:%{$terminfo[bold]$fg[cyan]%}"
    echo -n $(node -v 2>/dev/null)
    echo -n "$AY_VCS_PROMPT_SUFFIX"
  fi
}

# Python info
local python_info='$(ay_python_prompt_info)'
ay_python_prompt_info() {
  # make sure this is a python dir
  echo -n "python:%{$terminfo[bold]$fg[cyan]%}v"
  echo -n "$(python --version 2>&1 | awk '{print $2}')"
  echo -n "$AY_VCS_PROMPT_SUFFIX"
}

# Mac OS X version
local osx_info='$(ay_osx_prompt_info)'
ay_osx_prompt_info() {
  echo -n "macOS:%{$terminfo[bold]$fg[cyan]%}v"
  echo -n "$(sw_vers -productVersion)"
  echo -n "$AY_VCS_PROMPT_SUFFIX"
}

# Battery info
local battery_info='$(ay_battery_prompt_info)'
ay_battery_prompt_info() {
  if [ "$(pmset -g batt | grep -o 'AC Power')" ]; then
    echo -n "🔌 %{$terminfo[bold]$fg[cyan]%}Charging"
  else
    echo -n "%{$terminfo[bold]$fg[cyan]%}🔋 "
    echo -n "$(pmset -g batt | grep -o '[0-9]*%' | tr -d '%')"
    echo -n "%%"
  fi
  echo -n "$AY_VCS_PROMPT_SUFFIX"
}

# Network info
local network_info='$(ay_network_prompt_info)'

ay_network_prompt_info() {
  if [ "$(networksetup -getairportnetwork en0 | grep -o 'AirPort')" ]; then
    echo -n "🈳️"
  else
    echo -n "🛜 %{$terminfo[bold]$fg[cyan]%}"
    echo -n "$(networksetup -getairportnetwork en0 | cut -c 24-)"
    echo -n "$AY_VCS_PROMPT_SUFFIX"
  fi
}

# Time info
local time_info='$(ay_time_prompt_info)'
ay_time_prompt_info() {
  echo -n "%{$terminfo[bold]$fg[magenta]%}%D %* $(date +%p)"
  if [ "$(date +%p)" = "AM" ]; then
    echo -n " 🌅"
  else
    echo -n " 🌇"
  fi
  echo -n "$AY_VCS_PROMPT_SUFFIX"
}




local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# Prompt format:
#
# PRIVILEGES USER @ MACHINE in DIRECTORY on git:BRANCH STATE [TIME] C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# % ay @ ay-mbp in ~/.oh-my-zsh on git:master x [21:47:42] C:0
# $
# %{$terminfo[bold]$fg[magenta]%}💖 zQw %{$reset_color%}\

PROMPT="
🐏%{$terminfo[bold]$fg[blue]%}%{$reset_color%} \
%(#,%{$terminfo[bold]$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$terminfo[bold]$fg[cyan]%}%n%{$reset_color%}) \
%{$fg[white]%}@ \
%{$terminfo[bold]$fg[green]%}%m %{$reset_color%}\
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
${git_commit_hash} \
${time_info}\
${exit_code}
💻 ${osx_info} ${battery_info} ${network_info} ${node_info} ${python_info}
🐠 %{$terminfo[bold]$fg[magenta]%}$ %{$reset_color%}"
