# frozen_string_literal: true

module FacultiesHelper
  # Return list of faculty names and ids.
  def get_faculties_list
    @faculties_list = []
    Faculty.all.each do |fac|
      @faculties_list.push([fac.name, fac.id])
    end
    @faculties_list
  end
end
