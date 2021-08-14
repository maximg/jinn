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
    jinn_projects_dir=$HOME/.jinn
    if [ ! -d "$jinn_projects_dir" ]
    then
        echo "$jinn_projects_dir does not exist"
        exit 1
    fi

    # From https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
    local source="${BASH_SOURCE[0]}"
    while [ -h "$source" ]; do # resolve $source until the file is no longer a symlink
        local dir="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source" # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    export JINN_BIN_DIR="$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )"
    export JINN_LIB_DIR="$( dirname "$JINN_BIN_DIR" )"/lib
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
    project_dir=$jinn_projects_dir/$project

    action_script=
    jinn_try_action "$project_dir/$action.sh"
    [ -z "$action_script" ] && jinn_try_action "$JINN_BIN_DIR/jinn_$action.sh"

    if [ -z "$action_script" ]
    then
        echo "Failed to locate action $action"
        exit 1
    fi

    # TODO: check if they exist.
    export JINN_PROJECT=$project
    export JINN_PROJECT_DIR=$project_dir
    export JINN_PROJECT_WORK_DIR="$(readlink "$JINN_PROJECT_DIR/project_dir")"

    $action_script $*
}

jinn_setup
jinn_parse_args $*
jinn_dispatch $*
