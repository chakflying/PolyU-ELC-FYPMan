class Student < ApplicationRecord
    auto_strip_attributes :name, squish: true
    auto_strip_attributes :netID

    validates :name, length: { maximum: 255 }
    validates :netID, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
    validate :netID_crossunique
    validates :fyp_year, presence: true, length: { maximum: 9 }
    has_and_belongs_to_many :supervisors
    belongs_to :department
    has_paper_trail

    def netID_crossunique
        if Supervisor.find_by(netID: netID)
            errors.add(:base, "There is already a Supervisor with this netID.")
        end
    end
    
end
