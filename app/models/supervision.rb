class Supervision < ApplicationRecord
  belongs_to :student
  belongs_to :supervisor
  has_paper_trail on: [:create, :destroy, :update]
end