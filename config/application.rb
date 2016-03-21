require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Discogger
  class Application < Rails::Application
    config.active_job.queue_adapter = :resque

    
    config.x.thresholds = {
      rating: 4, # minimum rating to consider
      num_ratings: 5, # min number of raters to consider
      median_price: 20.00 
    }
  end
end
