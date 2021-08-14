#!/usr/bin/env bash

if [ -z "$JINN_PROJECT_WORK_DIR" ]; then
    echo "No such project '$JINN_PROJECT'"
    exit 1
fi

echo "Project:          $JINN_PROJECT"
echo "Project dir:      $JINN_PROJECT_DIR"
echo "Project work dir: $JINN_PROJECT_WORK_DIR"
# Todo: build dir, configs...
