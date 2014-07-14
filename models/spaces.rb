require 'SecureRandom'
class Space < ActiveRecord::Base

  has_many :messages
  has_many :spaces_users
  has_many :users, through: :spaces_users

  def self.create_invite_code
    code = SecureRandom.urlsafe_base64(5).downcase!
    while(Space.exists?({invite_code: code}))
      code = SecureRandom.urlsafe_base64(5).downcase!
    end
    return code
  end

end
