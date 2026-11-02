class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_password, validations: false

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:password_digest] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  has_many :diaries, dependent: :destroy
  has_many :plans, dependent: :destroy

end
