# SDP MCP Server Startup Guide

This guide describes how to start the MCP server with an on-premise ManageEngine ServiceDesk Plus (SDP) instance using an AuthToken.

## 1. Prerequisites

- Node.js (v18+)
- Docker & Docker Compose
- ManageEngine SDP On-Premise Instance (accessible from this machine)
- Generated AuthToken from SDP (API Key)

## 2. Configuration (`.env`)

1.  Copy `.env.example` to `.env`.
    ```bash
    cp .env.example .env
    ```
2.  Update the following fields in `.env`. You can leave most others as default for local testing.

    ```ini
    # Database (Ensure these match your docker-compose or local DB)
    DB_HOST=localhost
    DB_PORT=5433
    DB_USER=sdpmcpservice
    DB_PASSWORD=*jDE1Bj%IPXKMe%Z
    DB_NAME=sdp_mcp
    
    # Security (Generate a secure 32-char string)
    ENCRYPTION_KEY=your-32-character-encryption-key-here
    
    # Default SDP Config (Will be overridden by tenant config, but good to set defaults)
    SDP_BASE_URL=http://your-sdp-server:8080
    SDP_API_VERSION=v3
    ```

## 3. Start Infrastructure

Start the PostgreSQL and Redis containers using Docker Compose.

```bash
docker-compose up -d
```

Verify services are running:
```bash
docker-compose ps
```

## 4. Run Migrations

Initialize the database schema.

```bash
npm run db:migrate
```

## 5. Register Tenant (AuthToken Setup)

Use the helper script to register your SDP instance and AuthToken.

```bash
node scripts/setup-tenant-authtoken.js
```

Follow the prompts:
-   **Tenant Name**: E.g., `ProdHelpDesk`
-   **SDP Base URL**: E.g., `http://192.168.1.100:8080` (Ensure this URL is reachable)
-   **AuthToken**: Paste your generated key.

## 6. Start the Server

Start the MCP server.

```bash
npm start
```
*Or for development logging:*
```bash
npm run dev
```

The server will start (default port 3000) and attempts to listen for MCP connections.

## 7. Troubleshooting

-   **Database Connection Refused?** Check if Docker containers are running and port `5433` is not blocked.
-   **Authentication Failed?** Ensure the AuthToken is valid and the Base URL is correct. Re-run step 5 to update the configuration if needed.
