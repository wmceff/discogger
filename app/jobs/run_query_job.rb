class RunQueryJob < ActiveJob::Base
  queue_as :default

  def perform(query_id, oauth_token, oauth_token_secret)
    puts 'performing job!'
    @query = Query.find(query_id)
    consumer = OAuth::Consumer.new("YZoEeqSZnAghnSYoicnS", "wexOTYuQeVPqbxMGtBRMMMhakBIUIzDt", :site => "http://api.discogs.com")
    @access_token = OAuth::AccessToken.new(consumer, oauth_token, oauth_token_secret)

    fetch_page

    loop do
      fetch_page
      break if @query.completed_page >= @query.total_pages 
    end
  end

  def fetch_page
    @search = @access_token.get(@query.query_url)
    @search = JSON.parse(@search.body)

    @records = []
    @search["results"].each do |result|
      if (result["community"]["want"] > 50) #all we get is the number of wants in this index
        @records << result
      end
    end

    @records.each do |record|
      sleep(1) #respect their ratelimit
      puts "looking at a record"
      record = @access_token.get('/releases/'+record["id"].to_s)
      record = JSON.parse(record.body)
      if (record && record["community"] &&
          record["community"]["rating"]["average"].to_f > Rails.configuration.x.thresholds[:rating] &&
          record["community"]["rating"]["count"].to_f > Rails.configuration.x.thresholds[:num_ratings])
        puts 'this is one that we want'
        puts record["uri"]
        # grab its median sale
        require 'open-uri'
        page = Nokogiri::HTML(open(record["uri"], 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'))

        if page.css('.statistics .last li')
          median_price = page.css('.statistics .last li')[2].text[/\d+(\.\d{1,2})?/].to_f
          high_price = page.css('.statistics .last li')[3].text[/\d+(\.\d{1,2})?/].to_f
        end

        if median_price < Rails.configuration.x.thresholds[:median_price]
          puts "median price not high enough, skpping"
        else
          puts "adding "+record["title"]

          Record.create(
            rating: record["community"]["rating"]["average"],
            count: record["community"]["rating"]["count"],
            want: record["community"]["want"],
            title: record["title"],
            uri: record["uri"],
            median_price: median_price,
            high_price: high_price,
            discogs_id: record["id"],
            query_id: @query.id
          )
        end
      end
    end

    @query.total_pages = @search["pagination"]["pages"]
    @query.completed_page = @search["pagination"]["page"]
    @query.save
  end
end
