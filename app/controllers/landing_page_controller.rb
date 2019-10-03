# frozen_string_literal: true

class LandingPageController < ApplicationController
  # LandingPage Controller handles the login page.
  def index
    redirect_to students_url if logged_in?
  end
end
