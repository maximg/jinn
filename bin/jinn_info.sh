#!/usr/bin/env bash

if [ -z "$JINN_PROJECT_WORK_FOLDER" ]; then
    echo "No such project '$JINN_PROJECT'"
    exit 1
fi

echo "Project:          $JINN_PROJECT"
echo "Project folder:   $JINN_PROJECT_FOLDER"
echo "Work folder:      $JINN_PROJECT_WORK_FOLDER"
# Todo: build folder, configs...
