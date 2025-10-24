#!/bin/bash
set -e

# Wait for PostgreSQL to start
until pg_isready -U postgres; do
  echo "⏳ Waiting for PostgreSQL to start..."
  sleep 2
done

# Check if the restore was already done
if psql -U postgres -d postgres -tAc "SELECT 1 FROM pg_tables WHERE schemaname='public' LIMIT 1;" | grep -q 1; then
  echo "✅ Database already initialized, skipping restore."
else
  echo "🚀 Restoring database from dump..."
  pg_restore -U postgres -d postgres /tmp/DATA2023.dump
  echo "✅ Restore complete!"
fi
