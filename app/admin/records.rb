ActiveAdmin.register Record do
  config.sort_order = "rating_desc"
  config.per_page = 5000
  # belongs_to :query
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  index do
    column :rating
    column :count
    column :want
    column "Suggested Price" do |record|
      unless record.pricing.nil?
      begin
        "$#{JSON.parse(record.pricing)["Mint (M)"]["value"].round(2)}"
      rescue
      end
      end
    end
    column :artists do |record|
      unless record.artists.nil?
      begin
        JSON.parse(record.artists).map{|a|a["name"]}.join(",")
      rescue JSON::ParserError
      end
      end
    end
    column :title do |record|
      link_to record.title, record.uri, target: :blank
    end
    column :genres do |record|
      unless record.genres.nil?
      begin
        JSON.parse(record.genres).join(",")
      rescue JSON::ParserError
      end
      end
    end
    column :styles
    column :videos do |record|
      if record.videos.nil? || record.videos == "null"
        ''
      else
        record.videos
        # puts record.videos
        videos = JSON.parse(record.videos)
        # puts videos
        video_ids = videos.map do |v|
          /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/.match(v["uri"])[1]
        end

        url = "https://www.youtube.com/embed/#{video_ids[0]}?showinfo=1&playlist=#{video_ids.join(',')}&controls=1&loop=1&autoplay=1"

        link_to "open the youtube playlist", url, target: "_blank", onclick: "window.open(this.href,'create_company', 'height=600, width=600');return false;"
      end
    end
    column :query
  end
end
