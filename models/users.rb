class User < ActiveRecord::Base

  validates_presence_of :name

  has_many :spacesUser
  has_many :spaces , through: :spacesUser

end
