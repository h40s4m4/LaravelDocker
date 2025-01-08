#!/bin/bash
set -e

echo "Starting MySQL Script :)"

if [ "${INCLUDE_TEST_DB}" = "true" ]; then
  echo "Creating test DB"
  mysql -uroot < /docker-entrypoint-initdb.d/db_test.sql
else
  echo "Skipping test database SQL script."
fi