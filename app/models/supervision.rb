# frozen_string_literal: true

class Supervision < ApplicationRecord
  belongs_to :student
  belongs_to :supervisor
  has_paper_trail on: %i[create destroy update]
end
