# frozen_string_literal: true

class University < ApplicationRecord
  auto_strip_attributes :name, squish: true

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :code, length: { maximum: 10 }
  validates_uniqueness_of :code, allow_blank: true, case_sensitive: false
  has_many :departments, through: :faculties
  has_many :faculties

  def code=(val)
    write_attribute(:code, val.upcase) unless val.blank?
  end
end
