ActiveAdmin.register Query do
  permit_params :query_string, :completed_page, :total_pages

  index do
    column :query_string
    column :completed_page
    column :total_pages
    column "Total Records" do |q|
      q.records.count
    end
    column "Records" do |q|
      link_to "View Records", "/admin/records?q[query_id_eq]=#{q.id}"
    end
    column "YT Playlist" do |q|
      all_video_ids = []
      q.records.order(rating: :desc).each do |record|
        record.videos
        # puts record.videos
        begin
        videos = JSON.parse(record.videos)
        # puts videos
        video_ids = videos.map do |v|
          /(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})/.match(v["uri"])[1]
        end
        all_video_ids += video_ids
        rescue
        end
      end

      url = "https://www.youtube.com/embed/#{all_video_ids[0]}?showinfo=1&playlist=#{all_video_ids.join(',')}&controls=1&loop=1&autoplay=1"
      link_to "open the youtube playlist", url, target: "_blank", onclick: "window.open(this.href,'vids', 'height=600, width=600');return false;"
    end
    actions defaults: false do |q|
      item "Edit", edit_admin_query_path(q), class: "member_link"
      item "Start Job", start_admin_query_path(q), method: :put, class: "member_link"
    end
  end

  member_action :start, method: :put do
    RunQueryJob.perform_later(resource.id, session[:access_token].token, session[:access_token].secret)
    redirect_to admin_queries_path, notice: "Started!"
  end
end
