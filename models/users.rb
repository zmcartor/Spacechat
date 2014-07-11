class User < ActiveRecord::Base

  validates_presence_of :name

  has_many :spacesUser
  has_many :spaces , through: :spacesUser

  def self.can_access_space?(user_id, space_id)
    User.exists?(user_id) && User.find(user_id).spaces.pluck(:id).include?(space_id)
  end

end
