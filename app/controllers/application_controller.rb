class ApplicationController < ActionController::Base
  before_action :authenticate_with_discogs

  def authenticate_with_discogs
    if params[:oauth_token]
      @request_token = session[:request_token]
      @access_token = @request_token.get_access_token(
        oauth_token: params[:oauth_token], 
        oauth_verifier: params[:oauth_verifier]
      )
      session[:access_token] = @access_token
      redirect_to "/"
    else
      if session[:access_token].nil?
        @callback_url = root_url+"oauth/callback"
        @consumer = OAuth::Consumer.new(ENV["DISCOGS_CLIENT_ID"],
                                        ENV["DISCOGS_CLIENT_SECRET"],
                                        :site => "https://api.discogs.com")
        @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
        session[:request_token] = @request_token
        redirect_to @request_token.authorize_url(:oauth_callback => @callback_url).gsub("api.","www.")
      else
        @access_token = session[:access_token]
      end
    end
  end
end
