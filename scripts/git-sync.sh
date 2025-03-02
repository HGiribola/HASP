#!/bin/bash

# configs
REPO_DIR="$C:\Users\notej\flowcore"
BRANCH="main"
SLEEP_TIME=300
MAX_RETRIES=3
LOG_FILE="$HOME/sync.log"

# funcs
sync_repo() {
    cd "REPO_DIR" || exit 1

    # check changes
    git pull origin "$BRANCH"

    git add .

    #commit if changes
    if [[ -n $(git status -uno --porcelain) ]]; then
        git commit -m "auto-commit: $(date + '%Y-%m-%d %H:%M:%S')" --no-verify
    fi

    #push and retry if failed
    for i in $(seq 1 "$MAX_RETRIES"); do
        if git push origin "$BRANCH"; then
            return 0
        fi
        sleep 12
    done
    return 1
}

# main
while true; do
    echo " === INICIANDO SYNC EM $(date + '%Y-%m-%d %H:%M:%S') === " >> "$LOG_FILE"
    if sync_repo >> "$LOG_FILE" 2>&1; then
        echo "SYNC CONCLUIDO COM SUCESSO!" >> "$LOG_FILE"
    else
        echo "ERRO: FALHA NO SYNC APÓS $MAX_RETRIES TENTATIVAS" >> "$LOG_FILE"
    fi
    sleep $SLEEP_TIME
done