class WelcomeController < ApplicationController
  def index

    @query = Query.last

    if (@query.completed_page.present? and @query.completed_page >= @query.total_pages)
      @done = true
    else 

      @search = @access_token.get(@query.query_url)
      @search = JSON.parse(@search.body)

      @records = []
      @search["results"].each do |result|
        if (result["community"]["want"] > 50) #all we get is the number of wants in this index
          @records << result
        end
      end

      @records.each do |record|
        sleep(1)
        record = @access_token.get('/releases/'+record["id"].to_s)
        record = JSON.parse(record.body)
        if (record and record["community"] and record["community"]["rating"]["average"] > 4.5 and record["community"]["rating"]["count"] > 5)
          if (Record.find_by(discogs_id: record["id"]).nil?)
            Record.create(
              rating: record["community"]["rating"]["average"],
              count: record["community"]["rating"]["count"],
              want: record["community"]["want"],
              title: record["title"],
              uri: record["uri"],
              discogs_id: record["id"]
            )
          end
        end
      end

      @query.total_pages = @search["pagination"]["pages"]
      @query.completed_page = @search["pagination"]["page"]
      @query.save
    end
  end
end
