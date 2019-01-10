class Department < ApplicationRecord
    auto_strip_attributes :name, squish: true

    validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
    validates :code, length: { maximum: 10 }, uniqueness: { case_sensitive: false }
    has_many :students
    has_many :supervisors
    has_many :users
    has_many :todos

    def code=(val)
        write_attribute :code, val.upcase
    end
end
