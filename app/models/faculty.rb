# frozen_string_literal: true

class Faculty < ApplicationRecord
  auto_strip_attributes :name, squish: true

  validates :name, presence: true, length: { maximum: 255 }
  validates :code, length: { maximum: 8 }
  has_many :departments
  belongs_to :university, optional: true

  def code=(val)
    write_attribute(:code, val.upcase) unless val.blank?
  end
end
