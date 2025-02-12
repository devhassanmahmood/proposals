#!/bin/bash
set -e

if [ -z "$POSTGRES_USER" ]; then
  echo "POSTGRES_USER environment variable missing!"
  exit 1
fi

if [ -z "$DB_USER" ]; then
  echo "DB_USER environment variable missing!"
  exit 1
fi

echo
echo "Setting up database user $DB_USER and proposals databases..."
echo
psql -U "$POSTGRES_USER" -c "CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASS';"
echo

for db in proposals_test proposals_development proposals_production
do
  echo
  echo "Setting up $db database..."
  psql -U "$POSTGRES_USER" -c "CREATE DATABASE $db OWNER=$DB_USER
    ENCODING 'UTF8' LC_COLLATE='en_US.utf8' LC_CTYPE='en_US.utf8'"

  psql -U "$POSTGRES_USER" -c "GRANT ALL PRIVILEGES ON DATABASE $db to $DB_USER"
done

echo
echo "Finished database setup."
echo
