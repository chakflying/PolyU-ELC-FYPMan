# frozen_string_literal: true

class Department < ApplicationRecord
  auto_strip_attributes :name, squish: true

  validates :name, presence: true, length: { maximum: 255 }
  validates :code, length: { maximum: 10 }
  validates_uniqueness_of :code, allow_blank: true
  has_many :students
  has_many :supervisors
  has_many :users
  has_many :todos
  belongs_to :faculty, optional: true
  has_paper_trail on: [:create, :destroy, :update]

  def code=(val)
    write_attribute(:code, val.upcase) unless val.blank?
  end

  def university
    faculty.university
  end

  def self.check_synced(sync_id)
    return nil if sync_id.blank?
    if dep = Department.find_by(sync_id: sync_id)
      return dep.id
    else
      return nil
    end
  end
end
