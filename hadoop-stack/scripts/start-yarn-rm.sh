#!/bin/bash
set -euo pipefail

echo "Starting YARN ResourceManager..."
yarn resourcemanager




# #!/usr/bin/env bash
# set -e

# echo "[start-resourcemanager] waiting for namenode..."
# until nc -z namenode 9870; do
#   echo "  namenode not yet reachable..."
#   sleep 5
# done

# echo "[start-resourcemanager] starting YARN ResourceManager..."
# $HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager

# echo "[start-resourcemanager] tailing logs..."
# tail -F /opt/hadoop/logs/* || sleep infinity