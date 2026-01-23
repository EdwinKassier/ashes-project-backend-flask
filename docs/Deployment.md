# Deployment and Operations

## CI/CD Pipeline

The project utilizes GitHub Actions for continuous integration and deployment. The pipeline ensures that all code changes undergo rigorous testing and security scanning before being merged or deployed.

### Pipeline Stages

1. **Quality Checks**: Enforces code formatting (Black), linting (Flake8), type checking (Mypy), and import sorting (isort).
2. **Testing**: Executes the full test suite (unit and integration) and verifies coverage thresholds.
3. **Security**: Performs vulnerability scanning using Bandit (static analysis) and Safety (dependencies).
4. **Deployment**: Builds the Docker image using a multi-stage process, pushes to the registry, and deploys to the production environment (on release tags).

- **Reproducible Builds**: The CI pipeline utilizes `uv` to manage dependencies. By leveraging `uv.lock`, the pipeline ensures that every build environment is identical, preventing "it works on my machine" issues and ensuring consistent behavior between testing and production.

### Pipeline Triggers

- **Push to Main**: Triggers quality, testing, and security stages.
- **Pull Request**: Triggers all validation checks and code review workflows.
- **Release Tag** (`prod/v*`): Triggers the full pipeline including the production deployment stage.

## Containerization Strategy

The application utilizes a multi-stage Docker build to optimize image size and security.

- **Builder Stage**: Uses `python:3.11-slim` to install build dependencies (gcc, g++, curl) and the `uv` package manager. The `slim` variant is chosen over `alpine` to ensure better compatibility with Python C-extensions (like those in SQLAlchemy or Pandas) while maintaining a small footprint.
- **Production Stage**: A separate `python:3.11-slim` stage that copies only the finalized virtual environment and application source code. This stage omits build tools and the `uv` binary, significantly reducing the attack surface.
- **Security Hardening**: The container executes under a dedicated non-root `appuser`. The filesystem permissions are restricted to allow write access only to designated `log` and `data` directories.
- **Runtime Health Monitoring**: An internal `HEALTHCHECK` instruction is defined using `curl` to monitor the `/health` endpoint every 30 seconds.

## Deployment Strategy

### Tag-Based Deployment

Production deployments are initiated by creating and pushing a semantic version tag.

**Version Format**: `prod/vMAJOR.MINOR.PATCH`

**Deployment Command**:
```bash
./scripts/create-prod-release.sh 1.0.0
```

Alternatively, tags can be managed manually via Git:
```bash
git tag -a prod/v1.0.0 -m "Release v1.0.0"
git push origin prod/v1.0.0
```

### Production Configuration

Production environments require specific environment variable configurations:

```bash
FLASK_ENV=production
SECRET_KEY=<secure-random-string>
DATABASE_URL=postgresql://user:pass@host:5432/db
CORS_ORIGINS=https://your-production-domain.com
RATE_LIMIT_ENABLED=True
ENABLE_MONITORING=True
```

## Monitoring

### Health Checks

The application exposes standard health check endpoints for load balancers and monitoring systems.

| Endpoint | Method | Response | Description |
|:---|:---|:---|:---|
| `/health` | `GET` | JSON | Returns system health status and timestamp. |
| `/status` | `GET` | JSON | Returns service version and operational status. |

### Logging

Structured logging is implemented to capture request details, errors, and performance metrics, facilitating debugging and observability.
