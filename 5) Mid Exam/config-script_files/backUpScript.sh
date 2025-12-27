#!/bin/bash

# THis command is used to stop the script tottally if any error happened for security

set -euo pipefail

BACKUP_ROOT="/compnay"

TMP_DIR="/tmp/qtech_backups"

S3_BUCKET="s3://mid-bucket-devops-exam-ahmaquraan"

LOG_FILE="/var/log/s3backup.log"

timestamp() { date +"%Y-%m-%d %H:%M:%S"; }

log() {

  local level="$1"
  shift

  echo "$(timestamp) [$level] $*" | sudo tee -a "$LOG_FILE" >/dev/null

}

# Must be root

if [[ $EUID -ne 0 ]]; then

  echo "This script must be run as root." >&2

  exit 1

fi

# Ensure log file exist and we can write on

touch "$LOG_FILE"

chmod 640 "$LOG_FILE"

# Check backup root

if [[ ! -d "$BACKUP_ROOT" ]]; then

  log ERROR "The backup dir is not exist."

  exit 1

fi

# Create temporary working directory

mkdir -p "$TMP_DIR"

DATE_STR="$(date +%F)"

ERRORS=0

# For Loop on the company dir

for dept_dir in "$BACKUP_ROOT"/*; do

  if [[ -d "$dept_dir" ]]; then

    dept_name="$(basename "$dept_dir")"

    archive_name="${dept_name}_${DATE_STR}.tar.gz"

    archive_path="${TMP_DIR}/${archive_name}"

    log INFO "Archiving department '$dept_name' from $dept_dir to $archive_path"

    # Create tar.gz

    if tar -czf "$archive_path" -C "$BACKUP_ROOT" "$dept_name"; then

      log INFO "Archive created: $archive_name"

    else

      log ERROR "Failed to create archive for $dept_name"

      ERRORS=1

      continue

    fi

    # Upload to S3

    log INFO "Uploading $archive_name to $S3_BUCKET"

    if aws s3 cp "$archive_path" "$S3_BUCKET/${archive_name}"; then

      log INFO "Upload successful: $S3_BUCKET/${archive_name}"

    else

      log ERROR "Upload failed for $archive_name"

      ERRORS=1

      continue

    fi

  fi

done

# Clean tmp_di if you want

rm -f "${TMP_DIR}"/*.tar.gz || true

if [[ $ERRORS -eq 0 ]]; then

  log INFO "Backup job completed successfully."

else

  log ERROR "Backup job completed with errors. Check log above."

fi

exit "$ERRORS"
