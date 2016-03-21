class ApplicationController < ActionController::Base
  before_action :authenticate_with_discogs

  def authenticate_with_discogs
    logger.debug session[:request_token].inspect
    logger.debug session[:access_token].inspect
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
        @callback_url = "http://localhost:3000/oauth/callback"
        @consumer = OAuth::Consumer.new("YZoEeqSZnAghnSYoicnS",
                                        "wexOTYuQeVPqbxMGtBRMMMhakBIUIzDt",
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
