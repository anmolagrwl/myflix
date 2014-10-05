class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :email, :full_name

  validates :password, presence: true, length: { minimum: 6 }, on: :create
end