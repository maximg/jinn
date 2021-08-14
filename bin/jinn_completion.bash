#/usr/bin/env bash

_jinn_completions()
{
    if [ "${#COMP_WORDS[@]}" != "2" ]; then
        return
    fi

    local jinn_dir=$HOME/.jinn
    local projects=
    for dir in $jinn_dir/* ; do
        if [ -d "$dir" ]; then
            projects+="$(basename $dir) "
        fi
    done
    COMPREPLY=($(compgen -W "$projects" -- "${COMP_WORDS[1]}"))
}

complete -F _jinn_completions jinn.sh
