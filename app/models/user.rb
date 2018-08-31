class User < ApplicationRecord
    before_save { self.email = email.downcase }
    validates :username, presence: true, length: { maximum: 25 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 8 }, if: -> {new_record? || changes[:password_digest]}
end
