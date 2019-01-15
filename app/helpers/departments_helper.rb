# frozen_string_literal: true

module DepartmentsHelper
  def get_departments_list
    @departments_list = []
    Department.all.each do |dep|
      @departments_list.push([dep.name, dep.id])
    end
    @departments_list
  end
end
