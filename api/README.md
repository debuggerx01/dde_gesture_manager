# ORM Starter Application for Angel3 framework

This is an ORM starter application for [Angel3 framework](https://angel3-framework.web.app) which is a full-stack Web framework in Dart. The default database is `postgresql`. `mysql` support is still in active development.

## Installation & Setup

1. Download and install [Dart](https://dart.dev/get-dart).
2. Install `postgresql` version 9, 10, 11 or 12. **postgresql 13 is not working as the driver do not support SCRAM**
3. Create a new user and database in postgres using `psql` cli. For example:

   ```sql
    postgres=# create database appdb;
    postgres=# create user appuser with encrypted password 'App1970#';
    postgres=# grant all privileges on database appdb to appuser;
   ```

4. Update the `postgres` section in the `config/default.yaml` file with the newly created user and database name.

   ```yaml
    postgres:
        host: localhost
        port: 5432
        database_name: appdb
        username: appuser
        password: App1970#
        useSSL: false
        time_zone: UTC
   ```

5. Run the migration to generate `migrations` and `greetings` tables in the database.

    ```bash
    dart bin/migration.dart
    ```

### Development

1. Run the following command to start Angel3 server in dev mode to *hot-reloaded* on file changes:

    ```bash
    dart --observe bin/dev.dart
    ```

2. Modify the code and watch the changes applied to the application

### Production

1. Run the following command:

    ```bash
    dart bin/prod.dart
    ```

2. Run as docker. Edit and run the provided `Dockerfile` to build the image.

## Resources

Visit the [Developer Guide](https://angel3-docs.dukefirehawk.com/guides) for dozens of guides and resources, including video tutorials, to get up and running as quickly as possible with Angel3.

Examples and complete projects can be found [here](https://angel3-framework.web.app/#/examples).

You can also view the [API Documentation](https://pub.dev/documentation/angel3_framework/latest/).
