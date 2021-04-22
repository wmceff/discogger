ActiveAdmin.register Query do
  permit_params :query_string, :current_page, :total_pages

  index do
    column :query_string
    column "view records" do |q|
      link_to "view", "/admin/records?q[query_id_eq]=#{q.id}"
    end
  end

  member_action :start, method: :put do
    RunQueryJob.perform_later(resource.id, session[:access_token].token, session[:access_token].secret)
    redirect_to resource_path, notice: "Started!"
  end
end
