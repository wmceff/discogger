class WelcomeController < ApplicationController
  def index
    redirect_to "/admin/queries"
  end
end
