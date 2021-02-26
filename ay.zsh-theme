# Based on ys theme by Abraham Yang
# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood

# VCS
AY_VCS_PROMPT_PREFIX1=" %{$fg[white]%}on%{$reset_color%} "
AY_VCS_PROMPT_PREFIX2=":%{$terminfo[bold]$fg[cyan]%}"
AY_VCS_PROMPT_SUFFIX="%{$reset_color%}"
AY_VCS_PROMPT_DIRTY=" %{$fg[red]%}🔥"
AY_VCS_PROMPT_CLEAN=" %{$fg[green]%}🤗"

# Git info
local git_info='$(git_prompt_info)'
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
		echo -n $(hg branch 2>/dev/null)
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$AY_VCS_PROMPT_DIRTY"
		else
			echo -n "$AY_VCS_PROMPT_CLEAN"
		fi
		echo -n "$AY_VCS_PROMPT_SUFFIX"
	fi
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
%{$terminfo[bold]$fg[blue]%}🐏%{$reset_color%} \
%(#,%{$terminfo[bold]$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$terminfo[bold]$fg[cyan]%}%n%{$reset_color%}) \
%{$fg[white]%}@ \
%{$terminfo[bold]$fg[green]%}%m %{$reset_color%}\
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
 \
%{$terminfo[bold]$fg[magenta]%}%* ⏰ $exit_code
%{$terminfo[bold]$fg[magenta]%}🐠 $ %{$reset_color%}"
