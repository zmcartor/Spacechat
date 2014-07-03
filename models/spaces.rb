class Space < ActiveRecord::Base

  has_many :messages
  has_many :spacesUser
  has_many :users, through: :spacesUser

end
