# frozen_string_literal: true

class LandingPageController < ApplicationController
  def index
    redirect_to students_url if logged_in?
  end
end
