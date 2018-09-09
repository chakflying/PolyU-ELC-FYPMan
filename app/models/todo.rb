class Todo < ApplicationRecord
    validates :title, presence: true, length: { maximum: 255 }
    validates :eta, presence: true

end