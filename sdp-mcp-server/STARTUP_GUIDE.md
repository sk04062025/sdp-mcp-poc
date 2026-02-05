# SDP MCP Server Startup Guide (Docker)

This guide describes how to start the MCP server with an on-premise ManageEngine ServiceDesk Plus (SDP) instance using an AuthToken, using only Docker.

## 1. Prerequisites

- Docker & Docker Compose
- ManageEngine SDP On-Premise Instance (accessible from this machine)
- Generated AuthToken from SDP (API Key)

## 2. Configuration (`.env`)

1.  Copy `.env.example` to `.env`.
    ```bash
    cp .env.example .env
    ```
2.  Update the following fields in `.env`.

    ```ini
    # Database (Keep these defaults for Docker networking)
    DB_HOST=postgres
    DB_PORT=5432
    DB_USER=sdpmcpservice
    DB_PASSWORD=*jDE1Bj%IPXKMe%Z
    DB_NAME=sdp_mcp
    
    # Redis
    REDIS_HOST=redis
    REDIS_PORT=6379

    # Security (Generate a secure 32-char string)
    ENCRYPTION_KEY=your-32-character-encryption-key-here
    
    # Default SDP Config
    SDP_BASE_URL=http://your-sdp-server:8080
    SDP_API_VERSION=v3
    ```

## 3. Start Application

Build and start the services (Server, Postgres, Redis).

```bash
docker-compose up -d --build
```

Verify services are running:
```bash
docker-compose ps
```

## 4. Run Migrations

Initialize the database schema by running the migration script inside the server container.

```bash
docker-compose run --rm server npm run db:migrate
```

## 5. Register Tenant (AuthToken Setup)

Use the helper script to register your SDP instance and AuthToken. We run this inside the container to ensure it has access to the database.

```bash
docker-compose run --rm server node scripts/setup-tenant-authtoken.js
```

Follow the prompts:
-   **Tenant Name**: E.g., `ProdHelpDesk`
-   **SDP Base URL**: E.g., `http://192.168.1.100:8080` (Ensure this URL is reachable from within the container)
-   **AuthToken**: Paste your generated key.

> **Note**: If your SDP server is on the host machine (outside Docker), you may need to use `host.docker.internal` (Windows/Mac) or the host's IP address instead of `localhost`.

## 6. Verify

Tail the logs to ensure the server is running correctly:

```bash
docker-compose logs -f server
```

The server listens on port 3000 by default.
