#!/bin/bash
set -euo pipefail

# Format only once
if [ ! -d "/opt/hadoop/data/nameNode/current" ]; then
  echo "Formatting NameNode..."
  hdfs namenode -format -force -nonInteractive
fi

# Start NameNode in foreground
echo "Starting NameNode..."
hdfs namenode





# #!/usr/bin/env bash
# set -e

# # Wait for dependencies if any - for a single-node HDFS it's not necessary.
# # Format NameNode if not formatted
# if [ ! -d "/opt/hadoop/data/nameNode/current" ]; then
#   echo "[start-hdfs] formatting namenode..."
#   $HADOOP_HOME/bin/hdfs namenode -format -force || true
# fi

# # Start HDFS daemons (NameNode and Secondary/Journal if needed)
# echo "[start-hdfs] starting namenode..."
# # the image may use sbin/start-dfs.sh; prefer explicit start
# $HADOOP_HOME/sbin/hadoop-daemon.sh start namenode

# # Keep container alive and show logs
# tail -F /opt/hadoop/logs/* || sleep infinity
