class User < ActiveRecord::Base
  validates_presence_of :email, :full_name
  validates_uniqueness_of :email
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  has_secure_password validations: false
end