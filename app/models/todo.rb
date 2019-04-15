# frozen_string_literal: true

class Todo < ApplicationRecord
  auto_strip_attributes :title

  validates :title, presence: true, length: { maximum: 255 }
  validates :eta, presence: true
  validates :color, presence: true, length: { maximum: 10 }
  belongs_to :department, optional: true
  has_paper_trail on: %i[create destroy update]
  delegate :faculty, to: :department, allow_nil: true
  delegate :faculty_id, to: :department, allow_nil: true
  delegate :university, to: :faculty, allow_nil: true
  delegate :university_id, to: :faculty, allow_nil: true

  def as_json(options = {})
    output = super
    if department
      output[:department] = {}
      output[:department][:id] = department.id
      output[:department][:name] = department.name
    end
    output
  end
end
