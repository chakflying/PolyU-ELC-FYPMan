class GroupsSupervisor < ApplicationRecord
  belongs_to :group
  belongs_to :supervisor
end
