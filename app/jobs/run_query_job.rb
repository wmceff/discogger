class RunQueryJob < ActiveJob::Base
  queue_as :default

  def perform(query_id, oauth_token, oauth_token_secret)
    puts 'performing job!'
    @query = Query.find(query_id)
    consumer = OAuth::Consumer.new("YZoEeqSZnAghnSYoicnS",
                                   "wexOTYuQeVPqbxMGtBRMMMhakBIUIzDt",
                                   :site => "https://api.discogs.com")
    @access_token = OAuth::AccessToken.new(consumer, oauth_token, oauth_token_secret)

    puts "fetching page 1"
    fetch_page

    loop do
      puts "fetchig next page"
      sleep(2)
      fetch_page
      break if @query.completed_page >= @query.total_pages 
    end
  end

  def fetch_page
    puts "getting result"
    puts "'#{@query.query_url}'"
    @search = @access_token.get(@query.query_url)
    puts "got it"
    @search = JSON.parse(@search.body)
    puts "result"
    puts @search

    @records = []
    @search["results"].each do |result|
      # index just gives num wants
      if (result["community"]["want"] > Rails.configuration.x.thresholds[:num_wants])
        @records << result
      end
    end

    puts "length: #{@records.length}"


    @records.each do |record|
      puts "sleeping..."
      sleep(2) #respect their ratelimit
      puts "looking at a record"
      puts record["type"]

      if record["type"] == "master"
        master = @access_token.get('/masters/'+record["master_id"].to_s)
        master = JSON.parse(master.body)
        record = @access_token.get('/releases/'+master["main_release"].to_s)
        record = JSON.parse(record.body)

        # if the master and the record are the same year then lets go with that
        # this filters out reissues and stuff which are usually noisy
        if master['year'] != record['year']
          puts "skipping #{record['title']} - #{record['artists'][0]['name']}"
          next
        end
      else
        record = @access_token.get('/releases/'+record["id"].to_s)
        record = JSON.parse(record.body)
      end
      
      # puts record
      if (record && record["community"] &&
          record["community"]["rating"]["average"].to_f > Rails.configuration.x.thresholds[:rating] &&
          record["community"]["rating"]["count"].to_f > Rails.configuration.x.thresholds[:num_ratings])
        puts 'rating is good, fetching pricing'
        puts record["uri"]
        # grab its median sale -- TODO: they broke this
        # require 'open-uri'
        begin
=begin
          sleep(1.1) # respect this lookup ratelimit too
          page = Nokogiri::HTML(open(record["uri"], :read_timeout => 5, 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'))

          if page.css('.statistics .last li')
            puts page.css('.statistics .last li')
            median_price = page.css('.statistics .last li')[2].text[/\d+(\.\d{1,2})?/].to_f
            puts page.css('.statistics .last li')
            high_price = page.css('.statistics .last li')[3].text[/\d+(\.\d{1,2})?/].to_f
          end

          if median_price < Rails.configuration.x.thresholds[:median_price]
            puts "median price not high enough, skpping"
          else
=end
            puts "adding "+record["title"]

            sleep(2.0)
            # get suggested pricing 
            pricing = @access_token.get("/marketplace/price_suggestions/#{record["id"]}")
            pricing = JSON.parse(pricing.body)
            puts pricing

            Record.create(
              rating: record["community"]["rating"]["average"],
              count: record["community"]["rating"]["count"],
              want: record["community"]["want"],
              title: record["title"],
              uri: record["uri"],
              # median_price: median_price,
              # high_price: high_price,
              discogs_id: record["id"],
              query_id: @query.id,
              country: record["country"],
              year: record["year"],
              genres: record["genres"].to_json,
              videos: record["videos"].to_json,
              artists: record["artists"].to_json,
              pricing: pricing.to_json,
              thumb: record["thumb"],
            )
          # end
        rescue Exception => e
          puts "error:"
          puts e
        end
      end
      puts "done this record"
    end

    @query.total_pages = @search["pagination"]["pages"]
    @query.completed_page = @search["pagination"]["page"]
    @query.save
  end
end
