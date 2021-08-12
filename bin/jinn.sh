#!/usr/bin/env bash

set -x

function jinn_usage
{
    echo "Usage:"
    echo "$0 <project> <action>"
}

# Set up global jinn variables.
function jinn_setup
{
    jinn_folder=$HOME/.jinn
    if [ ! -d "$jinn_folder" ]
    then
        echo "$jinn_folder does not exist"
        exit 1
    fi

    # From https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
    local source="${BASH_SOURCE[0]}"
    while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
        local dir="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source" # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    jinn_bin="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
}

# Extract mandatory project and action from the command line.
function jinn_parse_args
{
    if [ $# -lt 2 ]
    then
        jinn_usage $0
        exit 1
    fi
    project=$1
    action=$2
}

# Set up action_script if the proposed executable script exists.
function jinn_try_action
{
    local maybe_action_script=$1
    [ -f "$maybe_action_script" ] && [ -x "$maybe_action_script" ] && action_script=$maybe_action_script
}

# Locate the action script and execute it, passing it the complete command line.
function jinn_dispatch
{
    project_folder=$jinn_folder/$project

    action_script=
    jinn_try_action "$project_folder/$action.sh"
    [ -z "$action_script" ] && jinn_try_action "$jinn_bin/jinn_$action.sh"

    if [ -z "$action_script" ]
    then
        echo "Failed to locate action $action"
        exit 1
    fi

    $action_script $*
}

jinn_setup
jinn_parse_args $*
jinn_dispatch $*
