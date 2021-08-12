#!/bin/bash

jinn_folder=$HOME/.jinn

if [ ! -d "$jinn_folder" ]
then
    echo "$jinn_folder does not exist"
    exit 1
fi
