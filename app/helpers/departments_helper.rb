# frozen_string_literal: true

module DepartmentsHelper
  # Return list of department names and ids.
  def get_departments_list(u_id = nil)
    @departments_list = []
    if u_id.blank?
      Department.all.each do |dep|
        @departments_list.push([dep.name, dep.id])
      end
    else
      University.find(u_id).faculties.includes(:departments).each do |fac|
        fac.departments.each do |dep|
          @departments_list.push([dep.name, dep.id])
        end
      end
    end
    @departments_list
  end
end
