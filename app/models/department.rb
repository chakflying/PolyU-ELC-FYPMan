class Department < ApplicationRecord
    auto_strip_attributes :name, squish: true

    validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
    validates :code, length: { maximum: 10 }, uniqueness: { case_sensitive: false }
    has_many :students
    has_many :supervisors
    has_many :users
    has_many :todos
    belongs_to :faculty

    def code=(val)
        write_attribute(:code, val.upcase) unless val.nil?
    end

    def university
        self.faculty.university
    end

    def self.check_synced(sync_id)
        if sync_id.nil?
            return nil
        end
        if dep = Department.find_by(sync_id: sync_id)
            return dep.id
        else
            return nil
        end
    end
end
