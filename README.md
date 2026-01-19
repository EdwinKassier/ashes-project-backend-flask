<div align="center">

<img src="https://www.edwinkassier.com/Assets/Monogram.png" alt="Ashes Project Monogram" width="80" height="80">

# Ashes Project Flask API Boilerplate

<div align="center">

**A Flask API boilerplate for rapid development**

</div>

<div align="center">

[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![Flask 2.2+](https://img.shields.io/badge/flask-2.2+-green.svg)](https://flask.palletsprojects.com/)

</div>

<div align="center">

[![Docker](https://img.shields.io/badge/docker-supported-blue.svg)](https://www.docker.com/)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

</div>

</div>

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
- [Quick Start](#quick-start)
- [Installation Options](#installation-options)
- [Testing](#testing)
- [Code Quality](#code-quality)
- [Security](#security)
- [CI/CD Pipeline](#cicd-pipeline)
- [Available Commands](#available-commands)
- [Deployment](#deployment)
- [Monitoring](#monitoring)
- [API Documentation](#api-documentation)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Overview

A Flask API boilerplate designed for rapid development of web APIs.

This template provides everything you need to build scalable, maintainable web APIs with Flask. It includes features like automated testing, CI/CD pipelines, security scanning, monitoring, and deployment automation.

### API Architecture

The boilerplate supports both **REST** and **GraphQL** endpoints, giving you flexibility in how you build your API:

- **REST API**: Traditional HTTP endpoints with JSON responses
- **GraphQL**: Flexible query language for efficient data fetching
- **OpenAPI Documentation**: Interactive API documentation for both interfaces

### Feature Overview

| **Development** | **Testing** | **Deployment** |
|:---|:---|:---|
| Pre-commit hooks | Unit tests | Docker containers |
| Code formatting | Integration tests | CI/CD pipeline |
| Type checking | Coverage reporting | Cloud deployment |
| Linting | Test automation | Health monitoring |

---

## Key Features

| **Architecture** | **Security** | **Monitoring** | **Performance** |
|:---|:---|:---|:---|
| Domain-Driven Design | Security Scanning | Health Checks | SQLite Database |
| Rich Domain Models | Dependency Checks | Structured Logging | Background Tasks (Celery) |
| Clean Separation | Authentication | Error Tracking | API Rate Limiting |

### Feature Categories

<details>
<summary><b>Security Features</b></summary>

- **Security Headers**: X-Content-Type-Options, X-Frame-Options, X-XSS-Protection
- **Input Validation**: Comprehensive parameter sanitization
- **Rate Limiting**: Configurable rate limiting
- **CORS Protection**: Configurable CORS policies
- **Authentication**: Firebase authentication integration

</details>

<details>
<summary><b>Architecture</b></summary>

- **Domain-Driven Design**: Two-domain architecture (domain + shared)
- **Rich Domain Models**: Business logic encapsulated in models
- **Service Layer**: Orchestration and business workflows
- **Central Router**: Single registration point for all domains
- **Clean Separation**: Clear boundaries between layers

</details>

<details>
<summary><b>Infrastructure</b></summary>

- **Database**: SQLite (lightweight, file-based)
- **Background Tasks**: Celery with Redis for async operations
- **Containerization**: Multi-stage Docker builds
- **Health Monitoring**: Application health checks
- **Configuration**: Environment-based configuration
- **Deployment**: Docker Compose support

</details>

<details>
<summary><b>Testing & Quality</b></summary>

- **Testing**: Comprehensive test suite (unit and integration)
- **Coverage**: Automated coverage reporting
- **Quality Tools**: Black, flake8, mypy, bandit, safety
- **CI/CD**: Automated test runner and pipeline
- **Fixtures**: Test fixtures and mock strategies

</details>

<details>
<summary><b>Documentation</b></summary>

- **API Docs**: OpenAPI 3.0 specification
- **Deployment**: Comprehensive deployment guides
- **Development**: Setup and development guides
- **Monitoring**: Health monitoring documentation

</details>

---

## System Architecture

### Application Structure

```
flask-api-boilerplate/
├── app/                      # Flask application
│   ├── domain/              # Application domain (customize for your use case)
│   │   ├── models.py        # Domain models (Entities + DB Models)
│   │   ├── services.py      # Business logic services
│   │   ├── repositories.py  # Data access repositories
│   │   ├── routes.py        # HTTP endpoints (REST API)
│   │   ├── tasks.py         # Domain background tasks (Celery)
│   │   ├── schemas.py       # Validation schemas (Marshmallow)
│   │   ├── graphql_schema.py # GraphQL API schema
│   │   ├── proto_files/     # gRPC protocol buffers
│   │   ├── exceptions.py    # Domain-specific exceptions
│   │   └── constants.py     # Domain constants
│   ├── shared/              # Shared infrastructure
│   │   ├── database.py      # Database connection
│   │   ├── middleware/      # Cross-cutting concerns
│   │   │   ├── auth.py      # Firebase authentication
│   │   │   ├── cors.py      # CORS configuration
│   │   │   ├── error_handler.py # Centralized error handling
│   │   │   ├── rate_limit.py # Rate limiting
│   │   │   └── security.py  # Security headers
│   │   └── tasks.py         # Shared background tasks
│   ├── celery_app.py        # Celery factory
│   ├── router.py            # Central route registration
│   ├── config.py            # Configuration management
│   └── extensions.py        # Flask extensions (SQLAlchemy)
├── tests/                   # Test suites
│   ├── unit/               # Unit tests
│   └── integration/        # Integration tests
├── docs/                    # Documentation
├── scripts/                 # Deployment scripts
├── .github/workflows/       # CI/CD pipelines
├── celery_worker.py        # Celery worker entry point
├── Dockerfile              # Container configuration
├── docker-compose.yml      # Docker Compose
└── Makefile               # Development commands
```

### Architecture Principles

This project follows a **clean domain-driven architecture**:

#### **`domain/`** - Application Domain
The domain owns its **entire vertical slice**:
- **Business Logic**: Rich domain models with business rules
- **REST API**: HTTP endpoints via Flask blueprints
- **Background Tasks**: Asynchronous operations via Celery
- **GraphQL API**: Flexible query interface
- **gRPC API**: Protocol buffer definitions
- **Validation**: Request/response schemas
- **Error Handling**: Domain-specific exceptions
- **Configuration**: Domain constants

#### **`shared/`** - Shared Infrastructure
Cross-cutting concerns used by all domains:
- **Middleware**: Authentication, CORS, rate limiting, security
- **Background Tasks**: Infrastructure tasks (cleanup, notifications, exports)
- *(Future)* Common utilities, helpers, reusable components

### Database & Queue Architecture

- **Database**: SQLite (lightweight, file-based)
  - **Benefits**: No external dependencies, easy deployment, portable
  - **Note**: Use PostgreSQL in production with Celery
- **Message Queue**: Redis (for Celery background tasks)
  - **Benefits**: Fast, reliable, simple setup

---

## Quick Start

### Get up and running in 5 minutes!

### Prerequisites

- **Python 3.10+**
- **[UV](https://docs.astral.sh/uv/)** *(recommended)* or pip
- **Git**
- **Docker (optional)**

### Step-by-Step Setup

<details>
<summary><b>1. Clone the Repository</b></summary>

```bash
# Clone the repository
git clone <repository-url>
cd flask-api-boilerplate
```

</details>

<details>
<summary><b>2. Set Up Development Environment</b></summary>

```bash
# Install UV (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install dependencies (UV will create .venv automatically)
make install-dev

# This will:
# - Create a virtual environment (.venv)
# - Install all Python dependencies
# - Install development tools
```

</details>

<details>
<summary><b>3. Configure Environment</b></summary>

```bash
# Copy environment template
cp env.example .env

# Edit .env with your settings
nano .env  # or use your preferred editor
```

**Required Environment Variables:**
```bash
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
DATABASE_URL=sqlite:///app.db
```

</details>

<details>
<summary><b>4. Start Development Server</b></summary>

```bash
# Start the development server
make dev

# The API will be available at:
# http://localhost:8080
# Health Check: http://localhost:8080/health
# Status: http://localhost:8080/status
```

</details>

---

## Installation Options

### Choose your preferred installation method

**UV (Recommended)**
```bash
make install-dev
```
- Fast installation with UV (10-100x faster than pip)
- Automatic virtual environment management
- Lockfile support for reproducible builds

**Docker Compose**
```bash
docker-compose up -d
```
- Isolated containerized environment
- Easy cleanup and management
- Production-like setup

**Manual Installation (pip fallback)**
```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt
```
- Full control over installation
- Flexible setup options
- Custom dependency management

### Docker Installation

<details>
<summary><b>Using Docker Compose (Recommended)</b></summary>

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f flask-app

# Stop services
docker-compose down
```

**Services included:**
- Web application (Flask)
- Redis (message broker)
- Celery worker (background tasks)
- Celery beat (scheduled tasks)
- Flower (task monitoring at http://localhost:5555)
- Database (SQLite)

</details>

---

## Testing

### Testing Suite

| **Test Type** | **Command** | **Description** |
|:---|:---|:---|
| **Unit Tests** | `make test-unit` | Fast & isolated tests for models, services, and utilities |
| **Integration Tests** | `make test-integration` | API endpoint and database integration tests |
| **Coverage Report** | `make test-coverage` | Generate coverage metrics and HTML reports |
| **All Tests** | `make test` | Run complete test suite with coverage reporting |

### Coverage Goals

| Component | Target | Current |
|:---|:---|:---|
| **Overall** | 80%+ | |
| **Critical Modules** | 90%+ | |
| **New Code** | 90%+ | |

### Test Categories

- **Unit Tests**: Individual component testing
- **Integration Tests**: API endpoint testing
- **Contract Tests**: Backwards compatibility verification
- **E2E Tests**: End-to-end workflow testing
- **Performance Tests**: Load and stress testing

---

## Code Quality

### Automated Code Quality Tools

| **Tool** | **Command** | **Purpose** |
|:---|:---|:---|
| **Black** | `make format` | Code formatting (88 char line length) |
| **Flake8** | `make lint` | Style guide compliance and error detection |
| **isort** | `make format` | Import organization and sorting |
| **Mypy** | `make lint` | Type checking and static analysis |
| **Pre-commit** | `pre-commit install` | Automated git hooks and quality gates |

---

## Security

### Security Measures

| **Tool** | **Command** | **Purpose** |
|:---|:---|:---|
| **Bandit** | `make security-check` | Security vulnerability scanning and risk assessment |
| **Safety** | `make security-check` | Dependency vulnerability checking and security patches |
| **Authentication** | Built-in | Firebase, API key, and session-based authentication |

### Security Configuration

```bash
# Enable rate limiting
RATE_LIMIT_ENABLED=True
RATE_LIMIT_PER_MINUTE=60

# Configure CORS
CORS_ORIGINS=https://yourdomain.com,https://app.yourdomain.com

# Security headers (automatically applied)
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
```

---

## CI/CD Pipeline

### Automated Deployment Pipeline

### Pipeline Stages

| **Quality Checks** | **Testing** | **Security** | **Deployment** |
|:---|:---|:---|:---|
| *Code Quality* | *Test Suite* | *Security Scanning* | *Production Release* |
| - Black formatting | - Unit tests | - Bandit security scan | - Docker build |
| - Flake8 linting | - Integration tests | - Safety dependency check | - Registry push |
| - Mypy type checking | - Coverage reporting | - Vulnerability assessment | - Cloud deployment |
| - isort import sorting | - Performance tests | - Security best practices | - Health verification |

### Pipeline Triggers

| **Trigger** | **Command** | **Actions** |
|:---|:---|:---|
| **Branch Push** | `git push origin main` | Quality checks, testing, security scans |
| **Pull Request** | Create PR to main | All checks + code review |
| **Tag Release** | `git tag prod/v1.0.0 && git push origin prod/v1.0.0` | Full pipeline, deployment, health verification |

---

## Available Commands

### Development Commands

**Installation**
- `make install` - Install production dependencies
- `make install-dev` - Install development dependencies

**Testing**
- `make test` - Run all tests
- `make test-unit` - Run unit tests
- `make test-integration` - Run integration tests
- `make test-coverage` - Generate coverage report

**Code Quality**
- `make format` - Format code with Black and isort
- `make lint` - Run linting checks
- `make security-check` - Run security scans

**Development**
- `make dev` - Run development server
- `make prod` - Run production server
- `make clean` - Clean temporary files
- `make pre-deploy` - Pre-deployment checks

**Background Tasks (Celery)**
- `make celery-worker` - Run Celery worker
- `make celery-beat` - Run Celery beat scheduler
- `make celery-flower` - Run Flower monitoring dashboard
- `make celery-status` - Check worker status
- `make celery-purge` - Purge all tasks from queues

**Database**
- `make db-init` - Initialize database
- `make db-migrate` - Run migrations

**Docker**
- `make docker-build` - Build Docker image
- `make docker-run` - Run Docker container
- `make docker-stop` - Stop Docker container
- `make docker-logs` - View Docker logs

**Pre-commit**
- `make pre-commit-install` - Install pre-commit hooks
- `make pre-commit-run` - Run pre-commit checks
- `make pre-commit-update` - Update pre-commit hooks

**CI/CD**
- `make ci` - Run CI pipeline locally
- `make create-prod-tag` - Create production release tag

**Utilities**
- `make help` - Show all available commands
- `make validate-requirements` - Validate requirements.txt
- `make docs` - Generate documentation

---

## Deployment

### Production Deployment Guide

### Tag-Based Deployment

**Using Release Script:**
```bash
./scripts/create-prod-release.sh 1.0.0
```

**Or Manually:**
```bash
git tag -a prod/v1.0.0 -m "Release v1.0.0"
git push origin prod/v1.0.0
```

**Version Format:** `prod/vMAJOR.MINOR.PATCH`

**Examples:** `prod/v1.0.0`, `prod/v1.2.3`, `prod/v2.0.0`

### Production Configuration

```bash
# Production environment variables
FLASK_ENV=production
SECRET_KEY=your-production-secret-key
DATABASE_URL=sqlite:///app.db
CORS_ORIGINS=https://yourdomain.com
RATE_LIMIT_ENABLED=True
ENABLE_MONITORING=True
```

---

## Monitoring

### Production Monitoring

| **Endpoint** | **Purpose** | **Returns** |
|:---|:---|:---|
| `GET /health` | System health check | Application health, service status, timestamp |
| `GET /status` | Service information | API version, service name, running status |
| **Logging** | Structured logging | Request logs, error logs, performance metrics |

### Health Check Response

```json
{
  "status": "healthy",
  "service": "flask-api-boilerplate",
  "timestamp": "2024-01-01T00:00:00.000000"
}
```

### Status Response

```json
{
  "message": "Flask API Status: Running!",
  "version": "1.0.0"
}
```

---

## API Documentation

### Interactive API Documentation

| **Endpoint** | **Method** | **Description** |
|:---|:---|:---|
| `/health` | GET | System health check |
| `/status` | GET | Service status and version |
| `/` | GET | Welcome message |
| `/graphql` | POST | GraphQL query interface |

### Main Endpoints

All endpoints are registered through the central router (`app/router.py`):

| **Endpoint** | **Method** | **Description** | **Domain** |
|:---|:---|:---|:---|
| `/api/v1/example` | GET | Example API endpoint | `domain` |
| `/api/v1/restricted` | GET | Authentication test | `domain` |
| `/health` | GET | Health check | `router` |
| `/status` | GET | API status | `router` |
| `/` | GET | Welcome message | `router` |
| `/graphql` | POST | GraphQL endpoint | `schemas` |

**Request Example:**
```bash
# Example domain endpoint (customize for your use case)
GET /api/v1/example?param=value

# Health check
GET /health

# Status
GET /status
```

**Response Example:**
```json
{
  "message": "Success",
  "data": {
    "id": 1,
    "value": "example"
  }
}
```

### API Usage Examples

```bash
# Example API endpoint (customize for your use case)
curl "http://localhost:8080/api/v1/example?param=value"

# Health check
curl http://localhost:8080/health

# Status
curl http://localhost:8080/status

# Welcome message
curl http://localhost:8080/

# Authenticated endpoint (requires Firebase token)
curl -H "Authorization: Bearer <token>" http://localhost:8080/api/v1/restricted
```

### Interacting with the Live System

Once deployed, you can interact with the system through multiple interfaces:

#### REST API
```bash
# Health check
curl https://your-domain.com/health

# API status
curl https://your-domain.com/status

# Example API endpoint
curl "https://your-domain.com/api/v1/example?param=value"
```

#### GraphQL
```bash
# GraphQL query (customize for your schema)
curl -X POST https://your-domain.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ yourQuery { field1 field2 } }"}'
```

---

## Project Structure

### Organized Codebase

```
flask-api-boilerplate/
├── app/                      # Flask application
│   ├── domain/              # Application domain (customize for your use case)
│   │   ├── __init__.py      # Domain exports
│   │   ├── models.py        # Domain models (Entities + DB Models)
│   │   ├── services.py      # Business logic services
│   │   ├── repositories.py  # Data access repositories
│   │   ├── routes.py        # HTTP endpoints (REST API)
│   │   ├── tasks.py         # Domain background tasks (Celery)
│   │   ├── schemas.py       # Validation schemas (Marshmallow)
│   │   ├── graphql_schema.py # GraphQL API schema
│   │   ├── proto_files/     # gRPC protocol buffers
│   │   │   ├── api.proto    # Protocol definition
│   │   │   ├── api_pb2.py   # Generated Python code
│   │   │   └── api_pb2_grpc.py # gRPC stubs
│   │   ├── exceptions.py    # Domain-specific exceptions
│   │   └── constants.py     # Domain constants
│   ├── shared/              # Shared infrastructure
│   │   ├── database.py      # Database connection
│   │   ├── middleware/      # Cross-cutting concerns
│   │   │   ├── __init__.py
│   │   │   ├── auth.py      # Firebase authentication
│   │   │   ├── cors.py      # CORS configuration
│   │   │   ├── error_handler.py # Centralized error handling
│   │   │   ├── rate_limit.py # Rate limiting
│   │   │   └── security.py  # Security headers
│   │   └── tasks.py         # Shared background tasks
│   ├── celery_app.py        # Celery factory
│   ├── router.py            # Central route registration
│   ├── config.py            # Configuration management
│   ├── extensions.py        # Flask extensions (SQLAlchemy, etc.)
│   └── __init__.py         # Application factory
├── tests/                   # Test suites
│   ├── unit/               # Unit tests (models, services, schemas)
│   ├── integration/        # Integration tests (API endpoints)
│   ├── fixtures/           # Test fixtures and data
│   └── conftest.py         # Pytest configuration
├── docs/                    # Documentation
│   ├── Architecture.png    # Architecture diagram
│   ├── BuildPipeline.png   # CI/CD pipeline diagram
│   ├── DDD_CELERY_AUDIT.md # DDD compliance audit
│   └── CELERY_DDD_ARCHITECTURE.md # Celery architecture
├── scripts/                 # Utility scripts
│   ├── create-prod-release.sh    # Production release script
│   └── setup-pre-commit.sh       # Pre-commit setup
├── .github/workflows/       # CI/CD pipelines
│   └── push.yml            # GitHub Actions workflow
├── celery_worker.py        # Celery worker entry point
├── Dockerfile              # Container configuration
├── docker-compose.yml      # Docker Compose setup
├── Makefile               # Development commands
├── requirements.txt        # Python dependencies
├── pyproject.toml         # Python project config
└── README.md              # This file
```

### Clean Domain-Driven Architecture

**Perfect Domain Ownership:**

Each domain owns its **entire vertical slice**:

#### `app/domain/` - Application Domain
- **Business Logic**: `models.py`, `services.py`
- **Data Access**: `repositories.py`
- **API Interfaces**: `routes.py` (REST), `graphql_schema.py` (GraphQL), `proto_files/` (gRPC)
- **Background Tasks**: `tasks.py` (Celery async operations)
- **Validation**: `schemas.py` (Marshmallow)
- **Error Handling**: `exceptions.py`
- **Configuration**: `constants.py`

#### `app/shared/` - Shared Infrastructure
- **Database**: `database.py` (Connection management)
- **Middleware**: Authentication, CORS, rate limiting, security headers
- **Background Tasks**: Infrastructure tasks (cleanup, notifications, exports)
- *(Add shared utilities as needed)*

**Key Benefits:**
- Complete domain ownership (100% vertical slice)
- Zero scattered code across folders
- Clear separation of concerns (sync + async operations)
- Easy to test, maintain, and scale
- Simple to add new domains
- True Domain-Driven Design

---

## Contributing

### How to Contribute

**1. Fork & Clone**
```bash
git clone <your-fork>
cd flask-api-boilerplate
```

**2. Create Branch**
```bash
git checkout -b feature/your-feature
```

**3. Make Changes**
```bash
# Make your changes
make format
make lint
make test
```

**4. Submit PR**
```bash
git push origin feature/your-feature
# Create pull request on GitHub
```

### Code Standards

| **Style** | **Types** | **Testing** | **Documentation** |
|:---|:---|:---|:---|
| - PEP 8 compliance | - Type hints required | - Write tests | - Docstrings |
| - Black formatting | - Mypy compliance | - 80%+ coverage | - README updates |
| - 88 character limit | - Static analysis | - Test documentation | - Code comments |

---

## Troubleshooting

### Common Issues & Solutions

<details>
<summary><b>Pre-commit Hooks Failing</b></summary>

```bash
# Update pre-commit hooks
pre-commit autoupdate

# Run manually to see errors
pre-commit run --all-files

# Skip hooks temporarily
git commit --no-verify -m "message"
```

</details>

<details>
<summary><b>Tests Failing</b></summary>

```bash
# Run with verbose output
pytest -vv --tb=long

# Run specific test
pytest tests/unit/test_models.py::TestResultsModel::test_create_result -v

# Run with coverage
pytest --cov=app --cov-report=html
```

</details>

<details>
<summary><b>Docker Issues</b></summary>

```bash
# Rebuild containers
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Check logs
docker-compose logs -f flask-app

# Clean up
docker-compose down -v
docker system prune -a
```

</details>

<details>
<summary><b>Import Errors</b></summary>

```bash
# Check Python version
python --version  # Should be 3.10+

# Check installed packages
pip list

# Reinstall dependencies
make clean
make install-dev

# Check virtual environment
which python
which pip
```

</details>

<details>
<summary><b>Database Connection Issues</b></summary>

```bash
# Check database configuration
echo $DATABASE_URL

# Verify database service is running
docker-compose ps

# Check SQLite database
ls -la *.db
```

</details>

<details>
<summary><b>Environment Issues</b></summary>

```bash
# Check environment variables
cat .env

# Verify configuration
python3 -c "from app.config import get_config; print(get_config())"

# Check Flask environment
echo $FLASK_ENV
```

</details>

---

## License

### MIT License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
