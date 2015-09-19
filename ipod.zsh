####################
# Thême
####################
ZSH_THEME="ipygmalion"
#
####################
# Plugins
####################
plugins=(command-not-found common-aliases debian dircycle dirhistory docker fabric git history screen sudo)
#
####################
# Alias
####################
alias ssa='ssh-add'
alias grep='grep --colour=auto'
alias diff='colordiff -u'
#
####################
# BindKey
####################
bindkey "${key[Up]}" up-line-or-history
bindkey "${key[Down]}" down-line-or-history
bindkey "${key[PageUp]}" history-beginning-search-backward
bindkey "${key[PageDown]}" history-beginning-search-forward
#
