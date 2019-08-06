class Group < ApplicationRecord
  has_many :groups_students, dependent: :destroy
  has_many :students, through: :groups_students
end
