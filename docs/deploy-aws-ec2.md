# Deploy on one AWS EC2 instance

This layout runs George Reply's web app, DM worker, cron scheduler, PostgreSQL,
Redis, and Caddy HTTPS proxy on one small EC2 instance. It is intended for a
single-owner installation with modest traffic.

## Host requirements

- Ubuntu 24.04 ARM64
- `t4g.small` or larger
- 16 GiB gp3 root volume
- Docker Engine with the Compose plugin
- inbound TCP 80 and 443 from the internet
- inbound TCP 22 restricted to the operator's IP

The databases have no published host ports. Caddy is the only public
application container and obtains an HTTPS certificate for `APP_HOST`.
The EC2 user-data bootstrap script is at `deploy/aws/bootstrap.sh`.

## Environment

Create `.env.production` from `.env.example`, using the production HTTPS URL
for `NEXTAUTH_URL`. Create a separate `.env.aws` for Compose interpolation:

```dotenv
APP_HOST=reply.example.com
POSTGRES_PASSWORD=replace-with-a-random-password
```

Both files are ignored by Git. Keep their permissions at `0600`.

## Start or update

```bash
docker compose --env-file .env.aws -f docker-compose.aws.yml up -d --build
docker compose --env-file .env.aws -f docker-compose.aws.yml ps
curl -fsS https://reply.example.com/api/health
```

The health endpoint should report `status: ok` and `worker.healthy: true`.

## Rollback

Check out the prior known-good commit and rerun the start command. Do not remove
the named volumes: they contain PostgreSQL, Redis, and Caddy state.
