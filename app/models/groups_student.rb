class GroupsStudent < ApplicationRecord
  belongs_to :group
  belongs_to :student
  has_paper_trail on: %i[create destroy update]  
end
