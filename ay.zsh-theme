# ============================================================================
# AY ZSH Theme - Clean and minimal theme for developers
# Author: Abraham Yang | Created: July 2023 Updated: November 2025
# ============================================================================

# --- VCS Configuration ---
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}on%{$reset_color%} git:%{$terminfo[bold]$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}🚧"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✅"

# --- Git Helper Functions ---
git_commit_hash() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
    git log -n 1 >/dev/null 2>&1 || return
    echo -n "%{$fg[white]%} # %{$terminfo[bold]$fg[blue]%}$(git rev-parse --short HEAD)"
}

hg_prompt_info() {
    [ -d '.hg' ] || return
    echo -n " %{$fg[white]%}on%{$reset_color%} hg:%{$terminfo[bold]$fg[cyan]%}$(hg branch 2>/dev/null)"
    [ -n "$(hg status 2>/dev/null)" ] && echo -n "${ZSH_THEME_GIT_PROMPT_DIRTY}" || echo -n "${ZSH_THEME_GIT_PROMPT_CLEAN}"
    echo -n "${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}



# --- System Info Functions ---
battery_info() {
    if pmset -g batt | grep -q 'AC Power'; then
        echo -n "🔌 %{$terminfo[bold]$fg[cyan]%}Charging%{$reset_color%}"
    else
        local battery_num=$(pmset -g batt | grep -Eo '[0-9]+%' | sed 's/%//')
        if [ "$battery_num" -lt 50 ]; then
            echo -n "%{$terminfo[bold]$fg[red]%}🪫 ${battery_num}%%%{$reset_color%}"
        else
            echo -n "%{$terminfo[bold]$fg[cyan]%}🔋 ${battery_num}%%%{$reset_color%}"
        fi
    fi
}

node_version() {
    # Only show Node version if in a Node.js project directory
    if [ -f "package.json" ] && command -v node &> /dev/null; then
        local node_ver=$(node --version 2>/dev/null)
        echo -n "%{$fg[green]%}⬢%{$reset_color%} %{$terminfo[bold]$fg[green]%}${node_ver}%{$reset_color%} "
        
        # Show Yarn version if available
        if command -v yarn &> /dev/null; then
            local yarn_ver=$(yarn --version 2>/dev/null)
            echo -n "%{$fg[blue]%}📦%{$reset_color%} %{$terminfo[bold]$fg[blue]%}${yarn_ver}%{$reset_color%} "
        fi
    fi
}

time_info() {
    local time_icon=$([ "$(date +%p)" = "AM" ] && echo "🌞" || echo "☕️")
    echo -n "%{$terminfo[bold]$fg[magenta]%}%D %* $(date +%p) ${time_icon}%{$reset_color%}"
}


# --- Prompt Components (Extract complex color codes for readability) ---
local icon_sheep="🐏"
local icon_fish="🐠"

# User display: yellow background for root, cyan for normal user
local user_display='%(#,%{$terminfo[bold]$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$terminfo[bold]$fg[cyan]%}%n%{$reset_color%})'

# Host and directory
local host_name='%{$terminfo[bold]$fg[green]%}%m%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}'

# Connectors
local connector_at='%{$fg[white]%}@%{$reset_color%}'
local connector_in='%{$fg[white]%}in%{$reset_color%}'

# Exit code (only shown on error)
local exit_code='%(?,,C:%{$fg[red]%}%?%{$reset_color%})'

# Command prompt symbol
local prompt_symbol='%{$terminfo[bold]$fg[magenta]%}$%{$reset_color%}'

# --- Main Prompt ---
PROMPT="
${icon_sheep} ${user_display} ${connector_at} ${host_name} ${connector_in} ${current_dir}\$(hg_prompt_info)\$(git_prompt_info)\$(git_commit_hash) \$(time_info) ${exit_code}
${icon_fish} ${prompt_symbol} "

# --- Right Prompt ---
RPROMPT="\$(node_version)\$(battery_info)"
