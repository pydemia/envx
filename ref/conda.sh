conda () {
        \local cmd="${1-__missing__}"
        case "$cmd" in
                (activate | deactivate) __conda_activate "$@" ;;
                (install | update | upgrade | remove | uninstall) __conda_exe "$@" || \return
                        __conda_reactivate ;;
                (*) __conda_exe "$@" ;;
        esac
}

__conda_activate () {
        if [ -n "${CONDA_PS1_BACKUP:+x}" ]
        then
                PS1="$CONDA_PS1_BACKUP" 
                \unset CONDA_PS1_BACKUP
        fi
        \local ask_conda
        ask_conda="$(PS1="${PS1:-}" __conda_exe shell.posix "$@")"  || \return
        \eval "$ask_conda"
        __conda_hashr
}

__conda_exe () {
        (
                "$CONDA_EXE" $_CE_M $_CE_CONDA "$@"
        )
}

__conda_hashr () {
        if [ -n "${ZSH_VERSION:+x}" ]
        then
                \rehash
        elif [ -n "${POSH_VERSION:+x}" ]
        then
                :
        else
                \hash -r
        fi
}

__conda_reactivate () {
        \local ask_conda
        ask_conda="$(PS1="${PS1:-}" __conda_exe shell.posix reactivate)"  || \return
        \eval "$ask_conda"
        __conda_hashr
}
