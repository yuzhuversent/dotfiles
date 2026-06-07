# ~/.bash_profile: executed by bash for login shells.
#
# For a login shell, bash reads ~/.bash_profile (or ~/.bash_login, or
# ~/.profile) but NOT ~/.bashrc.  This file bridges the two so that all
# interactive settings defined in ~/.bashrc are available in login shells too.

# Source ~/.bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    # shellcheck source=.bashrc
    source "$HOME/.bashrc"
fi

# ── Login-only settings ───────────────────────────────────────────────────────
# These run only for login shells (e.g. SSH sessions, TTY logins).

# Include ~/bin in PATH if it exists
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

# ── Local overrides ───────────────────────────────────────────────────────────
[ -f "$HOME/.bash_profile.local" ] && source "$HOME/.bash_profile.local"
