ActiveAdmin.register Record do
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
    column :title
    column :uri do |record|
      link_to record.uri, record.uri, target: :blank
    end
    column :query
  end
end
