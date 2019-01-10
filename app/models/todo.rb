class Todo < ApplicationRecord
    validates :title, presence: true, length: { maximum: 255 }
    validates :eta, presence: true
    validates :color, presence: true, length: { maximum: 10 }
    belongs_to :department, optional: true

    def as_json(options = {})
        output = super
        if self.department
            output[:department] = {}
            output[:department][:id] = self.department.id
            output[:department][:name] = self.department.name
        end
        return output
    end

end