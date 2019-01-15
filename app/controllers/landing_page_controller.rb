# frozen_string_literal: true

class LandingPageController < ApplicationController
  def index
    redirect_to '/students' if logged_in?
  end
end
