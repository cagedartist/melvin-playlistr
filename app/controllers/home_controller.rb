class HomeController < ApplicationController
  before_filter :require_no_user  
  def index
    @user_session = UserSession.new
    @user = User.new
  end

end
