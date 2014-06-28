all-spark
=========

A Ruby/Sinatra application to provide a REST-ful web service front-end to the daily Parsha

Usage
=====

Upon cloning, create a database named 'all-spark' running on a mysql instance on port 3306. For more information on this, please see the wiki.

Next, run `migrate config/all-spark-local.json create`. This will create the necessary schema in the database.

To run the app, simply use `run` with no parameters. Similarly, shut it down with `stop`.
