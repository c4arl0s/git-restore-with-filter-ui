#!/usr/bin/env bash

EXTENSION=${1:?"Error: The first parameter is missing, It should be an extension."}
STAGED_FILES=$(git --no-pager diff --name-only --cached --diff-filter=AM | grep ".*.${EXTENSION}$")

FILES_WITH_EXTENSION="Tracked files to unstaged with extension ($EXTENSION):"
ERROR_MSG="Tracked files with extension: $EXTENSION don't exist"

if [[ $STAGED_FILES ]]; then
    let COUNTER=0
    LINE=$(git --no-pager diff --name-only --cached --diff-filter=AM | grep ".*.${EXTENSION}$" |
           while read STAGED_FILE
           do
               let "COUNTER+=1"
               echo "\"$STAGED_FILE\" \"$COUNTER\" off"
           done
          )
    echo $LINE;
    SELECTED_STAGED_FILES=$(echo $LINE | 
                             xargs dialog --stdout --checklist $FILES_WITH_EXTENSION 0 0 0
                            )
    [ ! -z "$SELECTED_STAGED_FILES" ] && echo "$SELECTED_STAGED_FILES" | xargs git restore --staged || echo "🟡 You did not select any file to restore with"
else
    echo  $ERROR_MSG
fi
