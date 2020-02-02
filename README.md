# discogger

uncover gems in discogs.

pick your searches, and it'll populate a list of gems over time.

their api isn't meant for this, so we have to go through matching releases one
at a time to get rating and price information.

currently it will make a list of records based on thresholds for rating, number
of ratings, and the median price in the marketplace.

## instructions

- set up your rails dev environment, create db & migrate
- run the server `bundle exec rails s` visit the homepage, and authorize with
  oauth via discogs
- run resque `QUEUE=* bundle exec rake environment resque:work`
- click 'new query'. write the query string in the API format, eg.
  `/database/search?per_page=50&style=House&year=1990`
- click 'run query' to start the job working in the resque worker
- refresh the query page occasionallly to see new results as they come in
- tweak configuration in config/application.rb
