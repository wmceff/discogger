require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Dotenv::Railtie.load

module Discogger
  class Application < Rails::Application
    config.active_job.queue_adapter = :resque

    config.x.thresholds = {
      rating: 3.5, # minimum rating to consider
      num_ratings: 5, # min number of raters to consider
      num_wants: 20,
      median_price: 15.00 
    }
  end
end
