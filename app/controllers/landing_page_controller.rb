class LandingPageController < ApplicationController
  def index
    if logged_in?
      redirect_to '/students'
    end
  end
end
