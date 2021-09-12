# dde_gesture_manager

## Running the Application Locally

Run `conduit serve` from this directory to run the application. For running within an IDE, run `bin/main.dart`. By default, a configuration file named `config.yaml` will be used.

You must have a `config.yaml` file that has correct database connection info, which should point to a local database. To configure a database to match your application's schema, run the following commands:

```
# if this is a project, run db generate first
conduit db generate
conduit db upgrade --connect postgres://user:password@localhost:5432/app_name
```

To generate a SwaggerUI client, run `conduit document client`.

## Running Application Tests

Tests are run with a local PostgreSQL database named `conduit_test_db`. If this database does not exist, create it from your SQL prompt:

CREATE DATABASE conduit_test_db;
CREATE USER conduit_test_user WITH createdb;
ALTER USER conduit_test_user WITH password 'conduit!';
GRANT all ON DATABASE conduit_test_db TO conduit_test_user;


To run all tests for this application, run the following in this directory:

```
pub run test
```

The default configuration file used when testing is `config.src.yaml`. This file should be checked into version control. It also the template for configuration files used in deployment.

## Deploying an Application

See the documentation for [Deployment](https://conduit.io/docs/deploy/).