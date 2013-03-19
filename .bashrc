# Check for an interactive session
[ -z "$PS1" ] && return

#Setup options
shopt -s checkwinsize cdspell extglob histappend
HISTCONTROL=ignoreboth
HISTIGNORE="[bf]g:exit:quit"

#Colors
[ -n "$TMUX" ] && export TERM=screen-256color
case "$TERM" in
    screen)
        export TERM=xterm-color
        ;;
    screen-256color)
        export TERM=xterm-color
        ;;
esac
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;31'
export CLICOLOR=1 

#Exports
export EDITOR=vim
export PAGER=less

# modified commands
alias ll='ls -lF'
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias du1='du --max-depth=1'
alias mkdir='mkdir -p -v'
alias ping='ping -c 5'
alias ..='cd ..'
alias ...='cd .. ; cd ..'

alias da='date "+%A, %B %d, %Y [%T]"'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet'
alias pg='ps -Af | grep $1'         # requires an argument (note: /usr/bin/pg is installed by the util-linux package; maybe a different alias name should be used)

#Functions
myps ()
{
    ps awwwxo "pid ppid %cpu %mem user command" | egrep "[P]ID|\b$1"
}


#Setup prompt

bash_prompt_command() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=25
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}

bash_prompt() {
    case $TERM in
        xterm*|rxvt*)
            local TITLEBAR='\[\033]0;\u@\h:${NEW_PWD}\007\]'
            ;;
        *)
            local TITLEBAR=""
            ;;
    esac

    local Color_Off='\e[0m'       # Text Reset

    # Regular Colors
    local Black='\e[0;30m'        # Black
    local Red='\e[0;31m'          # Red
    local Green='\e[0;32m'        # Green
    local Yellow='\e[0;33m'       # Yellow
    local Blue='\e[0;34m'         # Blue
    local Purple='\e[0;35m'       # Purple
    local Cyan='\e[0;36m'         # Cyan
    local White='\e[0;37m'        # White

    # Bold
    local BBlack='\e[1;30m'       # Black
    local BRed='\e[1;31m'         # Red
    local BGreen='\e[1;32m'       # Green
    local BYellow='\e[1;33m'      # Yellow
    local BBlue='\e[1;34m'        # Blue
    local BPurple='\e[1;35m'      # Purple
    local BCyan='\e[1;36m'        # Cyan
    local BWhite='\e[1;37m'       # White

    # Underline
    local UBlack='\e[4;30m'       # Black
    local URed='\e[4;31m'         # Red
    local UGreen='\e[4;32m'       # Green
    local UYellow='\e[4;33m'      # Yellow
    local UBlue='\e[4;34m'        # Blue
    local UPurple='\e[4;35m'      # Purple
    local UCyan='\e[4;36m'        # Cyan
    local UWhite='\e[4;37m'       # White

    # Background
    local On_Black='\e[40m'       # Black
    local On_Red='\e[41m'         # Red
    local On_Green='\e[42m'       # Green
    local On_Yellow='\e[43m'      # Yellow
    local On_Blue='\e[44m'        # Blue
    local On_Purple='\e[45m'      # Purple
    local On_Cyan='\e[46m'        # Cyan
    local On_White='\e[47m'       # White

    # High Intensty
    local IBlack='\e[0;90m'       # Black
    local IRed='\e[0;91m'         # Red
    local IGreen='\e[0;92m'       # Green
    local IYellow='\e[0;93m'      # Yellow
    local IBlue='\e[0;94m'        # Blue
    local IPurple='\e[0;95m'      # Purple
    local ICyan='\e[0;96m'        # Cyan
    local IWhite='\e[0;97m'       # White

    # Bold High Intensty
    local BIBlack='\e[1;90m'      # Black
    local BIRed='\e[1;91m'        # Red
    local BIGreen='\e[1;92m'      # Green
    local BIYellow='\e[1;93m'     # Yellow
    local BIBlue='\e[1;94m'       # Blue
    local BIPurple='\e[1;95m'     # Purple
    local BICyan='\e[1;96m'       # Cyan
    local BIWhite='\e[1;97m'      # White

    # High Intensty backgrounds
    local On_IBlack='\e[0;100m'   # Black
    local On_IRed='\e[0;101m'     # Red
    local On_IGreen='\e[0;102m'   # Green
    local On_IYellow='\e[0;103m'  # Yellow
    local On_IBlue='\e[0;104m'    # Blue
    local On_IPurple='\e[10;95m'  # Purple
    local On_ICyan='\e[0;106m'    # Cyan
    local On_IWhite='\e[0;107m'   # White

    #Color man pages
    export LESS_TERMCAP_mb=$(printf "$BRed")
    export LESS_TERMCAP_md=$(printf "$BRed")
    export LESS_TERMCAP_me=$(printf "$Color_Off")
    export LESS_TERMCAP_se=$(printf "$Color_Off")
    export LESS_TERMCAP_so=$(printf "\e[1;44;33m") #Blue background, yellow text
    export LESS_TERMCAP_ue=$(printf "$Color_Off")
    export LESS_TERMCAP_us=$(printf "$BGreen")

    #User/root color
    local UC=$Blue
    [ $UID -eq "0" ] && UC=$Red

    #Colored prompt
    PS1="${TITLEBAR}\[$Color_Off\][\[$UC\]\u\[$Color_Off\]@\[$UGreen\]\h\[$Color_Off\]:\[$BYellow\]\${NEW_PWD}\[$Color_Off\]]\\$ "
}

#Get updated NEW_PWD when cd
PROMPT_COMMAND=bash_prompt_command

#Set the prompt
bash_prompt
unset bash_prompt

#Source bashrc_local for config specific to this host
BASHRC_LOCAL=".bashrc@$(hostname -s)"
if [ -f ~/${BASHRC_LOCAL} ]; then
      source ~/${BASHRC_LOCAL}
fi
