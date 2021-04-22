# discogger

uncover gems in discogs.

pick your search terms (eg. Jamaica, 1962), and it'll populate a list of gems over time.

currently it will compile a list of records based on thresholds for rating, number
of ratings, and the suggested mint price in the marketplace.

## instructions

- set up your rails dev environment, create db & migrate
- copy .env.example to .env and set up your .env with discogs api creds (if you want the pricing data, you need to set up your seller profile)
- run the server `bundle exec rails s` visit the homepage, and authorize with discogs
- run resque `QUEUE=* bundle exec rake environment resque:work`
- create a query. write the query string in the [search API format](https://www.discogs.com/developers/#page:database,header:database-search), eg.
  `/database/search?per_page=50&style=House&year=1990`
- click 'run query' to start the job working in the resque worker
- refresh the query page occasionallly to see new results as they come in
- tweak configuration in config/application.rb
