## Project Overview
Build a security data lake for model development and environment monitoring. The system must ingest security events from a UDM Pro and containerized services, normalize to Elastic Common Schema (ECS), and store the normalized data in local object storage. Everything runs in containers on an Ubuntu server with Docker, Docker Compose, and Portainer.

## Environment
- Security events/logs source: Ubiquity Dream Machine (UDM) Pro.
- Host: Ubuntu server running Docker, Docker Compose, and Portainer.

## Requirements
- Everything must be containerized.
- Local, object-based storage for normalized data.
- Data collection and normalization to Elastic Common Schema (ECS) before storage.

## Data Flow (High Level)
1. Collect logs from UDM Pro and containerized services.
2. Parse and normalize into ECS.
3. Write normalized records to local object storage.

## Notes / Constraints
- Prefer open-source components.
- Avoid writing raw/unparsed logs to storage; normalize first.
