# Security

## Security Measures

The application implements a multi-layered security strategy involving static analysis, dependency scanning, and runtime protection.

### Static Security Analysis

The codebase adheres to security best practices through automated static analysis:
- **Bandit**: Scans the Python source code for common security issues (e.g., insecure use of subprocess, hardcoded passwords).
- **Safety**: Validates the `requirements.txt` against known vulnerability databases for third-party libraries.

## Security Middleware Implementation

The application implements a custom `SecurityMiddleware` class in `app/shared/middleware/security.py` that provides cross-cutting security features.

- **Dynamic Header Injection**: The `add_security_headers` method is registered as an `@app.after_request` hook. it dynamically injects essential security headers (`X-Content-Type-Options`, `X-Frame-Options`, `X-XSS-Protection`) only if they are not already set, ensuring compatibility with other extensions.
- **Input Sanitization**: The middleware provides `validate_input` static utilities that normalize and validate incoming parameters. It ensures cryptocurrency symbols are stripped and uppercase, and investment amounts are converted to positive integers before they reach the service layer. This prevents malformed data and potential injection vectors at the entry point.
- **Security Monitoring**: A request logging mechanism is integrated into the middleware, capturing HTTP methods, paths, and user-agent strings for security audits without impacting request latency.

### Security Configuration

Security settings are managed via environment variables and middleware configuration.

#### Rate Limiting

Rate limiting is implemented to protect against abuse and denial-of-service attacks.

```bash
RATE_LIMIT_ENABLED=True
RATE_LIMIT_PER_MINUTE=60
```

#### CORS Policy

Cross-Origin Resource Sharing (CORS) is configured to restrict browser-based access to authorized domains.

```bash
CORS_ORIGINS=https://yourdomain.com,https://app.yourdomain.com
```

#### Security Headers

The application automatically applies standard security headers to all responses:

- `X-Content-Type-Options: nosniff`: Prevents MIME-type sniffing.
- `X-Frame-Options: DENY`: Prevents clickjacking by disabling iframe embedding.
- `X-XSS-Protection: 1; mode=block`: Enables browser XSS filtering.

### Authentication and Session Security

Authentication is handled via integration with Firebase Auth. Requests to protected endpoints must include a valid Bearer token.

- **Session Signing**: The `SECRET_KEY` environment variable is used to cryptographically sign session cookies and other security-sensitive tokens. This prevents client-side tampering and ensures the integrity of the application state.
- **CSRF Protection**: Standard CSRF protection is enabled for state-changing requests, utilizing the signed session to validate request authenticity.
