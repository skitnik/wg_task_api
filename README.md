## API Endpoints

### Authentication

#### Login
POST /auth/login
Logs in a user and returns an authentication token.

Parameters:
- email (string, required) - User's email address.
- password (string, required) - User's password.

Responses:
- 200 OK on success
  {
    "token": "<generated_token>"
  }
- 401 Unauthorized if credentials are invalid
  {
    "error": "Invalid email or password"
  }

---

#### Signup
POST /auth/signup
Creates a new user account with admin role and returns an authentication token.

Parameters:
- email (string, required) - User's email address.
- password (string, required) - User's password.
- password_confirmation (string, required) - Password confirmation.

Responses:
- 201 Created on success
  {
    "token": "<generated_token>"
  }
- 422 Unprocessable Entity if unable to create user
  {
    "errors": ["Email has already been taken"]
  }

---
### Authorization
For all other endpoints, an Authorization token must be included in the request headers.

### Brands

#### Create Brand
POST /brands
Creates a new brand.

Parameters:
- brand: {
    - name (string, required) - Name of the brand.
    - description (string, optional) - Description of the brand.
    - state (string, optional) - State of the brand.
  }

Responses:
- 201 Created on success
  {
    "id": 1,
    "name": "Example Brand",
    "description": "Example description",
    "state": "active"
  }
- 422 Unprocessable Entity if unable to create brand
  {
    "name": ["can't be blank"]
  }


---

#### Update Brand
PATCH/PUT /brands/:id
Updates an existing brand.

Parameters:
- brand: {
    - name (string, optional) - Updated name of the brand.
    - description (string, optional) - Updated description of the brand.
    - state (string, optional) - Updated state of the brand.
  }

Responses:
- 200 OK on success
  {
    "id": 1,
    "name": "Updated Brand Name",
    "description": "Updated description",
    "state": "active"
  }
- 422 Unprocessable Entity if unable to update brand
  {
    "name": ["can't be blank"]
  }
- 404 Not found if unable to find brand
  {
    "error": "Record not found"]
  }

#### Change Brand State
PATCH /brands/:id/change_state
Changes the state of an existing brand.

Parameters:
- brand: {
    - state (string, required) - Updated state of the brand.
  }

Responses:
- 200 OK on success
  {
    "id": 1,
    "name": "Updated Brand Name",
    "description": "Updated description",
    "state": "inactive"
  }
- 422 Unprocessable Entity if unable to change brand state
  {
    "state": ["must be 'active' or 'inactive'"]
  }
- 404 Not found if unable to find brand
  {
    "error": "Record not found"]
  }

### Products

#### Create Product
POST /products
Creates a new product.

Parameters:
- product: {
    - name (string, required) - Name of the product.
    - description (string, optional) - Description of the product.
    - price (decimal, required) - Price of the product.
    - state (string, optional) - State of the product (e.g., active, inactive).
  }

Responses:
- 201 Created on success
  {
    "id": 1,
    "name": "Example Product",
    "description": "Example description",
    "price": 99.99,
    "state": "active",
    "brand_id": 1
  }
- 422 Unprocessable Entity if unable to create product
  {
    "name": ["can't be blank"]
  }

---

#### Update Product
PATCH/PUT /products/:id
Updates an existing product.

Parameters:
- product: {
    - name (string, optional) - Updated name of the product.
    - description (string, optional) - Updated description of the product.
    - price (decimal, optional) - Updated price of the product.
    - state (string, optional) - Updated state of the product.
    - brand_id (integer, optional) - Updated ID of the brand associated with the product.
  }

Responses:
- 200 OK on success
  {
    "id": 1,
    "name": "Updated Product Name",
    "description": "Updated description",
    "price": 109.99,
    "state": "inactive",
    "brand_id": 2
  }
- 422 Unprocessable Entity if unable to update product
  {
    "price": ["must be greater than or equal to 0"]
  }
- 404 Not found if unable to find product
  {
    "error": "Record not found"]
  }

---

#### Delete Product
DELETE /products/:id
Deletes an existing product.

Responses:
- 204 No Content on success
- 422 Unprocessable Entity if unable to delete product
  {
    "error": "Failed to delete the record"
  }
- 404 Not found if unable to find product
  {
    "error": "Record not found"]
  }

---

#### Change Product State
PATCH /products/:id/change_state
Changes the state of an existing product.

Parameters:
- product: {
    - state (string, required) - Updated state of the product.
  }

Responses:
- 200 OK on success
  {
    "id": 1,
    "name": "Updated Product Name",
    "description": "Updated description",
    "price": 109.99,
    "state": "inactive",
    "brand_id": 2
  }
- 422 Unprocessable Entity if unable to change product state
  {
    "state": ["must be 'active' or 'inactive'"]
  }
- 404 Not found if unable to find product
  {
    "error": "Record not found"]
  }

---

#### Assign Products to Client
POST /products/assign_to_client
Assigns multiple products to a client.

Parameters:
- products: {
    - user_id (integer, required) - ID of the client to assign products to.
    - product_ids (array of integers, required) - IDs of products to assign.
  }

Responses:
- 201 Created on success
  {
    "message": 'Products assigned.',
    "unassigned_products": [{"base":["Product 2 already assigned"]}}]
  }

### Clients

#### Create Client
POST /clients
Creates a new client.

Parameters:
- client: {
    - email (string, required) - Email address of the client.
    - password (string, required) - Password for the client.
    - password_confirmation (string, required) - Password confirmation.
    - payout_rate (decimal, optional) - Payout rate for the client.
  }

Responses:
- 201 Created on success
  {
    "id": 1,
    "email": "client@example.com",
    "role": "client",
    "payout_rate": 0.0
  }
- 422 Unprocessable Entity if unable to create client
  {
    "errors": ["Email has already been taken"]
  }

### Catalogs

#### List Products in Catalog
GET /catalogs
Retrieves products in the catalog for a specific client.

Parameters:
- catalog: {
    - brand_id (integer, optional) - Filters products by brand ID.
    - product_name (string, optional) - Filters products by name.
    - page (integer, optional) - Specifies the page number for paginated results.
  }

Responses:
- 200 OK on success
  [
    {
      "id": 1,
      "name": "Product A",
      "description": "Description of Product A",
      "price": 99.99,
      "state": "active",
      "brand_id": 1
    },
    {
      "id": 2,
      "name": "Product B",
      "description": "Description of Product B",
      "price": 149.99,
      "state": "active",
      "brand_id": 2
    },
    ...
  ]
- 401 Unauthorized if client authorization fails

Notes:
- The `brand_id` parameter filters products by a specific brand.
- The `product_name` parameter filters products by name using a partial match.
- Pagination is applied with 20 products per page by default.

### Cards

#### Create Card
POST /cards
Creates a new card for the client.

Parameters:
- card: {
    - product_id (integer, required) - ID of the product associated with the card.
  }

Responses:
- 201 Created on success
  {
    "id": 1,
    "user_id": 1,
    "product_id": 123,
    "status": "active",
    "purchase_details": "Product: Example Product, Price: 99.99, Brand: Example Brand"
  }
- 422 Unprocessable Entity if unable to create card
  {
    "product_id": ["must exist"]
  }

---

#### Cancel Card
PATCH /cards/:card_id/cancel
Cancels an existing card.

Responses:
- 200 OK on success
  {
    "id": 1,
    "user_id": 1,
    "product_id": 123,
    "status": "canceled",
    "purchase_details": "Product: Example Product, Price: 99.99, Brand: Example Brand"
  }
- 422 Unprocessable Entity if unable to cancel card
  {
    "error": "Failed to cancel the card"
  }
- 404 Not found if unable to find card or card.state != requested
  {
    "error": "Record not found"]
  }

### Reports

#### Generate Brand Report
GET /reports/brand_report
Generates a report for a specific brand.

Parameters:
- report: {
    - brand_id (integer, required) - ID of the brand for which the report is generated.
  }

Responses:
- 200 OK on success
  {
    "brand": {
      "id": 1,
      "name": "Example Brand"
    },
    "products": [
      {
        "id": 1,
        "name": "Product A",
        "description": "Description of Product A",
        "price": 99.99,
        "state": "active"
      },
      {
        "id": 2,
        "name": "Product B",
        "description": "Description of Product B",
        "price": 149.99,
        "state": "active"
      },
      ...
    ]
  }
- 401 Unauthorized if admin authorization fails
- 404 Not found if unable to find brand
  {
    "error": "Record not found"]
  }

---

#### Generate Client Report
GET /reports/client_report
Generates a report for a specific client.

Parameters:
- report: {
    - client_id (integer, required) - ID of the client for which the report is generated.
  }

Responses:
- 200 OK on success
  {
    "client": {
      "email": "client@example.com",
      "role": "client",
      "payout_rate": 0.0
    },
    "products": [
      {
        "id": 1,
        "name": "Product A",
        "description": "Description of Product A",
        "price": 99.99,
        "state": "active"
      },
      {
        "id": 2,
        "name": "Product B",
        "description": "Description of Product B",
        "price": 149.99,
        "state": "active"
      },
      ...
    ]
  }
- 401 Unauthorized if admin authorization fails
- 404 Not found if unable to find client
  {
    "error": "Record not found"]
  }

---

#### Generate Client Transactions Report
GET /reports/client_transactions_report
Generates a report of transactions for the authenticated client.

Responses:
- 200 OK on success
  {
    "activated_transactions": [
      {
        "id": 1,
        "details": "Product: Example Product, Price: 99.99, Brand: Example Brand",
        "created_at": "2024-06-22T12:00:00Z"
      },
      {
        "id": 2,
        "details": "Product: Another Product, Price: 149.99, Brand: Another Brand",
        "created_at": "2024-06-22T13:00:00Z"
      },
      ...
    ],
    "canceled_transactions": [
      {
        "id": 3,
        "details": "Product: Third Product, Price: 199.99, Brand: Third Brand",
        "created_at": "2024-06-22T14:00:00Z"
      },
      ...
    ]
  }
- 401 Unauthorized if client authorization fails
- 404 Not found if unable to find client
  {
    "error": "Record not found"]
  }

Notes:
- `activated_transactions` are transactions where cards are active.
- `canceled_transactions` are transactions where cards are canceled.

