# Personal feed aggregator

This is a feed aggregator, that fetches, caches, and renders the RSS feeds
of a few different blogs.

It depends on memcached as a store, but will continue working (a little slower)
if memcached is not available.

## Run the application

You'll first need ruby and bundler. Run `bundle install` to install all required
gems.

Start memcached with Docker:

```sh
docker run --name memcached -p 11211:11211 -d memcached memcached -m 164
```

Start the application:

```sh
# Add  `-f Procfile.dev` in development
foreman start
```

Visit `/following` to see the RSS feeds.

## Add feeds

Have a look in `Feeds`, and add to the list there.

## Keeping the feed fresh

**Note:** This part is only relevant if you're running memcached.

To make the feed load faster, you can run the application in 'read-ahead' mode.
Do this using `whenever` to create a cron job that'll keep the cache fresh:

```sh
whenever --update-crontab
```

You may need to install `whenever` e.g. with `sudo apt install ruby-whenever`.


## Deployment

Capistrano
