# Testing and Quality Assurance

## Testing Suite

The project maintains a comprehensive test suite covering unit, integration, and performance testing. The test runner is configured via `Makefile` commands for consistency across development and CI environments.

### Test Commands

| Command | Description | Target |
|:---|:---|:---|
| `make test-unit` | Executes isolated unit tests | `tests/unit/` |
| `make test-integration` | Executes API and database integration tests | `tests/integration/` |
| `make test-coverage` | Generates coverage metrics and HTML reports | All Tests |
| `make test` | Runs the complete test suite with coverage | All Tests |

### Coverage Requirements

The project enforces strict code coverage thresholds to ensure maintainability and reliability.

- **Overall Coverage**: Minimum 80%
- **Critical Modules**: Minimum 90%
- **New Code**: Minimum 90%

## Test Infrastructure

The testing environment is orchestrated using `pytest` and specialized fixtures to ensure reproducible and isolated test runs.

### Test Configuration (`conftest.py`)

The `tests/conftest.py` file centralizes shared fixtures used across the test suite:

- **Application Factory**: The `app` fixture initializes a Flask instance in `testing` mode, utilizing an in-memory SQLite database to ensure high performance and isolation.
- **Test Client**: The `client` fixture provides a standard interface for making HTTP requests to the application without starting a live server.
- **Fixture Loading and Data-Driven Testing**: Helper fixtures (e.g., `sample_crypto_data`, `test_fixtures`) automatically load localized JSON data from the `tests/fixtures/` directory. This enables data-driven testing, where multiple scenarios can be validated using the same test logic but different input datasets.

### Mock Strategies and Fixture Mechanics

To maintain test isolation and speed, external dependencies (such as third-party APIs or long-running background tasks) are abstracted using `unittest.mock`.

- **Service Mocking**: Complex business logic services are replaced with `Mock` objects in integration tests that focus solely on endpoint routing and response formatting.
- **External API Simulation**: Network-dependent collectors (e.g., `mock_data_collector`, `mock_graph_creator`) are mocked to return deterministic data. This prevents test failures caused by external service downtime and ensures that the system's reaction to various API response formats is thoroughly validated.

## Code Quality Standards

Automated tools are employed to enforce code style, static analysis, and type safety.

### Quality Tools

| Tool | Command | Purpose | Configuration |
|:---|:---|:---|:---|
| **Black** | `make format` | Code formatting | Line length: 88 characters |
| **Flake8** | `make lint` | Style compliance | PEP 8 standards |
| **isort** | `make format` | Import sorting | Profile: black |
| **Mypy** | `make lint` | Static type checking | Strict mode enabled |
| **Pre-commit** | `pre-commit install` | Git hook automation | Runs all checks on commit |

### Pre-commit Hooks

Pre-commit hooks are configured to automatically run quality checks before code is committed. This prevents non-compliant code from entering the repository.
