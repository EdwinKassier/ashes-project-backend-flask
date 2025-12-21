.PHONY: help install install-dev test test-unit test-integration test-e2e lint format clean docker-build docker-run docker-stop security-check uv-lock uv-upgrade

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Installation (using UV - https://docs.astral.sh/uv/)
install: ## Install production dependencies using UV
	uv sync --no-dev

install-dev: ## Install development dependencies using UV
	uv sync
	uv pip install -e ".[dev]"

# Testing
test: ## Run all tests
	uv run pytest tests/ -v

test-unit: ## Run unit tests only
	uv run pytest tests/unit/ -v -m "not slow"

test-integration: ## Run integration tests
	uv run pytest tests/integration/ -v

test-e2e: ## Run end-to-end tests
	uv run pytest tests/e2e/ -v

test-coverage: ## Run tests with coverage report
	uv run pytest tests/ -v --cov=app --cov-report=html --cov-report=term-missing

# Code Quality
lint: ## Run linting checks
	uv run flake8 app/ tests/ --max-line-length=88 --extend-ignore=E203,W503,E501,F401,F841,F403,F405,E711,E712
	uv run mypy app/ --ignore-missing-imports || true
	uv run bandit -r app/ -f json -o bandit-report.json || true

format: ## Format code with black and isort
	uv run black app/ tests/ --line-length=88
	uv run isort app/ tests/ --profile=black --line-length=88

format-check: ## Check code formatting without making changes
	uv run black --check app/ tests/ --line-length=88
	uv run isort --check-only app/ tests/ --profile=black --line-length=88

# Pre-commit hooks
pre-commit-install: ## Install pre-commit hooks
	uv run pre-commit install

pre-commit-run: ## Run pre-commit hooks on all files
	uv run pre-commit run --all-files

pre-commit-update: ## Update pre-commit hooks to latest versions
	uv run pre-commit autoupdate

validate-requirements: ## Validate requirements.txt for conflicts
	./scripts/validate-requirements.py

# Security
security-check: ## Run security checks
	uv run bandit -r app/ -f json -o bandit-report.json
	uv run safety check --json --output safety-report.json
	@echo "Security reports generated: bandit-report.json, safety-report.json"

# Cleanup
clean: ## Clean up temporary files
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf .pytest_cache/
	rm -rf htmlcov/
	rm -rf .coverage
	rm -rf dist/
	rm -rf build/
	rm -f bandit-report.json
	rm -f safety-report.json

# Docker
docker-build: ## Build Docker image
	docker build -t dwml-backend:latest .

docker-run: ## Run application with Docker Compose
	docker-compose up -d

docker-stop: ## Stop Docker containers
	docker-compose down

docker-logs: ## View Docker logs
	docker-compose logs -f

# Development
dev: ## Run development server
	FLASK_ENV=development uv run python run.py

prod: ## Run production server with gunicorn
	uv run gunicorn --bind 0.0.0.0:8080 --workers 4 --timeout 120 run:app

# Database
db-migrate: ## Run database migrations
	uv run flask db upgrade

db-init: ## Initialize database
	uv run flask db init
	uv run flask db migrate -m "Initial migration"
	uv run flask db upgrade

# API Documentation
docs: ## Generate API documentation
	@echo "API documentation available at: http://localhost:8080/docs"

# Full CI Pipeline (matches GitHub Actions)
ci: clean install-dev lint test security-check ## Run full CI pipeline
	@echo "CI pipeline completed successfully"

# Pre-deployment checks (run before creating prod-* tag)
pre-deploy: clean install-dev lint test security-check ## Run all checks before production deployment
	@echo "All pre-deployment checks passed! Ready to create prod-* tag."

# Production tag creation helper
create-prod-tag: ## Create production tag (usage: make create-prod-tag VERSION=1.0.0)
	@if [ -z "$(VERSION)" ]; then echo "Usage: make create-prod-tag VERSION=1.0.0"; exit 1; fi
	@echo "Creating production tag: prod-$(VERSION)"
	@echo "Make sure all tests pass before creating the tag!"
	@echo "Run 'make pre-deploy' first to verify everything is ready."
	@echo "Then run: git tag prod-$(VERSION) && git push origin prod-$(VERSION)"

# Celery
celery-worker: ## Run Celery worker locally
	uv run celery -A celery_worker.celery worker --loglevel=info --concurrency=4

celery-beat: ## Run Celery beat scheduler locally
	uv run celery -A celery_worker.celery beat --loglevel=info

celery-flower: ## Run Flower monitoring dashboard
	uv run celery -A celery_worker.celery flower --port=5555

celery-purge: ## Purge all tasks from queues
	uv run celery -A celery_worker.celery purge -f

celery-status: ## Check Celery worker status
	uv run celery -A celery_worker.celery inspect active

celery-stats: ## Show Celery worker statistics
	uv run celery -A celery_worker.celery inspect stats

# UV Management
uv-lock: ## Generate/update uv.lock file
	uv lock

uv-upgrade: ## Upgrade all dependencies
	uv lock --upgrade
	uv sync
