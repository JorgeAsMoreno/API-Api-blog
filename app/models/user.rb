class User < ApplicationRecord
  has_many :posts
  validates :name, presence: true
  validates :email, presence: true
  validates :auth_token, presence: true
end
