# Stock Trading Platform API

A Ruby on Rails API-based application that enables business owners to list their businesses with available shares and allows buyers to purchase these shares through a buy order system.

## System Requirements

- Ruby 3.4
- Rails 8.0
- SQLite

## API Documentation

### Authentication

The API uses HTTP Basic Authentication. Include credentials in the request header or use OpenAPI UI.

### API Testing with OpenAPI

The API can be tested using the OpenAPI specification located at `docs/v1/openapi.yml`.

To test using Swagger UI:

1. Setup the database:

```bash
rails db:setup
```

1. Start the Rails server with credentials for Basic HTTP Auth via environment variables:

```bash
USER=user PASSWORD=pass rails s -p 3000
```

1. Visit `http://localhost:3000/api_docs/index.html` in your browser.

## Core Features

- Business listing with available shares management
- Buy order placement and management
- Order approval/rejection system
- Historical purchase tracking
- HTTP Basic Authentication

## Architecture Overview

- `User`: Handles authentication and user roles (buyer/owner)
- `Business`: Represents listed businesses with share information
- `Order`: Manages buy orders and their statuses
- `Transaction`: Records completed share purchases

## Future Considerations

### Multi-Currency Support
- Implementation would require:
    - Currency field for businesses
    - Wallet system for buyers
    - Exchange rate service integration
    - Transaction rollback mechanism for rejected purchases

### High-Demand Sale Management
- Potential solutions:
    - Queue system (e.g., Redis, RabbitMQ)
    - Rate limiting
    - Database sharding
    - Caching layer
    - Share purchase limits per buyer

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.
