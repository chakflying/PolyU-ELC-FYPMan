module FacultiesHelper
    def get_faculties_list
        @faculties_list = []
        Faculty.all.each do |fac|
          @faculties_list.push([fac.name, fac.id])
        end
        return @faculties_list
    end
end