class Student < ApplicationRecord
    validates :name, length: { maximum: 255 }
    validates :netID, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
    validates :fyp_year, presence: true, length: { maximum: 9 }
    has_and_belongs_to_many :supervisors

end