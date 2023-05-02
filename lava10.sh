#!/bin/bash
echo "-----------------------------------------------------------------------------"

cd $HOME/lava
git pull
git checkout v0.10.1
make build
for((;;)); do
    height=$(lavad status |& jq -r ."SyncInfo"."latest_block_height")
    if ((height==184620)); then
      systemctl stop lavad
      mv $HOME/lava/build/lavad $(which lavad)
      sudo systemctl restart lavad
      echo "restart"
      break
    else
      echo $height
    fi
    sleep 1
done
journalctl -u lavad -f -o cat
