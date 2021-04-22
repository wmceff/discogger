ActiveAdmin.register Query do
  permit_params :query_string, :current_page, :total_pages

  index do
    column :query_string
    column "Records" do |q|
      link_to "View Records", "/admin/records?q[query_id_eq]=#{q.id}"
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
