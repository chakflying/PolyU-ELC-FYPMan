# frozen_string_literal: true

class Student < ApplicationRecord
  auto_strip_attributes :name, squish: true
  auto_strip_attributes :netID

  validates :name, length: { maximum: 255 }
  validates :netID, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validate :netID_crossunique
  validates :fyp_year, presence: true, length: { maximum: 9 }
  has_many :supervisions
  has_many :supervisors, through: :supervisions
  belongs_to :department
  has_many :groups_students, dependent: :destroy
  has_many :groups, through: :groups_students

  delegate :faculty, to: :department, allow_nil: true
  delegate :faculty_id, to: :department, allow_nil: true
  delegate :university, to: :faculty, allow_nil: true
  delegate :university_id, to: :faculty, allow_nil: true
  has_paper_trail on: %i[create destroy update]

  def netID_crossunique
    if Supervisor.find_by(netID: netID)
      errors.add(:base, 'There is already a Supervisor with this netID.')
    end
  end
end
