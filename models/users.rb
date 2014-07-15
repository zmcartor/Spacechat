class User < ActiveRecord::Base

  validates_presence_of :name
  validates_presence_of :id #ids are already set in POST

  has_many :spaces_users
  has_many :spaces , through: :spaces_users

  def self.can_access_space?(blah, space_id)
    User.exists?(blah) && User.find(blah).spaces.pluck(:id).include?(space_id)
  end

end
