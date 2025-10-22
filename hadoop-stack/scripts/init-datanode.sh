#!/bin/bash
set -euo pipefail

# Make sure datadir exists with proper perms
mkdir -p /opt/hadoop/data/dataNode
chown -R hadoop:hadoop /opt/hadoop/data/dataNode
chmod 755 /opt/hadoop/data/dataNode

# Start DataNode in foreground
echo "Starting DataNode..."
hdfs datanode




# #!/usr/bin/env bash
# set -e

# echo "[start-datanode] waiting for namenode to respond..."
# until nc -z namenode 8020; do
#   echo "  namenode not ready yet..."
#   sleep 5
# done

# echo "[start-datanode] starting datanode..."
# $HADOOP_HOME/sbin/hadoop-daemon.sh start datanode

# echo "[start-datanode] tailing logs..."
# tail -F /opt/hadoop/logs/* || sleep infinity
