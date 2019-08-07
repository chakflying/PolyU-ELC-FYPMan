class Group < ApplicationRecord
  has_many :groups_students, dependent: :destroy
  has_many :groups_supervisors, dependent: :destroy
  has_many :students, through: :groups_students
  has_many :supervisors, through: :groups_supervisors
end
