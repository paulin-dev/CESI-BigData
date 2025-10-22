#!/bin/bash
set -euo pipefail

# Create local directories for NodeManager
mkdir -p /tmp/nm-local-dir /tmp/nm-log-dir
chown -R hadoop:hadoop /tmp/nm-local-dir /tmp/nm-log-dir

echo "Starting YARN NodeManager..."
yarn nodemanager





# #!/usr/bin/env bash
# set -e

# echo "[start-nodemanager] waiting for ResourceManager..."
# until nc -z resourcemanager 8032; do
#   echo "  ResourceManager not yet reachable..."
#   sleep 5
# done

# echo "[start-nodemanager] starting YARN NodeManager..."
# $HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager

# echo "[start-nodemanager] tailing logs..."
# tail -F /opt/hadoop/logs/* || sleep infinity
