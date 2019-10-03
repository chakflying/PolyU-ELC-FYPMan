# frozen_string_literal: true

class ErrorsController < ApplicationController
  # ErrorsController is used to show custom error pages.

  def show
    status_code = params[:code] || '500'
    case status_code
    when '404'
      render '404', status: status_code
    when '500'
      render '500', status: status_code
    when '422'
      render '422', status: status_code
    when '503'
      render '503', status: status_code
    end
  end
end
