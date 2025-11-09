#!/bin/bash
set -e

BACKUP_DIR="/backups/${PGDATABASE}_$(date +%Y-%m-%d_%H-%M-%S)"
mkdir -p "$BACKUP_DIR"

echo "Starting directory backup in $BACKUP_DIR"

# Тип бэкапа dir (-F d)
pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -F d "$PGDATABASE" -f "$BACKUP_DIR"

echo "Backup directory created: $BACKUP_DIR"

# Архивируем каталог
tar -czf "${BACKUP_DIR}.tar.gz" -C "/backups" "$(basename "$BACKUP_DIR")"

echo "Backup archive created: ${BACKUP_DIR}.tar.gz"

# Отправляем архив на S3
aws s3 cp "${BACKUP_DIR}.tar.gz" "s3://${S3_BUCKET}/${S3_PATH}/$(basename "${BACKUP_DIR}.tar.gz")"

echo "Backup uploaded to s3://${S3_BUCKET}/${S3_PATH}"

# Очистка после успешной отправки (опционально)
rm -rf "$BACKUP_DIR" "${BACKUP_DIR}.tar.gz"

echo "Backup process completed"