# API Documentation

## Overview

The API exposes both RESTful endpoints and a GraphQL interface. It exposes an OpenAPI 3.0 specification for the REST API.

## Endpoints

### System Endpoints

These endpoints provide system status and health information.

| Endpoint | Method | Description |
|:---|:---|:---|
| `/health` | `GET` | Health check returning system status. |
| `/status` | `GET` | Service status and version information. |
| `/` | `GET` | Root endpoint returning a welcome message. |

## Interface Strategy

### Blueprint Routing

The application centralizes route registration in `app/router.py`. This module acts as a registry for all domain Blueprints, ensuring a consistent URL structure across the API.

- **Versioning**: Blueprints are namespaced under versioned prefixes (e.g., `/api/v1`) to facilitate API longevity and backward compatibility.
- **Service Isolation**: Each domain Blueprint is responsible for its own routes, schemas, and services, promoting modular development.

### Response Standardization

To provide a consistent developer experience for frontend consumers, the API enforces a standard JSON response format for all success and error scenarios.

- **Unified Surface**: Every response includes a `message` field and a `data` field (for successes). Failure responses use an `error` field.
- **Error Mapping**: The centralized `error_handler.py` catches domain-specific exceptions and maps them to standard HTTP status codes:
    - `400 Bad Request`: Returned for `InvalidInvestmentError` (e.g., negative investment amount).
    - `404 Not Found`: Returned for `SymbolNotFoundError` (e.g., symbol not active on Kraken).
    - `503 Service Unavailable`: Returned for `ExternalServiceError` or `InsufficientPriceDataError` (e.g., Kraken API downtime).
    - `500 Internal Server Error`: Generic catch-all for unhandled exceptions.

## GraphQL Interface

### Schema Implementation

The GraphQL interface is implemented using the `strawberry-graphql` library, with the schema defined in `app/domain/graphql_schema.py`.

- **Type Definitions**: Business entities are mapped to GraphQL types using `@strawberry.type`. For example, `ProcessRequestResult` encapsulates analysis metrics and serialized graph data.
- **Resolver Logic**: The `Query` class contains the `process_request` field, which acts as the resolver. It integrates with the standard `CryptoAnalysisService` to ensure consistent business logic between REST and GraphQL interfaces.
- **Complex Type Handling**: Strawberry utilizes Python's type hinting to manage data conversion. `Decimal` values from the domain layer are serialized as `Float` in the GraphQL response to maintain precision while ensuring frontend compatibility.
- **Error Propagation**: Resolvers implement try-except blocks that catch domain-specific exceptions and translate them into standardized JSON error messages within the GraphQL response.
- **Integration**: The schema is exposed via `GraphQLView` and registered in the application factory (`app/__init__.py`) under the `/graphql` route.

### Interface Endpoints

| Endpoint | Method | Description |
|:---|:---|:---|
| `/graphql` | POST | GraphQL query entry point. |

### Domain Endpoints

All domain-specific endpoints are versioned and registered via the central router.

**Example Structure**:

| Endpoint | Method | Description |
|:---|:---|:---|
| `/api/v1/example` | GET | Example domain resource. |
| `/api/v1/restricted` | GET | Protected resource requiring authentication. |

## Usage Examples

### REST API

**Health Check**:
```bash
curl http://localhost:8080/health
```

**Authenticated Request**:
```bash
curl -H "Authorization: Bearer <token>" http://localhost:8080/api/v1/restricted
```

### GraphQL

**Query**:
```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ yourQuery { field1 field2 } }"}'
```

## Response Formats

API responses follow a standard JSON structure:

```json
{
  "message": "Operation status or message",
  "data": {
    "key": "value"
  }
}
```
