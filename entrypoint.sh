#!/bin/bash
# Run deploy.sh if configs are mounted, then drop into zsh
if [[ -f ~/configs/deploy.sh ]]; then
    bash ~/configs/deploy.sh
fi
exec /bin/zsh
