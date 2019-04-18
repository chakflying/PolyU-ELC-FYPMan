# frozen_string_literal: true

module UniversitiesHelper
  # Return list of department names and ids.
  def get_universities_list
    @universities_list = []
    University.all.each do |uni|
      @universities_list.push([uni.name, uni.id])
    end
    @universities_list
  end
end
