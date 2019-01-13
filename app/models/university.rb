class University < ApplicationRecord
    auto_strip_attributes :name, squish: true

    validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
    validates :code, length: { maximum: 8 }, uniqueness: { case_sensitive: false }
    has_many :departments
    has_many :faculties

    def code=(val)
        write_attribute(:code, val.upcase) unless val.nil?
    end
end