class Todo < ApplicationRecord
    validates :title, presence: true, length: { maximum: 255 }
    validates :eta, presence: true
    validates :color, presence: true, length: { maximum: 10 }
    belongs_to :department, optional: true
end