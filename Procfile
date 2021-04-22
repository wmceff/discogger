web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
worker: QUEUE=* bundle exec rake environment resque:work
