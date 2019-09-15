class GroupsSupervisor < ApplicationRecord
  belongs_to :group
  belongs_to :supervisor
  has_paper_trail on: %i[create destroy update]
end
