# TMTG Readme

## Getting Started

These instructions will get your copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Before you begin, ensure you have the following installed:
- Ruby 3.3.0
- Rails
- Redis
- PostgreSQL

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/dmmoody/tmtg.git
cd tmtg
```

2. **Install dependencies**

```bash
bundle install
```

3. **Setup PostgreSQL**

Ensure PostgreSQL is running on your system. Create the database, migrate, and seed it:

```bash
rails db:create db:migrate
```

4. **Redis**

Ensure Redis is running on your system as it is required for caching and background jobs.

5. **Environment Variables**

Create a `.env` file in the root directory of the project and add the following variables:

```
EMPLOYEE_SERVICE_BASE_URL=
EMPLOYEE_SERVICE_GRANT_TYPE=
EMPLOYEE_SERVICE_CLIENT_ID=
EMPLOYEE_SERVICE_CLIENT_SECRET=
EMPLOYEE_SERVICE_PASSWORD=
EMPLOYEE_SERVICE_USERNAME=
```

Fill in the values according to your specific configuration.

### Running the Application

1. **Start the application with Foreman**

```bash
foreman start
```

Foreman will run your Rails server along with any other processes defined in your `Procfile`.

2. **Access the Application**

Visit `http://localhost:3000` in your web browser to access the application.

### Running Tests

1. **Ensure Sidekiq is running for background jobs**

For tests that require background jobs, make sure Sidekiq is running. You can start Sidekiq separately by running:

```bash
bundle exec sidekiq
```

2. **Run the test suite**

```bash
rails rspec
```

---

## Additional Notes

- Ensure all environment variables in the `.env` file are correctly set for both development and test environments.
- Make sure that Redis and PostgreSQL services are running before starting the Rails server or running tests.
- Check the `Procfile` for specific services started by Foreman.

---

# Notable Aspects of the Application

## Items Not Implemented

The following items are not implemented in the application due to time constraints:

- Error handling and logging
- API error handling
- Updating employee records in the database if they have changed in the external API

## Service Objects

The `app/services` directory contains service objects that encapsulate the business logic of the application. Each service object is responsible for a specific task, such as fetching data from an external API, parsing a response, or handling token authorization.

### Base Service

The `Base` service object is a parent class for all other service objects. It contains common methods that are used by multiple service objects, such as token handling and response caching.

### Employee Service

The `Employee` service object is responsible for fetching employee data from the external API. It uses the `Base` service object to handle token authorization and response caching.

## Authorization Token Management

The token handling process is encapsulated in the `TokenHandler` module under the services `Base` namespace. Here's a summary of how it works:

1. The `bearer_token` method is the entry point for token handling. It first attempts to retrieve a token from a Redis cache using the `bearer_token_cache_key` method to generate the key. If a token is found, it is parsed and returned. If not, a new token is fetched and set.
2. The `parse_token` method is used to parse the cached token. It uses `JSON.parse` to convert the JSON string into a Ruby hash with symbolized keys.
3. If no cached token is found, the `set_access_data` method is called. This method fetches new access data, calculates the token's expiry time in seconds, and if the token is not expired, it sets the token in the cache using the `set_token_in_cache` method. It then returns the access token.
4. The `set_token_in_cache` method sets the token in the Redis cache with an expiry time.
5. The `bearer_token_cache_key` method generates a cache key for storing and retrieving the bearer token from the Redis cache.
6. The `headers` method merges the bearer token into the headers of the request.

The actual fetching of the access data is not implemented in this module.

## API Response Caching

The `ResponseCache` module in the `app/services/base/response_cache.rb` file is designed to cache HTTP responses. Here's a brief summary of how it works:

1. The `cache_response` method is the entry point. It takes an HTTP response as an argument, stores it in an instance variable, and retrieves the old response digest from Redis using the URL digest as the key.
2. The `url_digest` method generates a SHA256 digest of the response URL.
3. The `response_digest` method generates a SHA256 digest of the serialized response body.
4. The `composite_key` method combines the URL digest and the response digest into a single string, separated by a colon.
5. The `serialized_response_body` method serializes the response body into a JSON string.
6. The `cache_in_redis` method attempts to store the serialized response body in Redis, using the composite key. If the key does not already exist in Redis (`setnx` returns true), it also stores the response digest in Redis, using the URL digest as the key.
7. The `delete_old_response` method deletes the old response from Redis, using the old composite key (which includes the old response digest).

In summary, this module caches the response body of each unique URL and response body combination. It also keeps track of the latest response body for each URL, and deletes the old response body when a new one is received.

## Sidekiq Background Jobs

The `app/jobs` directory contains background jobs that are processed by Sidekiq. These jobs are used to perform tasks asynchronously, such as storing data from an external API and updating the cache.

### LoadEmployeeDataJob

The `LoadEmployeeDataJob` class is responsible for taking the cached response from the external API and creating a new job to store the individual employee data in the database.

### StoreEmployeeDataJob

The `StoreEmployeeDataJob` class is responsible for storing the individual employee data in the database. Each job processes a single employee record. If the employee already exists in the database, it updates the existing record. If the employee does not exist, it creates a new record.