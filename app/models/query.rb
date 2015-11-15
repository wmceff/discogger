class Query < ActiveRecord::Base
  def query_url
    if total_pages.nil?
      query_string 
    else
      if completed_page.nil?
        query_string+"&page=2"
      else
        query_string+"&page="+(completed_page + 1).to_s
      end
    end
  end
end
