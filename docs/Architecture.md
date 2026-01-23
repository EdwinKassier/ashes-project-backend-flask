# System Architecture

## Overview

The application is built on the Flask micro-framework, utilizing a Domain-Driven Design (DDD) approach to structure the codebase. This architecture emphasizes a clean separation of concerns, scalability, and maintainability.

## Core Concepts

### Route Partitioning and Blueprints

To manage complexity and ensure scalability, the application utilizes Flask's **Blueprint** pattern. Blueprints allow for the partitioning of routes into logical components, enabling the modularization of the application.

Each Blueprint represents a distinct domain or functional area. By assigning a `url_prefix` to a Blueprint, all routes defined within it are automatically namespaced. This prevents route collisions and provides a clear API structure.

For example, a Blueprint registered with the prefix `/api/v1/users` partitions all user-related functionality under that namespace.

## Application Structure

### Configuration Management

The application uses a hierarchical configuration system defined in `app/config.py`.

- **Environment-Based Config**: Settings are loaded from a `.env` file using `python-dotenv`.
- **Config Inheritance**: A `BaseConfig` class defines common settings, while `DevelopmentConfig`, `TestingConfig`, and `ProductionConfig` override specific parameters (e.g., `SQLALCHEMY_DATABASE_URI`).
- **Dynamic Selection**: The `get_config()` utility retrieves the appropriate configuration class based on the `FLASK_ENV` environment variable.

### Entry Point and Factory Pattern

The application entry point is `run.py`, which invokes the `create_app()` factory function defined in `app/__init__.py`. This function manages:

1.  **App Initialization**: Instantiates the `Flask` object.
2.  **Configuration Loading**: Applies the configuration class returned by `get_config()`.
3.  **Extension Initialization**: Invokes `init_extensions()` to set up SQLAlchemy, CORS, and other Flask extensions.
4.  **Middleware Registration**: Registers custom middleware handlers (located in `app/shared/middleware/`).
5.  **Blueprint Registration**: delegates route registration to `app/router.py`.

### Domain Layer Implementation

The architecture enforces a strict separation between business logic and data persistence, following Domain-Driven Design principles.

- **Domain Entities (Logic)**: Defined as Python `dataclasses` in `app/domain/models.py`. These entities (e.g., `Investment`, `PriceData`) encapsulate pure business rules and validation logic. Keeping logic in dataclasses ensures the domain remains independent of the database framework, facilitating unit testing without database dependencies.
- **Persistence Models (Data)**: Defines SQLAlchemy models (e.g., `Results`, `OpeningAverage`) in the same module. These map directly to the database schema.
- **Repositories**: Encapsulate data access logic, translating between domain entities and persistence models.
- **Rationale**: This separation isolates the core domain from infrastructure changes. If the underlying database or ORM is replaced, the business logic remains unaffected.

### Middleware and Cross-Cutting Concerns

Middleware components are located in `app/shared/middleware/` and are registered in the `create_app` factory using specialized Flask hooks.

- **Security Headers**: Standard headers (HSTS, X-Content-Type-Options) are applied via the `@app.after_request` hook, ensuring every response is protected before leaving the server.
- **Logging**: Request auditing is handled via the `@app.before_request` hook to capture incoming request metadata.
- **Authentication**: Firebase integration validates Bearer tokens.
- **Rate Limiting**: Protects endpoints based on IP address or API key.
- **Error Handling**: Centralized error mapping translates exceptions into standard JSON responses using the `@app.errorhandler` hook.

## Asynchronous Processing

### Celery Factory and Flask Integration

The application implements a robust Celery factory pattern in `app/celery_app.py` to ensure seamless integration with the Flask application context.

- **Context Preservation**: The factory overrides `celery.Task` with a custom `ContextTask` class that wraps task execution within `app.app_context()`. This allows background tasks to access Flask extensions (e.g., SQLAlchemy `db` instance) and configuration variables.
- **Task Discovery**: Tasks are automatically discovered from `app.domain.tasks` and `app.shared.tasks` via the `include` parameter in the Celery constructor.
- **Broker and Backend**: Redis is utilized as both the message broker and the result backend, providing high-performance task queuing and result persistence.
- **Configuration Persistence**: The Celery instance inherits configuration from the Flask application, supplemented by specialized task settings (e.g., `task_acks_late`, `task_time_limit`).

## Data Access Layer

### Repository Pattern Implementation

The application employs the Repository pattern to abstract data access logic and decouple the domain layer from specific infrastructure implementations.

- **Kraken Price Repository**: Encapsulates interactions with the Kraken OHLC API. It is responsible for fetching historical data and translating the API's specific JSON structure into domain `PriceData` objects.
- **SQLAlchemy Investment Repository**: Manages persistence for investment records. It maps domain `Investment` entities to SQLAlchemy models and handles database transactions.
- **Dependency Inversion**: Services depend on repository abstractions (interfaces), allowing for easier testing via mock objects and flexibility to switch infrastructure without modifying business logic.

## Service Orchestration

The `CryptoAnalysisService` orchestrates the analysis workflow:
1.  **Validation**: Instantiates a domain `Investment` entity, triggering `__post_init__` validation.
2.  **External Fetch**: Calls `KrakenPriceRepository.get_price_data()` to retrieve historical data.
3.  **Domain Analysis**: Executes profit and growth calculations using methods defined on the domain entities.
4.  **Persistence**: Calls `SqlAlchemyInvestmentRepository.log_query()` to record the operation.
