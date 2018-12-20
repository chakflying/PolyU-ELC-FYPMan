class Supervisor < ApplicationRecord
    validates :name, presence: true, length: { maximum: 255 }
    validates :netID, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
    has_and_belongs_to_many :students
    belongs_to :department
    has_paper_trail
end
