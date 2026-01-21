#!/bin/bash
# Wait for MinIO to be ready
until mc alias set myminio http://minio:9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}" 2>/dev/null; do
    echo "Waiting for MinIO to be ready..."
    sleep 2
done

# Create the security-logs bucket if it doesn't exist
mc mb --ignore-existing myminio/security-logs

# Set bucket policy to allow read access (for Trino)
mc anonymous set download myminio/security-logs

echo "MinIO bucket 'security-logs' is ready"
