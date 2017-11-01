# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Actioncable is used to update the palette realtime.

* Install latest ruby and rails.

* Use Puma as websockets are involved.

* Install PostgreSQL

* Create database user and database as mentioned in database.yml file

* Run migrations to create tables

* Run task to create sample customers and drivers:
  1. rake taxi_task:create_drivers
  2. rake taxi_task:create_customers

* Have used updated_at value for picked_at. Can create separate column if needed.
