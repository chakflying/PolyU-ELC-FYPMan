class Supervisor < ApplicationRecord
    validates :name, presence: true, length: { maximum: 255 }
    validates :netID, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
    validates :department, presence: true, length: { maximum: 255 }
    has_and_belongs_to_many :students
    has_paper_trail
end
