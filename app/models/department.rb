# frozen_string_literal: true

class Department < ApplicationRecord
  auto_strip_attributes :name, squish: true

  validates :name, presence: true, length: { maximum: 255 }
  validates :code, length: { maximum: 10 }
  validates :name, uniqueness: { scope: :faculty, message: ': There is already a department in this faculty with the same name', allow_blank: true, case_sensitive: false }
  validates :code, uniqueness: { scope: :faculty, message: ': There is already a department in this faculty with the same code', allow_blank: true, case_sensitive: false }
  has_many :students
  has_many :supervisors
  has_many :users
  has_many :todos
  belongs_to :faculty, optional: true
  delegate :university, to: :faculty, allow_nil: true
  has_paper_trail on: %i[create destroy update]

  def code=(val)
    write_attribute(:code, val.upcase) unless val.blank?
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
