# Dbus session
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] || [ ! -e "${DBUS_SESSION_BUS_ADDRESS#unix:path=}" ]; then
    eval $(dbus-launch --sh-syntax)
fi

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
# ZSH autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Pfetch
export PF_INFO="ascii title os kernel uptime pkgs memory shell"

# Starship prompt
eval "$(starship init zsh)"
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
alias discord="flatpak run com.discordapp.Discord > /dev/null 2>&1 &"

#Vega CLI
source "/home/fraggi/vega/env"
